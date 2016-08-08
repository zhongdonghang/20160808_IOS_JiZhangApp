//
//  SheZhiViewController.swift
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

class SheZhiViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {

    let myTable:UITableView = UITableView()
    var data:[String] = ["用户管理","修改密码","关于我们"]
    let alertView = UIAlertView()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        initDataTable()
        setLoginOutButton()
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
        let titleImgView = UIImageView(image: UIImage(named: "titleshezhi"))
        returnView.addSubview(titleImgView)
        titleImgView.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
        
    }
    
    func setLoginOutButton()  {
        let returnView = UIView()
        returnView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(returnView)
        returnView.snp_makeConstraints { (make) in
            make.height.equalTo(45)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(220)
        }
        
        let btnLoginOut = UIButton()
        btnLoginOut.backgroundColor = UIColor.clearColor()
        btnLoginOut.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnLoginOut.setTitle("注销当前登录", forState: UIControlState.Normal)
        btnLoginOut.titleLabel?.font = UIFont.systemFontOfSize(16)
        btnLoginOut.addTarget(self, action: #selector(SheZhiViewController.btnLoginOutClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        returnView.addSubview(btnLoginOut)
        btnLoginOut.snp_makeConstraints { (make) in
            make.center.equalTo(returnView)
        }
    }
    
    func initDataTable() {

        self.myTable.delegate = self
        self.myTable.dataSource = self
        self.myTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.myTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellname")
        self.myTable.frame = CGRectMake(0, 70, self.view.frame.width, self.view.frame.height)
        self.myTable.backgroundColor = UIColor.clearColor()
        self.view.addSubview(myTable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnLoginOutClicked(sender:UIButton) {
        alertView.delegate=self
        alertView.title = "提示"
        alertView.addButtonWithTitle("好的")
        alertView.addButtonWithTitle("不要")
        alertView.message = "确认注销"
        alertView.show()
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 45
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cellname")
        //cell.accessoryType = UITableViewCellAccessoryType
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor=UIColor.clearColor()
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(view)
        view.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.height.equalTo(44)
        }
        let smallPic:UIImageView = UIImageView()
        if(data[indexPath.row] == "用户管理")
        {
            smallPic.image = UIImage(named: "setup_bg2")
        }
        if(data[indexPath.row] == "修改密码")
        {
            smallPic.image = UIImage(named: "setup_bg1")
        }
        if(data[indexPath.row] == "关于我们")
        {
            smallPic.image = UIImage(named: "setup_bg3")
        }
        view.addSubview(smallPic)
        smallPic.snp_makeConstraints { (make) in
            make.left.equalTo(5)
            make.centerY.equalTo(view)
        }
        
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(30)
            make.centerY.equalTo(view)
        })
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if(data[indexPath.row] == "关于我们")
        {
        self.navigationController?.pushViewController(AboutMeViewController(), animated: true)
        }
        if(data[indexPath.row] == "修改密码")
        {
            self.navigationController?.pushViewController(ModifyPasswordViewController(), animated: true)
        }
        if(data[indexPath.row] == "用户管理")
        {
            self.navigationController?.pushViewController(UserListVIewController(), animated: true)
        }
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if(buttonIndex==0)
        {
            LoginUserTools.LoginOut()
            self.tabBarController?.selectedIndex = 0
        }
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
