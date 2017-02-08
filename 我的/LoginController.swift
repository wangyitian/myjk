//
//  LoginController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
//import AVOSCloud

class LoginController: UIViewController, KeyboardScrollable {
    @IBOutlet var phoneNum : UITextField!
    @IBOutlet var passwordField : UITextField!
    @IBOutlet var keyboardScrollView : UIScrollView!
    
    @IBAction func login(){
   
        
        guard let phoneNumber = phoneNum.text where PhoneNumberIsLegal(phoneNumber) else {
            YBToastView.showToast(inView: view, withText: "电话号码不合法")
            return
        }
       
        guard let password = passwordField.text where password != "" else {
            YBToastView.showToast(inView: view, withText: "请输入密码")
            return
        }
        
        var dic = [String:AnyObject]()
        dic["mobile"] = phoneNumber
        dic["password"] = password
        YBToastView.showLoadingToast(inView: self.view, blockSuperView: true)
        SharedNetWorkManager.GET(kloginUrlString, parameters: dic, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result =  result as? [String:AnyObject]{
                if let code = result["code"] as? String ,let msg = result["msg"] as? String{
                    YBToastView.showToast(inView: self.view, withText: msg)
                    if code == "0"{
                        //登录成功
                        YBToastView.showToast(inView: self.view, withText: "登录成功")
                        let data = result["data"] as! [String:AnyObject]
                        
                        SharedUserInfo.phoneNumber = phoneNumber
                        SharedUserInfo.password = password
                        if let name = data["nickname"] as? String{
                            SharedUserInfo.name = name
                        }
                        if let userid = data["userid"] as? String{
                            SharedUserInfo.userId = userid
                        }
                        if let groupid = data["groupid"] as? String{
                            SharedUserInfo.groupid = groupid
                        }
                        if let regdata = data["regdata"] as? String{
                            SharedUserInfo.regdate = regdata
                        }
                        SharedUserInfo.synchronize()

                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            
                        })
                            
                        }
                    }
                }

            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                print(error)
                YBToastView.showToast(inView: self.view, withText: "登录失败，请检查网络")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpKeyboardScrollable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardScrollable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        SharedUserInfo.clearUserInfo()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
