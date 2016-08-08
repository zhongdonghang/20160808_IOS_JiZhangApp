//
//  AddUserViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/20.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class AddUserViewController: BaseViewController {

    let txtCname = UITextField()
    let txtLoginName = UITextField()
    let txtBeiZhu = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        setInputForm()
        // Do any additional setup after loading the view.
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
        lbTitle.text = "添加用户"
        lbTitle.textColor = UIColor.whiteColor()
        returnView.addSubview(lbTitle)
        lbTitle.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        btnBack.addTarget(self, action: #selector(AddUserViewController.btnBackClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        lbCName.text = "昵    称:"
        lbCName.textColor = AppFontColor
        returnView.addSubview(lbCName)
        lbCName.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        txtCname.borderStyle = UITextBorderStyle.RoundedRect
        returnView.addSubview(txtCname)
        txtCname.snp_makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalTo(5)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        let lbLoginName = UILabel()
        lbLoginName.text = "登录名:"
        lbLoginName.textColor = AppFontColor
        returnView.addSubview(lbLoginName)
        lbLoginName.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(60)
        }
        
        txtLoginName.borderStyle = UITextBorderStyle.RoundedRect
        returnView.addSubview(txtLoginName)
        txtLoginName.snp_makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalTo(60)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        let lbBeiZhu = UILabel()
        lbBeiZhu.text = "备    注:"
        lbBeiZhu.textColor = AppFontColor
        returnView.addSubview(lbBeiZhu)
        lbBeiZhu.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(110)
        }
        
        returnView.addSubview(txtBeiZhu)
        txtBeiZhu.layer.borderWidth = 1
        txtBeiZhu.layer.borderWidth = 0.6
        txtBeiZhu.layer.cornerRadius = 6.0
        txtBeiZhu.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        returnView.addSubview(txtBeiZhu)
        txtBeiZhu.snp_makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalTo(110)
            make.right.equalTo(-30)
            make.height.equalTo(60)
        }

        let btnSave = UIButton()
        btnSave.addTarget(self, action: #selector(AddUserViewController.btnSaveClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnSave)
        btnSave.setImage(UIImage(named: "btn3"), forState: UIControlState.Normal)
        btnSave.snp_makeConstraints { (make) in
            make.top.equalTo(180)
            make.centerX.equalTo(self.view)
        }
        
        let lbInfo = UILabel()
        lbInfo.numberOfLines = 0
        lbInfo.text = "提示：添加附属用户\n默认密码是123456"
        lbInfo.textColor = AppFontColor
        returnView.addSubview(lbInfo)
        lbInfo.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(230)
        }
    }
    
    func btnSaveClicked(sender:UIButton) {
        if(self.txtCname.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入昵称", view: self.view)
        }else if(self.txtLoginName.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入登录名", view: self.view)
        }
        else
        {
            let url = AppServerURL+"btsvc.asmx/CreateLoginUser"
            let parameters = [
                "CNAME": "\(self.txtCname.text!)",
                "LOGIN_NAME":"\(self.txtLoginName.text!)",
                "MEMO":"\(self.txtBeiZhu.text!)",
                "COMPANYID":"\(LoginUserTools.getLoginUser().COMPANYID)"
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
                        ViewAlertTextCommon.ShowSimpleText("成功添加一个登录用户", view: self.view)
                        self.txtCname.text = ""
                        self.txtLoginName.text = ""
                        self.txtBeiZhu.text = ""
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
