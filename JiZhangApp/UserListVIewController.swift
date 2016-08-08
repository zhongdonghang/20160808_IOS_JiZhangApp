//
//  UserListVIewController.swift
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

class UserListVIewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var data:[SimpleLoginUserModel] = []
     let myTable:UITableView = UITableView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        initDataTable()
        loadUserList()
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
        lbTitle.text = "用户管理"
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
        
        let btnAdd = UIButton(type: UIButtonType.ContactAdd)
        btnAdd.addTarget(self, action: #selector(UserListVIewController.btnAddClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnAdd)
        btnAdd.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(returnView).offset(5)
        }
    }
    
    func initDataTable() {
        
        let lbTableTitle1 = UILabel()
        lbTableTitle1.text = "昵称"
        lbTableTitle1.font = UIFont.boldSystemFontOfSize(14)
        lbTableTitle1.textColor = UIColor.grayColor()
        self.view.addSubview(lbTableTitle1)
        lbTableTitle1.snp_makeConstraints { (make) in
            make.top.equalTo(70)
            make.left.equalTo(20)
        }
        
        let lbTableTitle2 = UILabel()
        lbTableTitle2.text = "登录名"
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
        self.myTable.frame = CGRectMake(0, 100, self.view.frame.width, self.view.frame.height)
        self.myTable.backgroundColor = UIColor.clearColor()
        self.view.addSubview(myTable)
    }
    
    func loadUserList()  {
        let url = AppServerURL+"btsvc.asmx/ToListLoginUser"
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
                    self.data.removeAll()
                    for obj in json["Page"]["Data"] {
                        let model:SimpleLoginUserModel = SimpleLoginUserModel(LOGIN_NAME: "\(obj.1["LOGIN_NAME"])")
                        model.OID = "\(obj.1["OID"])"
                        model.CRDTIME = "\(obj.1["CRDTIME"])"
                        model.LOGIN_PWD = "\(obj.1["LOGIN_PWD"])"
                        model.MEMO = "\(obj.1["MEMO"])"
                        model.MODTIME = "\(obj.1["MODTIME"])"
                        model.CNAME = "\(obj.1["CNAME"])"
                        model.CRDON = "\(obj.1["CRDON"])"
                        model.MODON = "\(obj.1["MODON"])"
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
        
        
        let lbCNAME = UILabel()
        lbCNAME.textColor = AppFontColor
        lbCNAME.text = "\(data[indexPath.row].CNAME)"
        view.addSubview(lbCNAME)
        lbCNAME.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalTo(view)
        }
        
        let lbLOGIN_NAME = UILabel()
        lbLOGIN_NAME.textColor = AppFontColor
        lbLOGIN_NAME.text = "\(data[indexPath.row].LOGIN_NAME)"
        view.addSubview(lbLOGIN_NAME)
        lbLOGIN_NAME.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(view)
        }
        return cell
    }
    
    func  btnAddClicked(sender:UIButton) {
       let vc = AddUserViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func btnBackClicked(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
