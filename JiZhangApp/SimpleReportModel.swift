//
//  SimpleReportListModel.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/7/5.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//


//报表分类汇总模型
class SimpleReportItem {
    
    //类别
    var Category = ""
    //金额
    var Money = ""
    
}

//一期报表模型
class SimpleReportModel {
    
    var OutTotal = ""
    var OutCount = ""
    var InTotal = ""
    var InCount = ""
    var OutList:[SimpleReportItem] = []
    var InList:[SimpleReportItem] = []
}
