//
//  FindPasswordController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
//import AVOSCloud

class FindPasswordController: UIViewController ,KeyboardScrollable{

    @IBOutlet var phoneNumberLabel : UITextField!
    @IBOutlet var sendCodeBtn : YBPhoneCodeButton!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var password2TextField : UITextField!
    @IBOutlet var codeField : UITextField!
    
    @IBOutlet var keyboardScrollView : UIScrollView!
    
    var lastSendCodePhoneNumber = ""
    
    @IBAction func updataPassword(){
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
        guard let password = passwordTextField.text where password != "" else {
            YBToastView.showToast(inView: view, withText: "请输入密码")
            return
        }
        guard let password2 = password2TextField.text where password2 == password else {
            YBToastView.showToast(inView: view, withText: "两次输入密码不一致")
            return
        }
        var dic = [String:AnyObject]()
        dic["mobile"] = phoneNumber
        dic["smscode"] = code
        dic["password"] = password
        dic["password2"] = password2
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kfindPasswordUrlString, parameters: dic, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            print(task.originalRequest)
            if let result =  result as? [String:AnyObject]{
                if let code = result["code"] as? String ,let msg = result["msg"] as? String{
                    YBToastView.showToast(inView: self.view, withText: msg)
                    if code == "0"{
                        //成功
                        YBToastView.showToast(inView: self.view, withText: "登录成功")
                        SharedUserInfo.phoneNumber = phoneNumber
                        SharedUserInfo.password = password
                        guard let data = result["data"] as? [String:AnyObject] else {
                            SharedUserInfo.synchronize()
                            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                                
                            })
                            return
                        }
                        
                        
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
                print(task?.originalRequest)
                YBToastView.showToast(inView: self.view, withText: "登录失败，请检查网络")
        }

    }
    
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(FindPasswordController.back))
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
