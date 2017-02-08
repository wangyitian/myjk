//
//  RegistController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
//import AVOSCloud

func PhoneNumberIsLegal(phone : String?) -> Bool {
    if let phoneNum = phone, _ = Int64(phoneNum) where phoneNum.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) == 11 {
        return true
    }
    return false
}

class RegistController: UIViewController , KeyboardScrollable{
    
    @IBOutlet var phoneNumberLabel : UITextField!
    @IBOutlet var sendCodeBtn : YBPhoneCodeButton!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var password2TextField : UITextField!
    var lastSendCodePhoneNumber = ""
    @IBOutlet var checkBtn:UIButton!
    
    @IBOutlet var keyboardScrollView : UIScrollView!
    
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
    
    @IBOutlet var codeField : UITextField!
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
        SharedNetWorkManager.GET(kregisterUrlString, parameters: dic, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            print(task.originalRequest)
            print(result)
            if let result =  result as? [String:AnyObject]{
                if let code = result["code"] as? String ,let msg = result["msg"] as? String{
                    YBToastView.showToast(inView: self.view, withText: msg)
                    if code == "0"{
                        //注册成功
                        YBToastView.showToast(inView: self.view, withText: "注册成功")
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
                print(task?.originalRequest)
                YBToastView.hideLoadingToast()
                YBToastView.showToast(inView: self.view, withText: "注册失败")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        checkBtn.selected = true
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
