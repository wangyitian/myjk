//
//  FastLoginController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
//import AVOSCloud

class FastLoginController: UIViewController ,KeyboardScrollable{

    @IBOutlet var phoneNumberLabel : UITextField!
    @IBOutlet var sendCodeBtn : YBPhoneCodeButton!
    @IBOutlet var codeField : UITextField!
    
    @IBOutlet var keyboardScrollView : UIScrollView! 
    
    var lastSendCodePhoneNumber = ""
    
    @IBAction func sendCodeBtnAction() {
        guard let phoneNumber = phoneNumberLabel.text where PhoneNumberIsLegal(phoneNumber) else {
            YBToastView.showToast(inView: view, withText: "电话号码不合法")
            return
        }
        AVOSCloud.requestSmsCodeWithPhoneNumber(phoneNumber, appName: "美域健康", operation: "注册验证", timeToLive: 10) { (success, error : NSError?) -> Void in
            if success {
                YBToastView.showToast(inView: self.view, withText: "验证码发送成功")
                self.lastSendCodePhoneNumber = phoneNumber
            } else {
                YBToastView.showToast(inView: self.view, withText: "验证码发送失败")
                self.sendCodeBtn.btnState = .Normal
            }
        }
        sendCodeBtn.btnState = .Countdowning
    }
    
    
    @IBAction func nextStepBtnAction() {
        AVOSCloud.verifySmsCode(codeField.text, mobilePhoneNumber: lastSendCodePhoneNumber) { (success, error : NSError?) -> Void in
            print(success)
            print(error)
        }
        
        guard let phoneNumber = phoneNumberLabel.text where PhoneNumberIsLegal(phoneNumber) else {
            YBToastView.showToast(inView: view, withText: "电话号码不合法")
            return
        }
        guard let code = codeField.text where code != "" else {
            YBToastView.showToast(inView: view, withText: "请输入验证码")
            return
        }
       
        var dic = [String:AnyObject]()
        dic["mobile"] = phoneNumber
        dic["smscode"] = code
   
        
        SharedNetWorkManager.GET(kregisterUrlString, parameters: dic, success: { (task, result) -> Void in
            print(task.originalRequest)
            if let result =  result as? [String:AnyObject]{
                if let code = result["code"] as? String ,let msg = result["msg"] as? String{
                    YBToastView.showToast(inView: self.view, withText: msg)
                    if code == "0"{
                        //成功
                        YBToastView.showToast(inView: self.view, withText: "登录成功")
                        let data = result["data"] as! [String:AnyObject]
                        
                        SharedUserInfo.phoneNumber = phoneNumber
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
                print(task?.originalRequest)
                YBToastView.showToast(inView: self.view, withText: "登录失败，请检查网络")
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(FastLoginController.back))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpKeyboardScrollable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardScrollable()
    }
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
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
