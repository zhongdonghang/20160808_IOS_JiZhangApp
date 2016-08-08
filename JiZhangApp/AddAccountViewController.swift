//
//  AddAccountViewController.swift
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

class AddAccountViewController: BaseViewController {
    let txtZhangben = UITextField()
    let txtYuE = UITextField()
    
    var op:String = "add"
    var model:SimpleAccountModel!
    
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
        if(op=="add")
        {
            lbTitle.text = "添加新账本"
        }else{
            lbTitle.text = "编辑账本"
        }
        lbTitle.textColor = UIColor.whiteColor()
        returnView.addSubview(lbTitle)
        lbTitle.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        btnBack.addTarget(self, action:#selector(AddAccountViewController.btnBackClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        lbZhangben.text = "帐本名:"
        lbZhangben.textColor = AppFontColor
        returnView.addSubview(lbZhangben)
        lbZhangben.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        txtZhangben.borderStyle = UITextBorderStyle.RoundedRect
        if(op=="edit")
        {
            txtZhangben.text = model.CNAME
        }
        returnView.addSubview(txtZhangben)
        txtZhangben.snp_makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalTo(5)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        
        let lbYuE = UILabel()
        lbYuE.text = "余    额:"

        lbYuE.textColor = AppFontColor
        returnView.addSubview(lbYuE)
        lbYuE.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(60)
        }
        
        txtYuE.borderStyle = UITextBorderStyle.RoundedRect
        if(op=="edit")
        {
            txtYuE.text = model.BALANCE
        }
         txtYuE.keyboardType = UIKeyboardType.DecimalPad
        returnView.addSubview(txtYuE)
        txtYuE.snp_makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalTo(60)
            make.right.equalTo(-30)
            make.height.equalTo(40)
        }
        let btnSave = UIButton()
        btnSave.addTarget(self, action: #selector(AddAccountViewController.btnSaveClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnSave)
        btnSave.setImage(UIImage(named: "btn3"), forState: UIControlState.Normal)
        btnSave.snp_makeConstraints { (make) in
            make.top.equalTo(120)
            make.centerX.equalTo(self.view)
        }
    }
    
    func btnSaveClicked(sender:UIButton) {
        if(self.txtZhangben.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入账本名", view: self.view)
        }else if(self.txtYuE.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入初始额度", view: self.view)
        }
        else if(self.txtZhangben.text == "基本户")
        {
            ViewAlertTextCommon.ShowSimpleText("基本户是保留账本，不能取这个名字", view: self.view)
        }
        else
        {
           if(op=="add")
           {
            let url = AppServerURL+"btsvc.asmx/AddAccount"
            let parameters = [
                "CNAME": "\(self.txtZhangben.text!)",
                "BALANCE":"\(self.txtYuE.text!)",
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
                        ViewAlertTextCommon.ShowSimpleText("成功添加一个账本", view: self.view)
                        self.txtZhangben.text = ""
                        self.txtYuE.text = ""
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
           }else{//编辑
            let url = AppServerURL+"btsvc.asmx/EditAccount"
            let parameters = [
                "OID": "\(model.OID)",
                "NewName":"\(self.txtZhangben.text!)",
                "NewBALANCE":"\(self.txtYuE.text!)"
            ]
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "处理中..."
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    print("\(json)")
                    if(json["ResultCode"] == "0")//请求成功
                    {
                        ViewAlertTextCommon.ShowSimpleText("\(json["Msg"])", view: self.view)
                        self.txtZhangben.text = ""
                        self.txtYuE.text = ""
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
            }//编辑结束
            }
        }
        
    }
    
    func btnBackClicked(sender:UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
