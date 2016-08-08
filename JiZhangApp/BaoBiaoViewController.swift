//
//  BaoBiaoViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/30.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class BaoBiaoViewController: BaseViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var BeginDate = ""
    var EndDate = ""
    var segmented = UISegmentedControl()
    let txtBeginTime = UITextField()
    let txtEndTime = UITextField()
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    var data:[SimpleAccountModel] = []
    var accountString = ""
    
    var zhiChuTable:UITableView = UITableView()
    var shouRuTable:UITableView = UITableView()
    
    let report:SimpleReportModel = SimpleReportModel()
    
    var segmented1 = UISegmentedControl()
    
    let lbZhiChu = UILabel()
    let lbZhiChuToTal = UILabel()
    let lbShouRu = UILabel()
    let lbShouRuToTal = UILabel()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        loadListData()
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaoBiaoViewController.outSideViewClick))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func loadListData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "正在加载账户列表..."//showHUDAddedTo
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
                    self.data.removeAll()
                    for obj in json["Page"]["Data"] {
                        let model:SimpleAccountModel = SimpleAccountModel()
                        model.OID = "\(obj.1["OID"])"
                        model.CNAME = "\(obj.1["CNAME"])"
                        model.BALANCE = "\(obj.1["BALANCE"])"
                        model.COMPANYID = "\(obj.1["COMPANYID"])"
                        self.data.append(model)
                    }
                    for item in self.data
                    {
                        self.accountString += item.OID
                        self.accountString += ","
                    }
                    self.accountString.removeAtIndex(self.accountString.endIndex.advancedBy(-1))
                    print(self.accountString)
                    self.setTopItems()
                    self.setInputView()
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
        lbTitle.text = "报      表"
        lbTitle.textColor = UIColor.whiteColor()
        returnView.addSubview(lbTitle)
        lbTitle.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
    }
    
    ///设定分段控件
    func  setTopItems() {
       
        let items=["本日","最近一周","最近一月","自定义"] as [AnyObject]
         segmented=UISegmentedControl(items:items)
        segmented.tintColor=UIColor.redColor()
        segmented.center=self.view.center
        segmented.selectedSegmentIndex=0 //默认选中第二项
        segmented.addTarget(self, action: #selector(BaoBiaoViewController.segmentDidchange(_:)),
                            forControlEvents: UIControlEvents.ValueChanged)  //添加值改变监听
        self.view.addSubview(segmented)
        segmented.snp_makeConstraints { (make) in
            make.top.equalTo(80)
            make.centerX.equalTo(self.view)
        }
    }
    
    func setInputView() {
        let inputView = UIView()
        inputView.layer.cornerRadius = 10;//设置那个圆角的有多圆
        inputView.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
        inputView.layer.masksToBounds = true
        inputView.layer.borderColor = AppColor.CGColor
        self.view.addSubview(inputView)
        inputView.snp_makeConstraints { (make) in
            make.top.equalTo(120)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(145)
        }
        
        let lbShiJian = UILabel()
        lbShiJian.text = "开始时间:"
        lbShiJian.textColor = AppFontColor
        inputView.addSubview(lbShiJian)
        lbShiJian.snp_makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(5)
        }
        
       
        txtBeginTime.borderStyle = UITextBorderStyle.RoundedRect
        txtBeginTime.tag = 98
        txtBeginTime.delegate = self
        inputView.addSubview(txtBeginTime)
        txtBeginTime.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(40)
        }
        
        let lbShiJianend = UILabel()
        lbShiJianend.text = "结束时间:"
        lbShiJianend.textColor = AppFontColor
        inputView.addSubview(lbShiJianend)
        lbShiJianend.snp_makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(60)
        }
        
        txtEndTime.borderStyle = UITextBorderStyle.RoundedRect
        txtEndTime.delegate = self
        txtEndTime.tag = 99
        inputView.addSubview(txtEndTime)
        txtEndTime.snp_makeConstraints { (make) in
            make.left.equalTo(90)
            make.top.equalTo(50)
            make.right.equalTo(-5)
            make.height.equalTo(40)
        }
        
        BeginDate = DateTools.getCurrentDate()
        EndDate = DateTools.getCurrentDate()
        txtBeginTime.text = BeginDate
        txtEndTime.text = EndDate
        
        //btnQuery
        let btnQuery = UIButton()
        inputView.addSubview(btnQuery)
        btnQuery.setImage(UIImage(named: "btnQuery"), forState: UIControlState.Normal)
        btnQuery.addTarget(self, action: #selector(BaoBiaoViewController.btnQueryClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        btnQuery.snp_makeConstraints { (make) in
            make.top.equalTo(95)
            make.right.equalTo(-10)
            make.width.equalTo(120)
            make.height.equalTo(44)
        }
    }
    

    func setMainReport(outCount:String,outSum:String,inCount:String,inSum:String) {
        
        lbZhiChu.text = "支出:"
        lbZhiChu.textColor = AppFontColor
        self.view.addSubview(lbZhiChu)
        lbZhiChu.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(280)
        }
        
        
        lbZhiChuToTal.text = "\(outCount)  笔，共 \(outSum)元"
        lbZhiChuToTal.textColor = AppFontColor
        self.view.addSubview(lbZhiChuToTal)
        lbZhiChuToTal.snp_makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(280)
        }
        
       
        lbShouRu.text = "收入:"
        lbShouRu.textColor = AppFontColor
        self.view.addSubview(lbShouRu)
        lbShouRu.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(310)
        }
        
       
        lbShouRuToTal.text = "\(inCount)  笔，共\(inSum)元"
        lbShouRuToTal.textColor = AppFontColor
        self.view.addSubview(lbShouRuToTal)
        lbShouRuToTal.snp_makeConstraints { (make) in
            make.left.equalTo(70)
            make.top.equalTo(310)
        }
        
        let lineView = UIView()
        lineView.backgroundColor=AppColor
        self.view.addSubview(lineView)
        lineView.snp_makeConstraints { (make) in
            make.top.equalTo(340)
            make.height.equalTo(1)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        let items=["我的支出","我的收入"] as [AnyObject]
        segmented1.removeAllSegments()
        segmented1=UISegmentedControl(items:items)
        segmented1.tintColor=UIColor.redColor()
        segmented1.center=self.view.center
        segmented1.selectedSegmentIndex=0 //默认选中第二项
        segmented1.addTarget(self, action: #selector(BaoBiaoViewController.segmented1ValueChangeed(_:)),
                            forControlEvents: UIControlEvents.ValueChanged)  //添加值改变监听
        self.view.addSubview(segmented1)
        segmented1.snp_makeConstraints { (make) in
            make.top.equalTo(345)
            make.centerX.equalTo(self.view)
        }
        
        //初始化支出表格
        //zhiChuTable
        self.zhiChuTable = UITableView()
        self.zhiChuTable.layer.borderWidth=0.5
        zhiChuTable.layer.cornerRadius = 10;
        self.zhiChuTable.layer.borderColor = AppColor.CGColor
        self.zhiChuTable.tag = 1
        self.zhiChuTable.delegate = self
        self.zhiChuTable.dataSource = self
        //self.zhiChuTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.zhiChuTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zhichucell")
        self.zhiChuTable.backgroundColor = UIColor.clearColor()
        self.view.addSubview(zhiChuTable)
        zhiChuTable.snp_makeConstraints { (make) in
            make.top.equalTo(380)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-50)
        }
        
        self.shouRuTable = UITableView()
        
    }
    
    func segmented1ValueChangeed(segmented:UISegmentedControl){
        if(segmented.selectedSegmentIndex==0)
        {
            shouRuTable.removeFromSuperview()
            self.zhiChuTable = UITableView()
            self.zhiChuTable.layer.borderWidth=0.5
            zhiChuTable.layer.cornerRadius = 10;
            self.zhiChuTable.layer.borderColor = AppColor.CGColor
            self.zhiChuTable.tag = 1
            self.zhiChuTable.delegate = self
            self.zhiChuTable.dataSource = self
           // self.zhiChuTable.separatorStyle = UITableViewCellSeparatorStyle.None
            self.zhiChuTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zhichucell")
            self.zhiChuTable.backgroundColor = UIColor.clearColor()
            self.view.addSubview(zhiChuTable)
            zhiChuTable.snp_makeConstraints { (make) in
                make.top.equalTo(380)
                make.left.equalTo(5)
                make.right.equalTo(-5)
                make.bottom.equalTo(-50)
            }
            zhiChuTable.reloadData()
            shouRuTable.reloadData()
        }
        if(segmented.selectedSegmentIndex==1)
        {
            zhiChuTable.removeFromSuperview()
            self.shouRuTable = UITableView()
            shouRuTable.layer.cornerRadius = 10;
            self.shouRuTable.layer.borderWidth=0.5
            self.shouRuTable.layer.borderColor = AppColor.CGColor
            self.shouRuTable.tag = 2
            self.shouRuTable.delegate = self
            self.shouRuTable.dataSource = self
           // self.shouRuTable.separatorStyle = UITableViewCellSeparatorStyle.None
            self.shouRuTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "shourucell")
            self.shouRuTable.backgroundColor = UIColor.clearColor()
            self.view.addSubview(shouRuTable)
            shouRuTable.snp_makeConstraints { (make) in
                make.top.equalTo(380)
                make.right.equalTo(-5)
                make.left.equalTo(5)
                make.bottom.equalTo(-50)
            }
            shouRuTable.reloadData()
            zhiChuTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView.tag == 1)
        {
            return self.report.OutList.count
        }
        if(tableView.tag == 2)
        {
            return self.report.InList.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(tableView.tag == 1)
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "zhichucell")
            
            let smallPic:UIImageView = UIImageView()
            smallPic.image = UIImage(named: "zhangben_jibenhu_img")
            cell.contentView.addSubview(smallPic)
            smallPic.snp_makeConstraints { (make) in
                make.left.equalTo(5)
                make.centerY.equalTo(cell.contentView)
            }
            
            cell.textLabel?.text = report.OutList[indexPath.row].Category
            cell.textLabel?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(40)
                make.centerY.equalTo(cell.contentView)
            })
            cell.detailTextLabel?.text = report.OutList[indexPath.row].Money
            return cell
        }
        if(tableView.tag == 2)
        {
            let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "shourucell")
            
            let smallPic:UIImageView = UIImageView()
            smallPic.image = UIImage(named: "zhangben_jibenhu_img")
            cell.contentView.addSubview(smallPic)
            smallPic.snp_makeConstraints { (make) in
                make.left.equalTo(5)
                make.centerY.equalTo(cell.contentView)
            }
            cell.textLabel?.text = report.InList[indexPath.row].Category
            cell.textLabel?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(40)
                make.centerY.equalTo(cell.contentView)
            })
            cell.detailTextLabel?.text = report.InList[indexPath.row].Money
            return cell
        }
        
        return UITableViewCell()
    }

    
    func btnQueryClick(sender:UIButton) {

        datePicker1.removeFromSuperview()
        datePicker.removeFromSuperview()
        zhiChuTable.removeFromSuperview()
        shouRuTable.removeFromSuperview()
        
        if(self.txtBeginTime.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择要查询的开始时间", view: self.view)
        }else if(self.txtEndTime.text == "")
        {
            ViewAlertTextCommon.ShowSimpleText("请选择要查询的结束时间", view: self.view)
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "正在统计..."
            let url = AppServerURL+"btsvc.asmx/GetReport1"
            let parameters = [
                "COMPANYID": "\(LoginUserTools.getLoginUser().COMPANYID)",
                "BeginDate":"\(txtBeginTime.text!)",
                "EndDate":"\(txtEndTime.text!)",
                "AccountIdList":"\(accountString)"
            ]
            
         //   print(parameters)
            
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    print(json)
                    if(json["ResultCode"] == "0")//请求成功
                    {
                        //report
                        self.report.OutTotal =  "\(json["t"]["OutTotal"])"
                        self.report.InTotal =  "\(json["t"]["InTotal"])"
                        self.report.OutCount =  "\(json["t"]["OutCount"])"
                        self.report.InCount =  "\(json["t"]["InCount"])"
                        print(self.report.InCount)
                        
                        self.report.InList.removeAll()
                        self.report.OutList.removeAll()
                        for obj in json["t"]["OutCategorySum"] {
                            let outItem:SimpleReportItem = SimpleReportItem()
                            outItem.Category = "\(obj.1["CategoryName"])"
                            outItem.Money = "\(obj.1["SumTotal"])"
                            self.report.OutList.append(outItem)
                        }
                        for obj in json["t"]["InCategorySum"] {
                            let inItem:SimpleReportItem = SimpleReportItem()
                            inItem.Category = "\(obj.1["CategoryName"])"
                            inItem.Money = "\(obj.1["SumTotal"])"
                            self.report.InList.append(inItem)
                        }
                        self.setMainReport(self.report.OutCount,outSum: self.report.OutTotal,inCount: self.report.InCount,inSum: self.report.InTotal)
                        self.zhiChuTable.reloadData()
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
    
    func segmentDidchange(segmented:UISegmentedControl){
        

           zhiChuTable.removeFromSuperview()

            shouRuTable.removeFromSuperview()

        
        
        if(segmented.selectedSegmentIndex==0) //当天
        {
            datePicker.removeFromSuperview()
            BeginDate = DateTools.getCurrentDate()
            EndDate = DateTools.getCurrentDate()
            txtBeginTime.text = BeginDate
            txtEndTime.text = EndDate
        }
        else if(segmented.selectedSegmentIndex==1)//最近一周
        {
             datePicker.removeFromSuperview()
            EndDate = DateTools.getCurrentDate()
            BeginDate = DateTools.change1(NSDate(timeInterval: -24*60*60*7, sinceDate: NSDate()))
            txtBeginTime.text = BeginDate
            txtEndTime.text = EndDate
        }
        else if(segmented.selectedSegmentIndex==2)//最近一月
        {
            datePicker.removeFromSuperview()
            EndDate = DateTools.getCurrentDate()
            BeginDate = DateTools.change1(NSDate(timeInterval: -24*60*60*30, sinceDate: NSDate()))
            txtBeginTime.text = BeginDate
            txtEndTime.text = EndDate
        }else if(segmented.selectedSegmentIndex==3)//自定义
        {
            txtBeginTime.text = ""
            txtEndTime.text = ""
            txtBeginTime.placeholder = "点击选择"
            txtEndTime.placeholder = "点击选择"
        }
    }
    
     func textFieldShouldBeginEditing(textField: UITextField) -> Bool
     {
        if(segmented.selectedSegmentIndex==3)
        {
            if(textField.tag == 98)
            {
                datePicker1.removeFromSuperview()
                
               txtBeginTime.layer.borderColor = AppColor.CGColor
               txtBeginTime.layer.borderWidth = 1
               txtBeginTime.layer.cornerRadius = 5
                
                txtEndTime.layer.borderColor = UIColor.clearColor().CGColor
                txtEndTime.layer.borderWidth = 1
                txtEndTime.layer.cornerRadius = 5
                
                datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
                datePicker.datePickerMode = UIDatePickerMode.Date
                datePicker.date = NSDate()
                datePicker.layer.cornerRadius = 10;
                datePicker.layer.borderColor = AppColor.CGColor
                datePicker.layer.borderWidth = 1
                datePicker.tintColor = AppColor
                datePicker.layer.backgroundColor = AppColor.CGColor
                self.view.addSubview(datePicker)
                datePicker.snp_makeConstraints { (make) in
                    make.top.equalTo(260)
                    make.left.equalTo(10)
                    make.right.equalTo(-10)
                    make.height.equalTo(180)
                }
                datePicker.addTarget(self, action: #selector(BaoBiaoViewController.dateChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                
            }else if(textField.tag == 99)
            {
                datePicker.removeFromSuperview()
                txtBeginTime.layer.borderColor = UIColor.clearColor().CGColor
                txtBeginTime.layer.borderWidth = 1
                txtBeginTime.layer.cornerRadius = 5
                
                txtEndTime.layer.borderColor = AppColor.CGColor
                txtEndTime.layer.borderWidth = 1
                txtEndTime.layer.cornerRadius = 5
                
                datePicker1.locale = NSLocale(localeIdentifier: "zh_CN")
                datePicker1.datePickerMode = UIDatePickerMode.Date
                datePicker1.date = NSDate()
                datePicker1.layer.cornerRadius = 10;
                datePicker1.tintColor = AppColor
                datePicker1.layer.backgroundColor = AppColor.CGColor
                self.view.addSubview(datePicker1)
                datePicker1.snp_makeConstraints { (make) in
                    make.top.equalTo(260)
                    make.left.equalTo(10)
                    make.right.equalTo(-10)
                    make.height.equalTo(180)
                }
                datePicker1.addTarget(self, action: #selector(BaoBiaoViewController.dateChanged1(_:)), forControlEvents: UIControlEvents.ValueChanged)
            }
        }
        return false
     }
    
    //日期选择器响应方法
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        txtBeginTime.text = formatter.stringFromDate(datePicker.date)
    }
    
    //日期选择器响应方法
    func dateChanged1(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        txtEndTime.text = formatter.stringFromDate(datePicker.date)
    }
    
    func outSideViewClick() {
        datePicker.removeFromSuperview()
        datePicker1.removeFromSuperview()
    }
}
