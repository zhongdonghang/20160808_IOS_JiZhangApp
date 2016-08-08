//
//  AboutMeViewController.swift
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

class AboutMeViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setTopBannerView()
        setContentView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() -> Void {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //设定顶部标题栏视图
    func setTopBannerView() {
        let returnView = UIView(frame: CGRectMake(0, 20,  self.view.bounds.width, 44))
        returnView.backgroundColor = AppColor
        self.view.addSubview(returnView)
        let lbTitle = UILabel()
        lbTitle.text = "关于我们"
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
        
    }
    
    func setContentView() {
        let lbContent:UILabel = UILabel()
        lbContent.numberOfLines = 0
        lbContent.textColor = AppFontColor
        lbContent.text = "    记账喵是一个简单的日常记账工具，包括简单的收入支出记账，账本管理，账目查询，可以多人共享管理账本的功能。本产品由小钟和Shirley共同设计开发，祝阁下使用愉快。\n交流QQ群：561422538 \n当前版本：1.3"
        lbContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.view.addSubview(lbContent)
        lbContent.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.top.equalTo(80)
            make.width.equalTo(self.view).offset(-10)
        }
    }
    
    func btnBackClicked(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
