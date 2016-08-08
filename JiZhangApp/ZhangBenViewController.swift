//
//  ZhangBenViewController.swift
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

class ZhangBenViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {

    let myTable:UITableView = UITableView()
    var data:[SimpleAccountModel] = []
     let alertView = UIAlertView()
    
    lazy var zhangbenBigView: SpringView = {
        let zhangbenBigView = SpringView()
        zhangbenBigView.backgroundColor = UIColor.clearColor()
        return zhangbenBigView
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadListData()
        
        view.addSubview(zhangbenBigView)
        zhangbenBigView.hidden = false
        zhangbenBigView.animation = "squeezeDown"
        zhangbenBigView.curve = "easeIn"
        zhangbenBigView.duration = 1.0
        zhangbenBigView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(95)
            make.bottom.equalTo(-50)
        }
        zhangbenBigView.animate()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        initDataTable()

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
        lbTitle.text = "账    本"
        lbTitle.textColor = UIColor.whiteColor()
        returnView.addSubview(lbTitle)
        lbTitle.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
        let btnAdd = UIButton()
        btnAdd.setImage(UIImage(named: "add_img"), forState: UIControlState.Normal)
        btnAdd.addTarget(self, action:#selector(ZhangBenViewController.btnAddClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnAdd)
        btnAdd.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(returnView).offset(5)
        }
    }
    
    func initDataTable() {
        
        let lbTableTitle1 = UILabel()
        lbTableTitle1.text = "账本"
        lbTableTitle1.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle1.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle1)
        lbTableTitle1.snp_makeConstraints { (make) in
            make.top.equalTo(70)
            make.left.equalTo(20)
        }
        
        let lbTableTitle2 = UILabel()
        lbTableTitle2.text = "余额"
        lbTableTitle2.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle2.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle2)
        lbTableTitle2.snp_makeConstraints { (make) in
            make.top.equalTo(70)
            make.right.equalTo(-20)
        }
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
        self.myTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.myTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellname")
        //self.myTable.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height)
        self.myTable.backgroundColor = UIColor.clearColor()
        zhangbenBigView.addSubview(myTable)
        myTable.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    }

    func loadListData() {
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
                    self.data.removeAll()
                    for obj in json["Page"]["Data"] {
                        let model:SimpleAccountModel = SimpleAccountModel()
                        model.OID = "\(obj.1["OID"])"
                        model.CNAME = "\(obj.1["CNAME"])"
                        model.BALANCE = "\(obj.1["BALANCE"])"
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
        
        let smallPic:UIImageView = UIImageView()
        if(data[indexPath.row].CNAME == "基本户")
        {
            smallPic.image = UIImage(named: "zhangben_jibenhu_img")
        }
        else if(data[indexPath.row].CNAME == "微信钱包")
        {
            smallPic.image = UIImage(named: "weixinqianbao_img")
        }
        else if(data[indexPath.row].CNAME == "支付宝")
        {
            smallPic.image = UIImage(named: "zhifubao_img")
        }
        else if(data[indexPath.row].CNAME == "市民卡")
        {
            smallPic.image = UIImage(named: "shiminka_img")
        }else{
            smallPic.image = UIImage(named: "yinhangka_img")
        }
        
        view.addSubview(smallPic)
        smallPic.snp_makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalTo(view)
        }
        
        cell.textLabel?.text = data[indexPath.row].CNAME
        cell.textLabel?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(40)
            make.centerY.equalTo(view)
        })
        cell.detailTextLabel?.text = data[indexPath.row].BALANCE
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
            
            //编辑
            let editRowAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "编辑") { (UITableViewRowAction, NSIndexPath) in
                //print("编辑")
                let vc = AddAccountViewController()
                vc.op = "edit"
                vc.model = self.data[indexPath.row]
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            editRowAction.backgroundColor = AppFontColor
            arr.append(deleteRowAction)
            arr.append(editRowAction)
        
        return arr
    }

    func btnAddClicked(sender:UIButton) {
        let vc = AddAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if(buttonIndex==0)
        {
            let url = AppServerURL+"btsvc.asmx/DeleteAccount"
            let parameters = [
                "accountOID": "\(self.data[alertView.tag].OID)"
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
                        ViewAlertTextCommon.ShowSimpleText("成功删除", view: self.view)
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

}
