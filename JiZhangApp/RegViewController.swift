//
//  RegViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/16.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
//注册界面
class RegViewController: UIViewController {
    
    let txtZhangBen = UITextField()
    let txtCName = UITextField()
    let txtLoginName = UITextField()
    let txtPass1 = UITextField()
    let txtPass2 = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        setInputForm()
        // Do any additional setup after loading the view.
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
        lbTitle.text = "开通新账本"
        lbTitle.textColor = UIColor.whiteColor()
        returnView.addSubview(lbTitle)
        lbTitle.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        btnBack.addTarget(self, action: #selector(RegViewController.btnBackClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        
        let lbZhangben = UILabel()
        lbZhangben.text = "账本名字:"
        lbZhangben.textColor = AppFontColor
        returnView.addSubview(lbZhangben)
        lbZhangben.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        txtZhangBen.borderStyle = UITextBorderStyle.RoundedRect
        returnView.addSubview(txtZhangBen)
        txtZhangBen.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(5)
            make.right.equalTo(-60)
            make.height.equalTo(40)
        }
        
        let lbCName = UILabel()
        lbCName.text = "你的大名:"
        lbCName.textColor = AppFontColor
        returnView.addSubview(lbCName)
        lbCName.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(60)
        }
        
        txtCName.borderStyle = UITextBorderStyle.RoundedRect
        returnView.addSubview(txtCName)
        txtCName.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(60)
            make.right.equalTo(-60)
            make.height.equalTo(40)
        }
        
        let lbLoginName = UILabel()
        lbLoginName.text = "登录名:"
        lbLoginName.textColor = AppFontColor
        returnView.addSubview(lbLoginName)
        lbLoginName.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(110)
        }
        
        txtLoginName.borderStyle = UITextBorderStyle.RoundedRect
        returnView.addSubview(txtLoginName)
        txtLoginName.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(110)
            make.right.equalTo(-60)
            make.height.equalTo(40)
        }
        
        let lbPass1 = UILabel()
        lbPass1.text = "登录密码:"
        lbPass1.textColor = AppFontColor
        returnView.addSubview(lbPass1)
        lbPass1.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(160)
        }
        
        txtPass1.borderStyle = UITextBorderStyle.RoundedRect
        txtPass1.secureTextEntry = true
        returnView.addSubview(txtPass1)
        txtPass1.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(160)
            make.right.equalTo(-60)
            make.height.equalTo(40)
        }
        
        let lbPass2 = UILabel()
        lbPass2.text = "确认密码:"
        lbPass2.textColor = AppFontColor
        returnView.addSubview(lbPass2)
        lbPass2.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(210)
        }
        
        txtPass2.borderStyle = UITextBorderStyle.RoundedRect
        txtPass2.secureTextEntry = true
        returnView.addSubview(txtPass2)
        txtPass2.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(210)
            make.right.equalTo(-60)
            make.height.equalTo(40)
        }
       
        let btnSave = UIButton()
        btnSave.addTarget(self, action: #selector(RegViewController.btnSaveClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnSave)
        btnSave.setImage(UIImage(named: "btn3"), forState: UIControlState.Normal)
        btnSave.snp_makeConstraints { (make) in
            make.top.equalTo(260)
            make.centerX.equalTo(self.view)
        }
    }
    
    func btnSaveClicked(sender:UIButton) {
       
        if(self.txtZhangBen.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入账本名字", view: self.view)
        } else if(self.txtCName.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入你的大名", view: self.view)
        }else if(self.txtLoginName.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入登录名", view: self.view)
        }
        else if(self.txtPass1.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入密码", view: self.view)
        }
        else if(self.txtPass1.text != self.txtPass2.text)
        {
            ViewAlertTextCommon.ShowSimpleText("两次输入密码不匹配", view: self.view)
        }
        else
        {
            let url = AppServerURL+"btsvc.asmx/AddNewAccount"
            let parameters = [
                "companyName": "\(self.txtZhangBen.text!)",
                "uName":"\(self.txtCName.text!)",
                "loginName":"\(self.txtLoginName.text!)",
                "uPass":"\(self.txtPass1.text!)"
            ]
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "努力加载数据中..."
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    print("\(json)")
                    if(json["ResultCode"] == "0")//请求成功
                    {
                        ViewAlertTextCommon.ShowSimpleText("开通账本成功,请登录", view: self.view)
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
    
    func btnBackClicked(sender:UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
