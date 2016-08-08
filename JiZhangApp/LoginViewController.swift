//
//  LoginViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/5/30.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController,UITextFieldDelegate {

    let txtName = UITextField()
    let txtPsd = UITextField()
    var inputNameBgView = UIImageView()
    var inputPsdBgView = UIImageView()
    let REQUEST_METHOD = "btsvc.asmx/Login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        setLogoView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initView() -> Void {
        self.view.backgroundColor = AppBgColor
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: "UIKeyboardWillShowNotification", object: nil)
    }
    
    //设定顶部标题栏视图
    func setTopBannerView() {
        let returnView = UIView(frame: CGRectMake(0, 20,  self.view.bounds.width, 44))
        returnView.backgroundColor = AppColor
        self.view.addSubview(returnView)
        let titleImgView = UIImageView(image: UIImage(named: "logintitle"))
        returnView.addSubview(titleImgView)
        titleImgView.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
    }
    
    func setLogoView() {
        let logoImgView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(logoImgView)
        logoImgView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(80)
        }
        
        let loginTextImgView = UIImageView(image: UIImage(named: "login_text"))
        self.view.addSubview(loginTextImgView)
        loginTextImgView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(220)
        }
        
        let vLogin = UIView()
        self.view.addSubview(vLogin)
        vLogin.snp_makeConstraints { (make) in
            make.top.equalTo(250)
            make.centerX.equalTo(self.view)
            make.width.equalTo(337)
            make.height.equalTo(200)
        }
        
        inputNameBgView = UIImageView(image: UIImage(named: "logininput1"))
        inputNameBgView.userInteractionEnabled = true
        vLogin.addSubview(inputNameBgView)
        inputNameBgView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(10	)
        }
        
        let login_bg1View = UIImageView(image: UIImage(named: "login_bg1"))
        inputNameBgView.addSubview(login_bg1View)
        login_bg1View.snp_makeConstraints { (make) in
            make.centerY.equalTo(inputNameBgView)
            make.left.equalTo(5)
        }
        
        
        txtName.delegate=self
        txtName.tag = 1
        inputNameBgView.addSubview(txtName)
        txtName.snp_makeConstraints { (make) in
            make.bottom.equalTo(-2)
            make.top.equalTo(1)
            make.right.equalTo(-5)
            make.left.equalTo(25)
        }
        
        inputPsdBgView = UIImageView(image: UIImage(named: "logininput1"))
        inputPsdBgView.userInteractionEnabled = true
        vLogin.addSubview(inputPsdBgView)
        inputPsdBgView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(50	)
        }
        
        let login_bg2View = UIImageView(image: UIImage(named: "login_bg2"))
        inputPsdBgView.addSubview(login_bg2View)
        login_bg2View.snp_makeConstraints { (make) in
            make.centerY.equalTo(inputPsdBgView)
            make.left.equalTo(5)
        }
        
        
        txtPsd.delegate=self
        txtPsd.tag = 2
        txtPsd.secureTextEntry=true
        inputPsdBgView.addSubview(txtPsd)
        txtPsd.snp_makeConstraints { (make) in
            make.bottom.equalTo(-2)
            make.top.equalTo(1)
            make.right.equalTo(-5)
            make.left.equalTo(25)
        }
        
        
        let btnLogin = UIButton()
        self.view.addSubview(btnLogin)
        btnLogin.setImage(UIImage(named: "btnLogin"), forState: UIControlState.Normal)
        btnLogin.addTarget(self, action: #selector(LoginViewController.btnLoginClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnLogin.snp_makeConstraints { (make) in
            make.top.equalTo(350)
            make.centerX.equalTo(self.view)
        }
        
        let btnReg = UIButton()
        self.view.addSubview(btnReg)
        btnReg.addTarget(self, action: #selector(LoginViewController.btnRegClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnReg.setImage(UIImage(named: "btnReg"), forState: UIControlState.Normal)
        btnReg.snp_makeConstraints { (make) in
            make.top.equalTo(400)
            make.centerX.equalTo(self.view)
        }
    }
    
    func btnRegClicked(sender:UIButton) {
        let regViewController = RegViewController()
        self.presentViewController(regViewController, animated: true, completion: nil)
    }
    
    func btnLoginClicked(sender:UIButton) {
        
        if(self.txtName.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入登录名", view: self.view)
        }
        else if(self.txtPsd.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入密码", view: self.view)
        }
        else
        {
            let parameters = [
                "LoginName": "\(self.txtName.text!)",
                "PWD": "\(self.txtPsd.text!)"
            ]
            let url = AppServerURL+REQUEST_METHOD
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "登录验证..."//showHUDAddedTo
           
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    if(json["ResultCode"] == "0")//登录成功
                    {
                        let loginUser:SimpleLoginUserModel = SimpleLoginUserModel(LOGIN_NAME: "\(json["t"]["LOGIN_NAME"])")
                        loginUser.LOGIN_NAME = "\(json["t"]["LOGIN_NAME"])"
                        loginUser.CRDTIME = "\(json["t"]["CRDTIME"])"
                        loginUser.LOGIN_PWD = "\(json["t"]["LOGIN_PWD"])"
                        loginUser.MEMO = "\(json["t"]["MEMO"])"
                        loginUser.MODTIME = "\(json["t"]["MODTIME"])"
                        loginUser.CNAME = "\(json["t"]["CNAME"])"
                        loginUser.CRDON = "\(json["t"]["CRDON"])"
                        loginUser.OID = "\(json["t"]["OID"])"
                        loginUser.MODON = "\(json["t"]["MODON"])"
                        loginUser.COMPANYID = "\(json["t"]["COMPANYID"])"
                        
                        ViewAlertTextCommon.ShowSimpleText("登录成功", view: self.view)
                        
                        let user:NSData = NSKeyedArchiver.archivedDataWithRootObject(loginUser)
                        let sysDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        sysDefaults.setObject(user, forKey: "LOGIN_USER")
                        sysDefaults.synchronize()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }else
                    {
                        let text = "\(json["Msg"])"
                        ViewAlertTextCommon.ShowSimpleText(text, view: self.view)
                    }
                case.Failure(let error):
                    let alert = UIAlertView(title: "错误消息", message: "异常:\(error)", delegate: self, cancelButtonTitle: "好")
                    alert.show()
                }
                hud.removeFromSuperview()
            }

        }
    }
    
    func keyboardWillShow(note:NSNotification)
    {
        let keyboardinfo = note.userInfo![UIKeyboardFrameBeginUserInfoKey]
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        let _keyBoardHeight = keyboardheight
        let frame = txtPsd.frame
        let offset = frame.origin.y + 32 - (self.view.frame.size.height - _keyBoardHeight)
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        if(self.view.frame.height == 568)//iphone 5s
        {
            if(offset < 0)
            {
                self.view.frame = CGRectMake(0.0, -150, self.view.frame.size.width, self.view.frame.size.height)
            }
        }
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if(textField.tag == 1)
        {
            inputNameBgView.image = UIImage(named: "logininput1_hover")
            inputPsdBgView.image = UIImage(named: "logininput1")
        }
        if(textField.tag == 2)
        {
            inputNameBgView.image = UIImage(named: "logininput1")
            inputPsdBgView.image = UIImage(named: "logininput1_hover")
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
