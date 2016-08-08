//
//  ListAccountLogViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/19.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON


//指定账户下的交易流水查询
class ListAccountLogViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    var COMPANYID = ""
    var beginTime = ""
    var endTime = ""
    var accountId = ""
    
    let myTable:UITableView = UITableView()
    var data:[SimpleAccountLogModel] = []
    
    let alertView = UIAlertView()
    
    //详情页面显示控件开始
    let lbDateTitle:UILabel = UILabel()
    let lbDateText:UILabel = UILabel()
    let lbOpTitle:UILabel = UILabel()
    let lbOpText:UILabel = UILabel()
    let lbJinETitle:UILabel = UILabel()
    let lbJinEText:UILabel = UILabel()
    let lbLeiBieTitle:UILabel = UILabel()
    let lbLeiBieText:UILabel = UILabel()
    let lbYongHuTitle:UILabel = UILabel()
    let lbYongHuText:UILabel = UILabel()
    let lbBeiZhuTitle:UILabel = UILabel()
    let lbBeiZhuText:UILabel = UILabel()
    //详情页面显示控件结束

    lazy var detailView: SpringView = {
        let detailView = SpringView(frame: CGRectMake(-100, -100, 100, 100))
        detailView.backgroundColor = UIColor.whiteColor()
        detailView.layer.cornerRadius = 10
        detailView.layer.borderWidth = 1
        detailView.layer.borderColor = AppColor.CGColor
        return detailView
    }()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        initDataTable()
        loadListData()
        
        view.addSubview(detailView)
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListAccountLogViewController.detailViewHide))
        self.detailView.addGestureRecognizer(tapGesture)
    }
    
    func detailViewHide()  {
        detailView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let titleImgView = UIImageView(image: UIImage(named: "chaxunjieguo"))
        returnView.addSubview(titleImgView)
        titleImgView.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        btnBack.addTarget(self, action: #selector(ListAccountLogViewController.btnBackClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnBack)
        btnBack.snp_makeConstraints { (make) in
            make.centerY.equalTo(returnView)
            make.left.equalTo(10)
        }
    }
    
    func initDataTable() {
        
        let lbTableTitle1 = UILabel()
        lbTableTitle1.text = "时间"
        lbTableTitle1.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle1.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle1)
        lbTableTitle1.snp_makeConstraints { (make) in
            make.top.equalTo(70)
            make.left.equalTo(10)
        }
        
        let lbTableTitle2 = UILabel()
        lbTableTitle2.text = "消费项目"
        lbTableTitle2.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle2.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle2)
        lbTableTitle2.snp_makeConstraints { (make) in
            make.top.equalTo(70)
            make.centerX.equalToSuperview().offset(-60)
        }
        
        let lbTableTitle3 = UILabel()
        lbTableTitle3.text = "消费金额"
        lbTableTitle3.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle3.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle3)
        lbTableTitle3.snp_makeConstraints { (make) in
            make.top.equalTo(70)
             make.centerX.equalToSuperview().offset(40)
        }
        
        let lbTableTitle4 = UILabel()
        lbTableTitle4.text = "支出/收入"
        lbTableTitle4.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle4.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle4)
        lbTableTitle4.snp_makeConstraints { (make) in
            make.top.equalTo(70)
            make.right.equalTo(-20)
        }

        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        self.myTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.myTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellname")
        self.myTable.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height-140)
        myTable.scrollEnabled = true
        myTable.showsVerticalScrollIndicator = true;
        self.myTable.backgroundColor = UIColor.clearColor()
        self.view.addSubview(myTable)
    }
    
    func loadListData() {

        let url = AppServerURL+"btsvc.asmx/ListAccountLog"
        let parameters = [
            "COMPANYID": "\(self.COMPANYID)",
            "beginTime":"\(self.beginTime)",
            "endTime":"\(self.endTime)",
            "account":"\(self.accountId)"
        ]
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.label.text = "努力加载数据中..."//showHUDAddedTo
        
         Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
            switch response.result {
            case.Success(let data):
                let json = JSON(data)
                if(json["ResultCode"] == "0")//请求成功
                {
                    self.data.removeAll()
                    for obj in json["Page"]["Data"] {
                        let model:SimpleAccountLogModel = SimpleAccountLogModel()
                        model.OID = "\(obj.1["OID"])"
                        model.OPERATE = "\(obj.1["OPERATE"])"
                        model.TOTAL = "\(obj.1["TOTAL"])"
                        model.CATEGORY = "\(obj.1["CATEGORY"])"
                        model.ACCOUNT = "\(obj.1["ACCOUNT"])"
                        model.MEMBER = "\(obj.1["MEMBER"])"
                        model.DEALER = "\(obj.1["DEALER"])"
                        model.ARTICLE = "\(obj.1["ARTICLE"])"
                        model.MEMO = "\(obj.1["MEMO"])"
                        model.TRADETIME = "\(obj.1["SimpleTRADETIME"])"
                        model.COMPANYID = "\(obj.1["COMPANYID"])"
                        self.data.append(model)
                    }
                    self.myTable.reloadData()
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cellname")
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor=UIColor.clearColor()
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(view)
        view.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(60)
        }
        

        let lbDate = UILabel()
        lbDate.textColor = AppFontColor
        let ssLong = data[indexPath.row].TRADETIME
        let index = ssLong.startIndex.advancedBy(5)
        lbDate.text = ssLong.substringFromIndex(index)
        view.addSubview(lbDate)
        lbDate.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(view)
        }
        
        let lbCategory = UILabel()
        lbCategory.textColor = AppFontColor
        lbCategory.text = "\(data[indexPath.row].CATEGORY)"
        view.addSubview(lbCategory)
        lbCategory.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-60)
            make.centerY.equalTo(view)
        }
        
        let lbTotal = UILabel()
        lbTotal.text = "\(data[indexPath.row].TOTAL)"
        lbTotal.textColor = AppFontColor
        view.addSubview(lbTotal)
        lbTotal.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(40)
            make.centerY.equalTo(view)
        }
        
        var OPERATESTR = ""
        if(data[indexPath.row].OPERATE == "支出")
        {
            OPERATESTR = "expenditure"
        }else{
            OPERATESTR = "income"
        }
        let imageView = UIImageView(image: UIImage(named: OPERATESTR))
        view.addSubview(imageView)
        imageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.right.equalTo(-30)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        var arr = [UITableViewRowAction]()
        
        let deleteRowAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "删除") { (UITableViewRowAction, NSIndexPath) in
            
            self.alertView.delegate=self
            self.alertView.title = "提示"
            self.alertView.addButtonWithTitle("好的")
            self.alertView.addButtonWithTitle("不要")
            self.alertView.message = "确认删除?"
            self.alertView.show()
            self.alertView.tag = indexPath.row
        }
        arr.append(deleteRowAction)
        return arr
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        lbDateTitle.text = "时间:"
        lbDateTitle.textColor = AppFontColor
        detailView.addSubview(lbDateTitle)
        lbDateTitle.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(20)
        }
        
        lbDateText.textColor = AppFontColor
        lbDateText.text = self.data[indexPath.row].TRADETIME
        detailView.addSubview(lbDateText)
        lbDateText.snp_makeConstraints { (make) in
            make.left.equalTo(65)
            make.top.equalTo(20)
        }
        
        lbOpTitle.text = "操作:"
        lbOpTitle.textColor = AppFontColor
        detailView.addSubview(lbOpTitle)
        lbOpTitle.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(50)
        }
        
        lbOpText.textColor = AppFontColor
        lbOpText.text = self.data[indexPath.row].OPERATE
        detailView.addSubview(lbOpText)
        lbOpText.snp_makeConstraints { (make) in
            make.left.equalTo(65)
            make.top.equalTo(50)
        }
        
        lbJinETitle.text = "金额(￥):"
        lbJinETitle.textColor = AppFontColor
        detailView.addSubview(lbJinETitle)
        lbJinETitle.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(80)
        }
        
        
        lbJinEText.textColor = AppFontColor
        lbJinEText.text = self.data[indexPath.row].TOTAL
        detailView.addSubview(lbJinEText)
        lbJinEText.snp_makeConstraints { (make) in
            make.left.equalTo(85)
            make.top.equalTo(80)
        }
        
        
        lbLeiBieTitle.text = "类别:"
        lbLeiBieTitle.textColor = AppFontColor
        detailView.addSubview(lbLeiBieTitle)
        lbLeiBieTitle.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(110)
        }
        
       
        lbLeiBieText.textColor = AppFontColor
        lbLeiBieText.text = self.data[indexPath.row].CATEGORY
        detailView.addSubview(lbLeiBieText)
        lbLeiBieText.snp_makeConstraints { (make) in
            make.left.equalTo(65)
            make.top.equalTo(110)
        }
        
        lbYongHuTitle.text = "用户:"
        lbYongHuTitle.textColor = AppFontColor
        detailView.addSubview(lbYongHuTitle)
        lbYongHuTitle.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(140)
        }
        
        
        lbYongHuText.textColor = AppFontColor
        lbYongHuText.text = self.data[indexPath.row].MEMBER
        detailView.addSubview(lbYongHuText)
        lbYongHuText.snp_makeConstraints { (make) in
            make.left.equalTo(65)
            make.top.equalTo(140)
        }
        
        lbBeiZhuTitle.text = "备注:"
        lbBeiZhuTitle.textColor = AppFontColor
        detailView.addSubview(lbBeiZhuTitle)
        lbBeiZhuTitle.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(170)
        }
        
        
        lbBeiZhuText.textColor = AppFontColor
        lbBeiZhuText.text = self.data[indexPath.row].MEMO
        detailView.addSubview(lbBeiZhuText)
        lbBeiZhuText.snp_makeConstraints { (make) in
            make.left.equalTo(65)
            make.top.equalTo(170)
        }
        
        detailView.hidden = false
        detailView.animation = "squeezeDown"
        detailView.curve = "easeIn"
        detailView.duration = 1.0
        detailView.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        detailView.animate()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if(buttonIndex==0)
        {
            let url = AppServerURL+"btsvc.asmx/DeleteAccountLog"
            let parameters = [
                "LogOID": "\(self.data[alertView.tag].OID)"
            ]
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.label.text = "删除处理中..."
            Alamofire.request(.GET, url,parameters: parameters).responseJSON { (response) in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    print("\(json)")
                    if(json["ResultCode"] == "0")//请求成功
                    {
                        ViewAlertTextCommon.ShowSimpleText("\(json["Msg"])", view: self.view)
                        self.loadListData()
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
