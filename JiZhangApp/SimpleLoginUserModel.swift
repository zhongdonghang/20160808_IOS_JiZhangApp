//
//  SimpleLoginUserModel.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/7.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation

class SimpleLoginUserModel:NSObject,NSCoding {
    
    var LOGIN_NAME = ""
    var CRDTIME = ""
    var LOGIN_PWD = ""
    var MEMO = ""
    var MODTIME = ""
    var CNAME = ""
    var CRDON = ""
    var OID = ""
    var MODON = ""
    var COMPANYID = ""
    
    func encodeWithCoder(aCodeer:NSCoder){
        aCodeer.encodeObject(self.LOGIN_NAME, forKey: "LOGIN_NAME")
        aCodeer.encodeObject(self.CRDTIME, forKey: "CRDTIME")
        aCodeer.encodeObject(self.LOGIN_PWD, forKey: "LOGIN_PWD")
        aCodeer.encodeObject(self.MEMO, forKey: "MEMO")
        aCodeer.encodeObject(self.MODTIME, forKey: "MODTIME")
        aCodeer.encodeObject(self.CNAME, forKey: "CNAME")
        aCodeer.encodeObject(self.CRDON, forKey: "CRDON")
        aCodeer.encodeObject(self.OID, forKey: "OID")
        aCodeer.encodeObject(self.MODON, forKey: "MODON")
        aCodeer.encodeObject(self.COMPANYID, forKey: "COMPANYID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.LOGIN_NAME = aDecoder.decodeObjectForKey("LOGIN_NAME") as! String
        self.CRDTIME = aDecoder.decodeObjectForKey("CRDTIME") as! String
        self.LOGIN_PWD = aDecoder.decodeObjectForKey("LOGIN_PWD") as! String
        self.MEMO = aDecoder.decodeObjectForKey("MEMO") as! String
        self.MODTIME = aDecoder.decodeObjectForKey("MODTIME") as! String
        self.CNAME = aDecoder.decodeObjectForKey("CNAME") as! String
        self.CRDON = aDecoder.decodeObjectForKey("CRDON") as! String
        self.OID = aDecoder.decodeObjectForKey("OID") as! String
        self.MODON = aDecoder.decodeObjectForKey("MODON") as! String
        self.COMPANYID = aDecoder.decodeObjectForKey("COMPANYID") as! String
    }
    
    init(LOGIN_NAME loginName:String) {
         LOGIN_NAME = loginName
         CRDTIME = ""
         LOGIN_PWD = ""
         MEMO = ""
         MODTIME = ""
         CNAME = ""
         CRDON = ""
         OID = ""
         MODON = ""
         COMPANYID = ""
    }
}