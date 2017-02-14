//
//  KnowMoreController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/11.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class KnowMoreController: UIViewController ,KeyboardScrollable,UITextFieldDelegate{

    @IBOutlet var nameTextFeild:UITextField!
    @IBOutlet var phoneTextFeild:UITextField!
    @IBOutlet var birthTextFeild:UIButton!
    @IBOutlet var sexBtn:[UIButton]!
    
    @IBOutlet var keyboardScrollView : UIScrollView!
    
    var datePicker : UIDatePicker?
    var buView : UIView?

    @IBAction func commit(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        cancleDatePicker()
        guard let name = nameTextFeild.text where name != "" else {
            YBToastView.showToast(inView: view, withText: "请输入姓名")
            return
        }
        guard let phone = phoneTextFeild.text where phone != "" else {
            YBToastView.showToast(inView: view, withText: "请输入手机号")
            return
        }
        
        var dic = [String:AnyObject]()
        dic["realname"] = name
        dic["mymobile"] = phone
     
        if sexBtn[0].selected{
            dic["gender"] = "男"
        }
        if sexBtn[1].selected{
            dic["gender"] = "女"
        }
        if let birth = birthTextFeild.titleLabel?.text where birth != ""{
            dic["birthyear"] = birth
        }
        SharedNetWorkManager.GET(kjingzhunUrlString, parameters: dic, success: { (task, result) -> Void in
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String{
                if msg != ""{
                    YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "0"{
                    let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FuMeiAlertController") as! FuMeiAlertController
                    self.addChildControllerAndView(ctl)
                    
                }
            }
            }) { (task, error) -> Void in
                
        }
    }
    
    @IBAction func sexSelected(button:UIButton){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        birthTextFeild.resignFirstResponder()
        cancleDatePicker()
        
        guard let index = sexBtn.indexOf(button) else{
            return
        }
        for(var i = 0;i < sexBtn.count;i++){
            if i == index{
                sexBtn[i].selected = true
            }else{
                sexBtn[i].selected = false
            }
        }
        
    }
    
    @IBAction func showDatePicker(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        birthTextFeild.resignFirstResponder()
        
        if let _ = datePicker,let _ = buView{
            
        }else{
            buView = UIView(frame: CGRectMake(0,self.view.frame.height - 190, self.view.frame.width,40))
            buView!.backgroundColor = UIColor(hexString: "eeeeee")
            let cancleBt = UIButton(frame: CGRectMake(22,10, 40,20))
            cancleBt.setTitle("取消", forState: .Normal)
            let sureBt = UIButton(frame: CGRectMake(self.view.frame.width - 55,10, 40,20))
            cancleBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            cancleBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            cancleBt.addTarget(self, action: #selector(KnowMoreController.cancleDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
            sureBt.setTitle("确定", forState: .Normal)
            sureBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sureBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            sureBt.addTarget(self, action: #selector(KnowMoreController.finishDateSelect), forControlEvents: .TouchUpInside)
            buView!.addSubview(sureBt)
            buView!.addSubview(cancleBt)
            datePicker = UIDatePicker(frame: CGRectMake(0,self.view.frame.height - 150, self.view.frame.width,194))
            datePicker?.datePickerMode = UIDatePickerMode.Date
            datePicker?.backgroundColor = UIColor(hexString: "eeeeee")
            datePicker?.maximumDate = NSDate()
        }
        self.view.addSubview(datePicker!)
        self.view.addSubview(buView!)
        
    }
    
    func cancleDatePicker(){
        guard let _ = datePicker else {
            return
        }
        
        datePicker?.removeFromSuperview()
        buView?.removeFromSuperview()
        
        datePicker = nil
        buView = nil
    }
    
    func finishDateSelect(){
        guard let pick = datePicker else {
            return
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.stringFromDate(pick.date)
        
        birthTextFeild.setTitle(dateString, forState: .Normal)
        birthTextFeild.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
        cancleDatePicker()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        cancleDatePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFeild.delegate = self
        phoneTextFeild.delegate = self
   
        
        navigationItem.title = "我想进一步了解精准医疗"
        navigationItem.leftBarButtonItem = GetTopUIBarButtonItem(self, action: #selector(KnowMoreController.back))
         sexBtn[0].selected = true
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
