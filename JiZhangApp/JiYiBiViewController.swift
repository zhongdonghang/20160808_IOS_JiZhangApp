//
//  JiYiBiViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/5/24.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class JiYiBiViewController: BaseViewController,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    let txtBeiZhu = UITextView()
    let btnShouRu = UIButton()
    let btnZhiChu = UIButton()
    var strOperate = "支出"
    
    let txtJinE = UITextField()
    let txtFenLei = UITextField()
    let txtZhangHu = UITextField()
    let datePicker = UIDatePicker()
    let txtShiJian = UITextField()
    
    var pickerViewFenLei:UIPickerView!
    var fenLeiList:[String] = []
    
    var pickerViewZhangHu:UIPickerView!
    var zhanghuList:[SimpleAccountModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewFenLei = UIPickerView()
        pickerViewZhangHu = UIPickerView()
        initView()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(JiYiBiViewController.keyBoardDisplay))
        self.view.addGestureRecognizer(tapGesture)
        

    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setTopBannerView()
        txtJinE.becomeFirstResponder()
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
        let titleImgView = UIImageView(image: UIImage(named: "title2"))
        returnView.addSubview(titleImgView)
        titleImgView.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
    }
    
    
    //设定输入表单的视图
    func setInputForm() -> Void {

        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(contentView)
        contentView.snp_makeConstraints { (make) in
            make.top.equalTo(66)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-100)
        }
        
        let lbJinE = UILabel()
        lbJinE.text = "金额:"
        lbJinE.textColor = AppFontColor
        contentView.addSubview(lbJinE)
        lbJinE.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(5)
        }
        
        txtJinE.tag = 1
        txtJinE.placeholder = "输入金额"
        txtJinE.delegate=self
        txtJinE.textColor = AppColor
        txtJinE.keyboardType = UIKeyboardType.DecimalPad
        txtJinE.font = UIFont.boldSystemFontOfSize(20)
        txtJinE.borderStyle = UITextBorderStyle.RoundedRect
        contentView.addSubview(txtJinE)
        txtJinE.snp_makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(1)
            make.right.equalTo(-5)
            make.height.equalTo(42)
        }

        let lbZhiChu = UILabel()
        lbZhiChu.text = "支出"
        lbZhiChu.font = UIFont.boldSystemFontOfSize(14)
        lbZhiChu.textColor = AppFontColor
        contentView.addSubview(lbZhiChu)
        lbZhiChu.snp_makeConstraints { (make) in
            make.left.equalTo(80)
            make.top.equalTo(50)
        }
        
        contentView.addSubview(btnZhiChu)
        btnZhiChu.setImage(UIImage(named: "radiobtn_y"), forState: UIControlState.Normal)
        btnZhiChu.addTarget(self, action: #selector(JiYiBiViewController.btnZhiChuClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnZhiChu.snp_makeConstraints { (make) in
            make.left.equalTo(110)
            make.top.equalTo(45)
        }
        
        
        let lbShouRu = UILabel()
        lbShouRu.text = "收入"
        lbShouRu.font = UIFont.boldSystemFontOfSize(14)
        lbShouRu.textColor = AppFontColor
        contentView.addSubview(lbShouRu)
        lbShouRu.snp_makeConstraints { (make) in
            make.left.equalTo(160)
            make.top.equalTo(50)
        }
        
        contentView.addSubview(btnShouRu)
        btnShouRu.setImage(UIImage(named: "radiobtn_n"), forState: UIControlState.Normal)
        btnShouRu.addTarget(self, action: #selector(JiYiBiViewController.btnShouRuClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnShouRu.snp_makeConstraints { (make) in
            make.left.equalTo(195)
            make.top.equalTo(45)
        }

        
        let lbFenLei = UILabel()
        lbFenLei.text = "分类:"
        lbFenLei.textColor = AppFontColor
        contentView.addSubview(lbFenLei)
        lbFenLei.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(80)
        }
        
        
        txtFenLei.delegate=self
        txtFenLei.tag = 2
        txtFenLei.textColor = AppColor
        txtFenLei.placeholder = "选择或直接输入"
        txtFenLei.font = UIFont.boldSystemFontOfSize(16)
        txtFenLei.borderStyle = UITextBorderStyle.RoundedRect
        contentView.addSubview(txtFenLei)
        txtFenLei.snp_makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(75)
            make.right.equalTo(-5)
            make.height.equalTo(40)
        }
        
        let btnFenLei:UIButton = UIButton()
        btnFenLei.setImage(UIImage(named: "fenleixuanze"), forState: UIControlState.Normal)
        btnFenLei.addTarget(self, action: #selector(JiYiBiViewController.btnFenLeiClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(btnFenLei)
        btnFenLei.snp_makeConstraints { (make) in
            make.top.equalTo(78)
            make.right.equalTo(-5)
        }
        
        let lbZhangHu = UILabel()
        lbZhangHu.text = "账户:"
        lbZhangHu.textColor = AppFontColor
        contentView.addSubview(lbZhangHu)
        lbZhangHu.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(130)
        }
        
       
        txtZhangHu.delegate=self
        txtZhangHu.textColor=AppColor
        txtZhangHu.placeholder = "点击选择"
        txtZhangHu.tag = 98
        txtZhangHu.font = UIFont.boldSystemFontOfSize(16)
        txtZhangHu.borderStyle = UITextBorderStyle.RoundedRect
        contentView.addSubview(txtZhangHu)
        txtZhangHu.snp_makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(125)
            make.right.equalTo(-5)
            make.height.equalTo(40)
        }
        
        let btnZhangHuXuanZe:UIButton = UIButton()
        btnZhangHuXuanZe.setImage(UIImage(named: "selectfenlei"), forState: UIControlState.Normal)
        contentView.addSubview(btnZhangHuXuanZe)
        btnZhangHuXuanZe.snp_makeConstraints { (make) in
            make.top.equalTo(130)
            make.right.equalTo(-30)
        }
        
        let lbShiJian = UILabel()
        lbShiJian.text = "时间:"
        lbShiJian.textColor = AppFontColor
        contentView.addSubview(lbShiJian)
        lbShiJian.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(170)
        }
        
        
        txtShiJian.placeholder = "点击选择"
        txtShiJian.tag = 99
        txtShiJian.textColor=AppColor
        txtShiJian.delegate=self
        txtShiJian.font = UIFont.boldSystemFontOfSize(16)
        txtShiJian.borderStyle = UITextBorderStyle.RoundedRect
        contentView.addSubview(txtShiJian)
        txtShiJian.snp_makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(170)
            make.right.equalTo(-5)
            make.height.equalTo(40)
        }
        
        let btnShiJianXuanZe:UIButton = UIButton()
        btnShiJianXuanZe.setImage(UIImage(named: "selectfenlei"), forState: UIControlState.Normal)
        contentView.addSubview(btnShiJianXuanZe)
        btnShiJianXuanZe.snp_makeConstraints { (make) in
            make.top.equalTo(180)
            make.right.equalTo(-30)
        }
        
        let lbBeiZhu = UILabel()
        lbBeiZhu.text = "备注:"
        lbBeiZhu.textColor = AppFontColor
        contentView.addSubview(lbBeiZhu)
        lbBeiZhu.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(220)
        }
        
       
        txtBeiZhu.delegate = self
        txtBeiZhu.textColor=AppColor
        txtBeiZhu.tag=3
        txtBeiZhu.font = UIFont.boldSystemFontOfSize(16)
        contentView.addSubview(txtBeiZhu)
        txtBeiZhu.layer.borderWidth = 1
        txtBeiZhu.layer.borderWidth = 0.6
        txtBeiZhu.layer.cornerRadius = 6.0
        txtBeiZhu.layer.borderColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
        
        txtBeiZhu.snp_makeConstraints { (make) in
            make.top.equalTo(220)
            make.left.equalTo(70)
            make.right.equalTo(-5)
            make.height.equalTo(60)
        }
        
        let btnSave = UIButton()
        contentView.addSubview(btnSave)
        btnSave.setImage(UIImage(named: "btn3"), forState: UIControlState.Normal)
        btnSave.snp_makeConstraints { (make) in
             make.top.equalTo(295)
             make.centerX.equalTo(self.view)
        }
        btnSave.addTarget(self, action: #selector(JiYiBiViewController.btnSaveClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    ///键盘收起
    func keyBoardDisplay() {
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        pickerViewFenLei.removeFromSuperview()
        pickerViewZhangHu.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    func loadFenLeiList() {

        let url = AppServerURL+"btsvc.asmx/ListPayCategory"
        let parameters = [
            "COMPANYID": "\(LoginUserTools.getLoginUser().COMPANYID)"
        ]
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "努力加载数据中..."
        Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
            switch response.result {
            case.Success(let data):
                let json = JSON(data)
                if(json["ResultCode"] == "0")//请求成功
                {
                    self.fenLeiList.removeAll()
                    for obj in json["Page"]["Data"] {
                        let str = "\(obj.1["CategoryString"])"
                        self.fenLeiList.append(str)
                    }
                    if(self.fenLeiList.count>0)
                    {
                        self.txtFenLei.text = self.fenLeiList[0]
                    }
                    self.pickerViewFenLei.reloadAllComponents()
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
    
    //点击交易分类查询按钮加载分类列表
    func btnFenLeiClicked(sender:UIButton) {
        self.datePicker.removeFromSuperview()
        self.pickerViewZhangHu.removeFromSuperview()
        //将键盘收起
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        pickerViewFenLei.tag = 100
        pickerViewFenLei.layer.cornerRadius = 5
        pickerViewFenLei.backgroundColor = AppColor
        pickerViewFenLei.delegate = self
        pickerViewFenLei.dataSource = self
        self.view.addSubview(pickerViewFenLei)
        pickerViewFenLei.snp_makeConstraints { (make) in
            //make.bottom.equalTo(0)
            make.top.equalTo(210)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(180)
        }
        loadFenLeiList()
        
    }
    
    //点击保存按钮事件
    func btnSaveClicked(sender:UIButton) {
        
        if(self.txtJinE.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入金额", view: self.view)
        }
        else if(self.txtFenLei.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请输入或选择消费类别", view: self.view)
        }
        else if(self.txtZhangHu.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择所属账户", view: self.view)
        }
        else if(self.txtShiJian.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择所属账户", view: self.view)
        }
        else{
            var ACCOUNTID = "0"
            for obj in zhanghuList
            {
                if(obj.CNAME == self.txtZhangHu.text)
                {
                    ACCOUNTID = obj.OID
                }
            }
            let parameters = [
                "TOTAL":"\(self.txtJinE.text!)",
                "CATEGORY":"\(self.txtFenLei.text!)",
                "ACCOUNT":"\(ACCOUNTID)",
                "MEMBER":"\(LoginUserTools.getLoginUser().LOGIN_NAME)",
                "DEALER":"测试商户",
                "ARTICLE":"测试项目",
                "MEMO":"\(self.txtBeiZhu.text)",
                "TRADETIME":"\(self.txtShiJian.text!)",
                "COMPANYID":"\(LoginUserTools.getLoginUser().COMPANYID)"
            ]
            var url = AppServerURL
            if(strOperate=="支出")
            {
                url = AppServerURL+"btsvc.asmx/AddOutACCOUNTS_LOG"
            }else
            {
                url = AppServerURL+"btsvc.asmx/AddInACCOUNTS_LOG"
            }
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "后台处理中..."
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    print(json)
                    if(json["ResultCode"] == "0")//插入成功
                    {
                        ViewAlertTextCommon.ShowSimpleText("提交成功", view: self.view)
                        self.txtJinE.text = ""
                        UIApplication.sharedApplication().keyWindow?.endEditing(true)
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
    
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 100)
        {
            return fenLeiList.count
        }
        if(pickerView.tag == 101)
        {
            return zhanghuList.count
        }
        return 10
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
            if(pickerView.tag == 100)
            {
                return fenLeiList[row]
            }
            if(pickerView.tag == 101)
            {
                return zhanghuList[row].CNAME
            }
            return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.tag == 100)
        {
           self.txtFenLei.text = fenLeiList[row]
        }
        if(pickerView.tag == 101)
        {
            self.txtZhangHu.text =  zhanghuList[row].CNAME
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        self.pickerViewFenLei.removeFromSuperview()
        self.pickerViewZhangHu.removeFromSuperview()
        self.datePicker.removeFromSuperview()
        
        if(textField.tag==1)//金额
        {
            txtJinE.layer.borderColor = AppColor.CGColor
            txtJinE.layer.borderWidth = 1
            txtJinE.layer.cornerRadius = 5
            
            txtFenLei.layer.borderColor = UIColor.clearColor().CGColor
            txtFenLei.layer.borderWidth = 1
            txtFenLei.layer.cornerRadius = 5
            
            txtZhangHu.layer.borderColor = UIColor.clearColor().CGColor
            txtZhangHu.layer.borderWidth = 1
            txtZhangHu.layer.cornerRadius = 5
            
            txtShiJian.layer.borderColor = UIColor.clearColor().CGColor
            txtShiJian.layer.borderWidth = 1
            txtShiJian.layer.cornerRadius = 5
            
            txtBeiZhu.layer.borderColor = UIColor.clearColor().CGColor
            txtBeiZhu.layer.borderWidth = 1
            txtBeiZhu.layer.cornerRadius = 5
            
        }else if(textField.tag==2)//分类
        {
            txtJinE.layer.borderColor = UIColor.clearColor().CGColor
            txtJinE.layer.borderWidth = 1
            txtJinE.layer.cornerRadius = 5
            
            txtFenLei.layer.borderColor = AppColor.CGColor
            txtFenLei.layer.borderWidth = 1
            txtFenLei.layer.cornerRadius = 5
            
            txtZhangHu.layer.borderColor = UIColor.clearColor().CGColor
            txtZhangHu.layer.borderWidth = 1
            txtZhangHu.layer.cornerRadius = 5
            
            txtShiJian.layer.borderColor = UIColor.clearColor().CGColor
            txtShiJian.layer.borderWidth = 1
            txtShiJian.layer.cornerRadius = 5
            
            txtBeiZhu.layer.borderColor = UIColor.clearColor().CGColor
            txtBeiZhu.layer.borderWidth = 1
            txtBeiZhu.layer.cornerRadius = 5
        }else if(textField.tag==3)//备注
        {
            txtJinE.layer.borderColor = UIColor.clearColor().CGColor
            txtJinE.layer.borderWidth = 1
            txtJinE.layer.cornerRadius = 5
            
            txtFenLei.layer.borderColor = UIColor.clearColor().CGColor
            txtFenLei.layer.borderWidth = 1
            txtFenLei.layer.cornerRadius = 5
            
            txtZhangHu.layer.borderColor = UIColor.clearColor().CGColor
            txtZhangHu.layer.borderWidth = 1
            txtZhangHu.layer.cornerRadius = 5
            
            txtShiJian.layer.borderColor = UIColor.clearColor().CGColor
            txtShiJian.layer.borderWidth = 1
            txtShiJian.layer.cornerRadius = 5
            
            txtBeiZhu.layer.borderColor = AppColor.CGColor
            txtBeiZhu.layer.borderWidth = 1
            txtBeiZhu.layer.cornerRadius = 5
        }
        else if(textField.tag==98)//账户列表
        {
            txtJinE.layer.borderColor = UIColor.clearColor().CGColor
            txtJinE.layer.borderWidth = 1
            txtJinE.layer.cornerRadius = 5
            
            txtFenLei.layer.borderColor = UIColor.clearColor().CGColor
            txtFenLei.layer.borderWidth = 1
            txtFenLei.layer.cornerRadius = 5
            
            txtZhangHu.layer.borderColor = AppColor.CGColor
            txtZhangHu.layer.borderWidth = 1
            txtZhangHu.layer.cornerRadius = 5
            
            txtShiJian.layer.borderColor = UIColor.clearColor().CGColor
            txtShiJian.layer.borderWidth = 1
            txtShiJian.layer.cornerRadius = 5
            
            txtBeiZhu.layer.borderColor = UIColor.clearColor().CGColor
            txtBeiZhu.layer.borderWidth = 1
            txtBeiZhu.layer.cornerRadius = 5
        }else if(textField.tag==99)//时间
        {
            txtJinE.layer.borderColor = UIColor.clearColor().CGColor
            txtJinE.layer.borderWidth = 1
            txtJinE.layer.cornerRadius = 5
            
            txtFenLei.layer.borderColor = UIColor.clearColor().CGColor
            txtFenLei.layer.borderWidth = 1
            txtFenLei.layer.cornerRadius = 5
            
            txtZhangHu.layer.borderColor = UIColor.clearColor().CGColor
            txtZhangHu.layer.borderWidth = 1
            txtZhangHu.layer.cornerRadius = 5
            
            txtShiJian.layer.borderColor = AppColor.CGColor
            txtShiJian.layer.borderWidth = 1
            txtShiJian.layer.cornerRadius = 5
            
            txtBeiZhu.layer.borderColor = UIColor.clearColor().CGColor
            txtBeiZhu.layer.borderWidth = 1
            txtBeiZhu.layer.cornerRadius = 5
        }
        
        if(textField.tag == 98) //txtZhangHu 加载账户列表
        {
            UIApplication.sharedApplication().keyWindow?.endEditing(true)
            pickerViewZhangHu.tag = 101
            pickerViewZhangHu.backgroundColor=AppColor
            pickerViewZhangHu.layer.cornerRadius=5
            pickerViewZhangHu.delegate = self
            pickerViewZhangHu.dataSource = self
            self.view.addSubview(pickerViewZhangHu)
            pickerViewZhangHu.snp_makeConstraints { (make) in
                make.top.equalTo(260)
                make.height.equalTo(150)
               make.right.equalTo(0)
                make.left.equalTo(0)
            }
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "努力加载数据中..."//showHUDAddedTo
            let url = AppServerURL+"btsvc.asmx/ListAccount"
            let parameters = [
                "COMPANYID": "\(LoginUserTools.getLoginUser().COMPANYID)"
            ]
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    if(json["ResultCode"] == "0")//请求成功
                    {
                        self.zhanghuList.removeAll()
                        for obj in json["Page"]["Data"] {
                            let model:SimpleAccountModel = SimpleAccountModel()
                            model.OID = "\(obj.1["OID"])"
                            model.CNAME = "\(obj.1["CNAME"])"
                            model.BALANCE = "\(obj.1["BALANCE"])"
                            model.COMPANYID = "\(obj.1["COMPANYID"])"
                            self.zhanghuList.append(model)
                        }
                        self.txtZhangHu.text = self.zhanghuList[0].CNAME
                        self.pickerViewZhangHu.reloadAllComponents()
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

            return false //使之不能编辑
        }
        if(textField.tag == 99)
        {
            UIApplication.sharedApplication().keyWindow?.endEditing(true)
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
            datePicker.layer.cornerRadius = 5
            datePicker.backgroundColor = AppColor
            datePicker.datePickerMode = UIDatePickerMode.Date
            let dateFormatter = NSDateFormatter()
            let maxDate = dateFormatter.dateFromString("2018-05-01 08:00:00")
            let minDate = dateFormatter.dateFromString("2016-05-01 08:00:00")
            datePicker.maximumDate = maxDate
            datePicker.minimumDate = minDate
            datePicker.date = NSDate()
            
            if(txtShiJian.text == "")
            {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                txtShiJian.text = formatter.stringFromDate(datePicker.date)
            }
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(JiYiBiViewController.dateChanged(_:)),
                             forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(datePicker)
            datePicker.snp_makeConstraints { (make) in
                make.top.equalTo(300)
                make.right.equalTo(0)
                make.left.equalTo(0)
                make.height.equalTo(180)
            }
            return false
        }
        return true
    }

    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.stringFromDate(datePicker.date))
        txtShiJian.text = formatter.stringFromDate(datePicker.date)
    }
   

    
    //单击支出按钮的事件
    func btnZhiChuClick(sender:UIButton!)
    {
        btnZhiChu.setImage(UIImage(named: "radiobtn_y"), forState: UIControlState.Normal)
        btnShouRu.setImage(UIImage(named: "radiobtn_n"), forState: UIControlState.Normal)
        strOperate = "支出"
    }
    
    //单击收入单选按钮的事件
    func btnShouRuClick(sender:UIButton!)
    {
        btnZhiChu.setImage(UIImage(named: "radiobtn_n"), forState: UIControlState.Normal)
        btnShouRu.setImage(UIImage(named: "radiobtn_y"), forState: UIControlState.Normal)
        strOperate = "收入"
    }
    
    //单行文本框输入完成键盘收起
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //单行文本框输入完毕的检测事件
    func textFieldDidEndEditing(textField: UITextField)
    {
        datePicker.removeFromSuperview()
        let animationDuration:NSTimeInterval = 0.3
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(animationDuration)
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
        

    }
    

    
    //备注文本框检测键盘输入的事件
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            datePicker.removeFromSuperview()
            self.pickerViewFenLei.removeFromSuperview()
            self.pickerViewZhangHu.removeFromSuperview()
            let animationDuration:NSTimeInterval = 0.3
            UIView.beginAnimations("ResizeForKeyboard", context: nil)
            UIView.setAnimationDuration(animationDuration)
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            UIView.commitAnimations()
            txtBeiZhu.resignFirstResponder()
            return false
        }
        return true
    }

}
