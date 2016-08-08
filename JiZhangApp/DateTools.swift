//
//  DateTools.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/19.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation

class DateTools {
    
    ///服务器返回的长字符串转换为日期类型
    static func longString2Date(strDate:String)->NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(strDate)
        return date!
    }
    
    //将日期格式转换为标准双位格式
    static func change1(pDate:NSDate)->String {
        let formatter = NSDateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.stringFromDate(pDate)
    }
    
    static func getCurrentDate()->String
    {
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.stringFromDate(date)
       return dateString
    }
}