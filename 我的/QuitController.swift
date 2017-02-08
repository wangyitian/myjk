//
//  QuitController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/19.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class QuitController: UIViewController {

    @IBAction func logout(){
        SharedNetWorkManager.GET(klogoutUrlString, parameters: nil, success: { (task, result) -> Void in
            //退出成功
            YBToastView.showToast(inView: self.view, withText: "退出成功")
            SharedUserInfo.clearUserInfo()
            self.removeControllerAndViewFromParent()
            NSNotificationCenter.defaultCenter().postNotificationName("quit", object: nil)
            }) { (task, error) -> Void in
                print(error)
                YBToastView.showToast(inView: self.view, withText: "退出失败")
                self.removeControllerAndViewFromParent()
        }
        
    }
    
    @IBAction func cancle(){
        self.removeControllerAndViewFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
