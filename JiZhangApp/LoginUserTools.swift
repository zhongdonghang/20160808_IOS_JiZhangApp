//
//  LoginUserTools.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/7.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation

class LoginUserTools {
    
    static let sysDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    //判断是否登录
    static func checkIsLogin() ->Bool
    {
        var isTrue = false
        if(sysDefaults.objectForKey("LOGIN_USER") != nil)
        {
            isTrue = true
        }
        return isTrue
    }
    
    //返回登录用户
    static func getLoginUser()->SimpleLoginUserModel
    {
        let data:NSData =  sysDefaults.objectForKey("LOGIN_USER") as! NSData
        let user:SimpleLoginUserModel = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SimpleLoginUserModel
        return user
    }
    
    
    static func LoginOut()
    {
        sysDefaults.removeObjectForKey("LOGIN_USER")
        sysDefaults.synchronize()
    }
    
}