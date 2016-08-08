//
//  ViewAlertTextCommon.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/7.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import Foundation

class ViewAlertTextCommon {
    
    static func ShowSimpleText(msg:String,view:UIView) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.label.text = msg
        hud.hideAnimated(true, afterDelay: 0.8)
    }
    
}