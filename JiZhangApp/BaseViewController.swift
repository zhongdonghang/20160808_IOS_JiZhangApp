//
//  BaseViewController.swift
//  JiZhangApp
//
//  Created by zhongdonghang on 16/6/16.
//  Copyright © 2016年 zhongdonghang. All rights reserved.
//

import UIKit

//基础的ViewController
class BaseViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(!LoginUserTools.checkIsLogin())
        {
            showLoginView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //登录
    func showLoginView()
    {
        let loginViewController = LoginViewController()
        self.presentViewController(loginViewController, animated: true, completion: nil)
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
