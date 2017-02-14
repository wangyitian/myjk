//
//  ModifyPasswordController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class ModifyPasswordController: UIViewController ,KeyboardScrollable{

    @IBOutlet var currentPassword:UITextField!
    @IBOutlet var passwordTextField:UITextField!
    @IBOutlet var password2TextField:UITextField!
    
    @IBOutlet var keyboardScrollView : UIScrollView!
    
    @IBAction func modifyPassword(){
        guard let cupassword = currentPassword.text where cupassword != "" else {
            YBToastView.showToast(inView: view, withText: "请输入当前密码")
            return
        }
        guard let password = passwordTextField.text where password != "" else {
            YBToastView.showToast(inView: view, withText: "请输入新密码")
            return
        }
        guard let password2 = password2TextField.text where password2 == password else {
            YBToastView.showToast(inView: view, withText: "两次输入新密码不一致")
            return
        }
        var dic = [String:AnyObject]()
        dic["oldpassword"] = cupassword
        dic["password"] = password
        dic["password2"] = password2
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kmodifyInfoUrlString, parameters: dic, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            print(task.originalRequest)
            if let result =  result as? [String:AnyObject]{
                if let code = result["code"] as? String ,let msg = result["msg"] as? String{
                    YBToastView.showToast(inView: self.view, withText: msg)
                    if code == "0"{
                        //成功
                        let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("modifyPasswordAlert")
                        self.addChildControllerAndView(ctl)
                    }
                }
            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                print(task?.originalRequest)
        }
        

      
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "修改密码"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(ModifyPasswordController.back))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
