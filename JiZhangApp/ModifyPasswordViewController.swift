//
//  ModifyPasswordViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/10.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ModifyPasswordViewController: BaseViewController {

    let txtOldPass1=UITextField()
    let txtNewPass1=UITextField()
    let txtNewPass2=UITextField()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        setInputForm()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() -> Void {
        self.view.backgroundColor = AppBgColor
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //设定顶部标题栏视图
    func setTopBannerView() {
        let returnView = UIView(frame: CGRectMake(0, 20,  self.view.bounds.width, 44))
        returnView.backgroundColor = AppColor
        self.view.addSubview(returnView)
        let lbTitle = UILabel()
        lbTitle.text = "修改密码"
        lbTitle.textColor = UIColor.whiteColor()
        returnView.addSubview(lbTitle)
        lbTitle.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        btnBack.addTarget(self, action: #selector(AboutMeViewController.btnBackClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnBack)
        btnBack.snp_makeConstraints { (make) in
            make.centerY.equalTo(returnView)
            make.left.equalTo(10)
        }
        
    }
    
    //设定输入表单的视图
    func setInputForm() -> Void {
        
        let returnView = UIView(frame: CGRectMake(0, 0,  self.view.bounds.width, 400))
        let scrollView:UIScrollView = UIScrollView(frame: CGRectMake(0, 80, self.view.bounds.width, self.view.bounds.height))
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSizeMake(self.view.bounds.width, self.view.bounds.height+200)
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.scrollEnabled = true
        scrollView.addSubview(returnView)
        
        let lbCName = UILabel()
        lbCName.text = "当前登录:"
        lbCName.textColor = AppFontColor
        returnView.addSubview(lbCName)
        lbCName.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }

        
        let lbCNameValue = UILabel()
        lbCNameValue.text = LoginUserTools.getLoginUser().LOGIN_NAME
        lbCNameValue.textColor = AppFontColor
        returnView.addSubview(lbCNameValue)
        lbCNameValue.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(10)
        }
        
        let lbOldPass = UILabel()
        lbOldPass.text = "旧密码:"
        lbOldPass.textColor = AppFontColor
        returnView.addSubview(lbOldPass)
        lbOldPass.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(50)
        }

        txtOldPass1.borderStyle = UITextBorderStyle.RoundedRect
        txtOldPass1.secureTextEntry = true
        returnView.addSubview(txtOldPass1)
        txtOldPass1.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(40)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }

        let lbNewPass1 = UILabel()
        lbNewPass1.text = "新密码:"
        lbNewPass1.textColor = AppFontColor
        returnView.addSubview(lbNewPass1)
        lbNewPass1.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(100)
        }

        txtNewPass1.borderStyle = UITextBorderStyle.RoundedRect
        txtNewPass1.secureTextEntry = true
        returnView.addSubview(txtNewPass1)
        txtNewPass1.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(90)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }

        let lbNewPass2 = UILabel()
        lbNewPass2.text = "确认密码:"
        lbNewPass2.textColor = AppFontColor
        returnView.addSubview(lbNewPass2)
        lbNewPass2.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(150)
        }
        
        txtNewPass2.borderStyle = UITextBorderStyle.RoundedRect
        txtNewPass2.secureTextEntry = true
        returnView.addSubview(txtNewPass2)
        txtNewPass2.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(140)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        let btnSave = UIButton()
        btnSave.addTarget(self, action: #selector(ModifyPasswordViewController.btnSaveClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnSave)
        btnSave.setImage(UIImage(named: "btn3"), forState: UIControlState.Normal)
        btnSave.snp_makeConstraints { (make) in
            make.top.equalTo(190)
            make.centerX.equalTo(self.view)
        }
    }
    
    func btnSaveClicked(sender:UIButton)  {
        if(self.txtOldPass1.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入旧密码", view: self.view)
        } else if(self.txtNewPass1.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入新密码", view: self.view)
        }
        else if(self.txtNewPass1.text != self.txtNewPass2.text)
        {
            ViewAlertTextCommon.ShowSimpleText("两次输入密码不匹配", view: self.view)
        }else
        {
            let url = AppServerURL+"btsvc.asmx/ModifyPassword"
            let parameters = [
                "userOID": "\(LoginUserTools.getLoginUser().OID)",
                "oldPass":"\(self.txtOldPass1.text!)",
                "newPass":"\(self.txtNewPass1.text!)"
            ]
            print(parameters)
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "努力加载数据中..."
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    print("\(json)")
                    if(json["ResultCode"] == "0")//请求成功
                    {
                        ViewAlertTextCommon.ShowSimpleText("密码修改成功", view: self.view)
                       
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
    
    func btnBackClicked(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
