//
//  ChaXunViewController.swift
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

class ChaXunViewController: BaseViewController,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    let txtZhangHu = UITextField()
    let  txtBeginTime = UITextField()
    let  txtEndTime = UITextField()
    

    var zhanghuList:[SimpleAccountModel] = []
    
    var pickerViewZhangHu:UIPickerView!
    let datePicker = UIDatePicker()
    let datePicker2 = UIDatePicker()
    
    var currentSelectZhanghu:SimpleAccountModel!
    
    lazy var searchView: SpringView = {
        let searchView = SpringView()
        searchView.backgroundColor = UIColor.whiteColor()
        searchView.layer.cornerRadius = 10
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = AppColor.CGColor
        return searchView
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(searchView)
        searchView.hidden = false
        searchView.animation = "squeezeDown"
        searchView.curve = "easeIn"
        searchView.duration = 1.0
        searchView.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
            make.top.equalTo(70)
        }
        searchView.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewZhangHu = UIPickerView()
        initView()
        setTopBannerView()
        setFormView()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChaXunViewController.hideView))
        self.view.addGestureRecognizer(tapGesture)
        

    }
    
    ///键盘收起
    func hideView() {
        pickerViewZhangHu.removeFromSuperview()
        datePicker.removeFromSuperview()
        datePicker2.removeFromSuperview()
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
        let titleImgView = UIImageView(image: UIImage(named: "titlechaxun"))
        returnView.addSubview(titleImgView)
        titleImgView.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
    }
    

    
    func setFormView() {
        let lbZhangHu = UILabel()
        lbZhangHu.text = "查询账户:"
        lbZhangHu.textColor = AppFontColor
        searchView.addSubview(lbZhangHu)
        lbZhangHu.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(20)
        }
        
        txtZhangHu.delegate=self
        txtZhangHu.tag = 98
        txtZhangHu.borderStyle = UITextBorderStyle.RoundedRect
        searchView.addSubview(txtZhangHu)
        txtZhangHu.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(5)
            make.right.equalTo(-10)
            make.height.equalTo(40)
        }
        
        let lbShiJian = UILabel()
        lbShiJian.text = "开始时间:"
        lbShiJian.textColor = AppFontColor
        searchView.addSubview(lbShiJian)
        lbShiJian.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(65)
        }
        
        
        txtBeginTime.tag = 99
        txtBeginTime.delegate=self
        txtBeginTime.borderStyle = UITextBorderStyle.RoundedRect
        searchView.addSubview(txtBeginTime)
        txtBeginTime.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(50)
            make.right.equalTo(-10)
            make.height.equalTo(40)
        }

        let lbShiJianend = UILabel()
        lbShiJianend.text = "结束时间:"
        lbShiJianend.textColor = AppFontColor
        searchView.addSubview(lbShiJianend)
        lbShiJianend.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(110)
        }
        txtEndTime.tag = 100
        txtEndTime.delegate=self
        txtEndTime.borderStyle = UITextBorderStyle.RoundedRect
        searchView.addSubview(txtEndTime)
        txtEndTime.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(100)
            make.right.equalTo(-10)
            make.height.equalTo(40)
        }
        
        //btnQuery
        let btnQuery = UIButton()
        searchView.addSubview(btnQuery)
        btnQuery.setImage(UIImage(named: "btnQuery"), forState: UIControlState.Normal)
        
        btnQuery.snp_makeConstraints { (make) in
            make.top.equalTo(150)
            make.right.equalTo(-10)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
        btnQuery.addTarget(self, action: #selector(ChaXunViewController.btnQueryClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func btnQueryClicked(sender:UIButton) {
        if(self.txtZhangHu.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择要查询的账户", view: self.view)
        }else if(self.txtBeginTime.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择要查询的开始时间", view: self.view)
        }else if(self.txtEndTime.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择要查询的结束时间", view: self.view)
        }else{
            searchView.hidden = true
            let vcResult = ListAccountLogViewController()
            vcResult.accountId = currentSelectZhanghu.OID
            vcResult.COMPANYID = currentSelectZhanghu.COMPANYID
            vcResult.beginTime = self.txtBeginTime.text!
            vcResult.endTime = self.txtEndTime.text!
            self.navigationController?.pushViewController(vcResult, animated: true)
        }
    }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.stringFromDate(datePicker.date))
        txtBeginTime.text = formatter.stringFromDate(datePicker.date)
    }
    
    func dateChanged2(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.stringFromDate(datePicker.date))
        txtEndTime.text = formatter.stringFromDate(datePicker.date)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if(textField.tag == 98)
        {
            datePicker2.removeFromSuperview()
            datePicker.removeFromSuperview()
            pickerViewZhangHu.tag = 101
            pickerViewZhangHu.layer.cornerRadius = 10
            pickerViewZhangHu.backgroundColor = AppColor
            pickerViewZhangHu.delegate = self
            pickerViewZhangHu.dataSource = self
            self.view.addSubview(pickerViewZhangHu)
            pickerViewZhangHu.snp_makeConstraints { (make) in
               make.top.equalTo(120)
                make.right.equalTo(0)
                make.left.equalTo(0)
                make.height.equalTo(180)
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
                        self.currentSelectZhanghu = self.zhanghuList[0]
                        self.txtZhangHu.text = self.currentSelectZhanghu.CNAME
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


        }
        if(textField.tag == 99)
        {
            datePicker2.removeFromSuperview()
            pickerViewZhangHu.removeFromSuperview()
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
            datePicker.datePickerMode = UIDatePickerMode.Date
            datePicker.layer.cornerRadius = 10
            datePicker.backgroundColor = AppColor
            let dateFormatter = NSDateFormatter()
            let maxDate = dateFormatter.dateFromString("2018-05-01 08:00:00")
            let minDate = dateFormatter.dateFromString("2016-05-01 08:00:00")
            datePicker.maximumDate = maxDate
            datePicker.minimumDate = minDate
            // NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];//前一天
            
            datePicker.date = NSDate(timeInterval: -24*60*60*10, sinceDate: NSDate())
            
            if(txtBeginTime.text == "")
            {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                txtBeginTime.text = formatter.stringFromDate(datePicker.date)
            }
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker.addTarget(self, action: #selector(JiYiBiViewController.dateChanged(_:)),
                                 forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(datePicker)
            datePicker.snp_makeConstraints { (make) in
                make.top.equalTo(170)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(180)
            }
        }
        if(textField.tag == 100)
        {
            datePicker.removeFromSuperview()
            pickerViewZhangHu.removeFromSuperview()
            //将日期选择器区域设置为中文，则选择器日期显示为中文
            datePicker2.locale = NSLocale(localeIdentifier: "zh_CN")
            datePicker2.backgroundColor = AppColor
            datePicker2.layer.cornerRadius = 10
            datePicker2.datePickerMode = UIDatePickerMode.Date
            let dateFormatter = NSDateFormatter()
            let maxDate = dateFormatter.dateFromString("2018-05-01 08:00:00")
            let minDate = dateFormatter.dateFromString("2016-05-01 08:00:00")
            datePicker2.maximumDate = maxDate
            datePicker2.minimumDate = minDate
            datePicker2.date = NSDate()
            
            if(txtEndTime.text == "")
            {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                txtEndTime.text = formatter.stringFromDate(datePicker2.date)
            }
            //注意：action里面的方法名后面需要加个冒号“：”
            datePicker2.addTarget(self, action: #selector(ChaXunViewController.dateChanged2(_:)),
                                 forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(datePicker2)
            datePicker2.snp_makeConstraints { (make) in
                make.top.equalTo(220)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(180)
            }
        }
        
        return false
    }
    
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //设置选择框的行数为9行，继承于UIPickerViewDataSource协议
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        return zhanghuList.count
    }
    
    //设置选择框各选项的内容，继承于UIPickerViewDelegate协议
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
        -> String? {
        return zhanghuList[row].CNAME
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.currentSelectZhanghu = zhanghuList[row]
        self.txtZhangHu.text =  zhanghuList[row].CNAME
    }


}
