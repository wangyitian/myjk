//
//  ModifyInfoController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
import AFNetworking

private let kLocatePickerTopViewTag = 1199
class ModifyInfoController: UIViewController ,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,KeyboardScrollable{
    var data = [[String:AnyObject]]()
    var subDatas = [String:[[String:AnyObject]]]()
    var dataSicks = [[String:AnyObject]]()
    var subSicks = [String:[[String:AnyObject]]]()
    var dataCitys = [[String:AnyObject]]()
    var subCitys = [String:[[String:AnyObject]]]()
    @IBOutlet var sexBtn:[UIButton]!
    @IBOutlet var nameTextFeild:UITextField!
    @IBOutlet var phoneTextFeild:UITextField!
    @IBOutlet var mailTextFeild:UITextField!
    @IBOutlet var birthTextFeild:UIButton!
    @IBOutlet var addressTextFeild:UITextField!
    @IBOutlet var mailNumTextFeild:UITextField!
    @IBOutlet var cityName:UILabel!
    @IBOutlet var sickBtn:UIButton!
    @IBOutlet var zhuzhiBtn : UIButton!
   
    @IBOutlet var keyboardScrollView : UIScrollView! 
    
    var sicksId : String?
    var cityId : String?
    var pickView:UIPickerView?
    var datePicker : UIDatePicker?
    var buView : UIView?
    var toPay = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "个人信息"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(ModifyInfoController.back))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setUpKeyboardScrollable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboardScrollable()
    }
    
    @IBAction func saveInfo(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        mailTextFeild.resignFirstResponder()
        addressTextFeild.resignFirstResponder()
        mailNumTextFeild.resignFirstResponder()
        guard let name = nameTextFeild.text where name != "" else {
            YBToastView.showToast(inView: view, withText: "请输入姓名")
            return
        }
        guard let phone = phoneTextFeild.text where phone != "" else {
            YBToastView.showToast(inView: view, withText: "请输入手机号")
            return
        }
        
        var dic = [String:AnyObject]()
        dic["nickname"] = name
        dic["mymobile"] = phone
        if let mail = mailTextFeild.text where mail != ""{
            dic["myemail"] = mail
        }
        if sexBtn[0].selected{
            dic["gender"] = "男"
        }
        if sexBtn[1].selected{
            dic["gender"] = "女"
        }
        if let birth = birthTextFeild.titleLabel?.text where birth != "" && birth != "请选择"{
            dic["birthday"] = birth
        }
        if let id = sicksId{
            dic["maladyid"] = id
        }
        if let city = cityId{
            dic["areaid"] = city
        }
        if let add = addressTextFeild.text where add != ""{
            dic["address"] = add
        }
        if let code = mailNumTextFeild.text where code != ""{
            dic["postcode"] = code
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        let jsonSerializer =  AFJSONRequestSerializer()
        let originalSerializer = SharedNetWorkManager.requestSerializer
        SharedNetWorkManager.requestSerializer = jsonSerializer
        SharedNetWorkManager.POST(kmodifyInfoUrlString, parameters: dic, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String{
                YBToastView.showToast(inView: self.view, withText: msg)
                if code == "401"{
                    SharedUserInfo.clearUserInfo()
                    SharedUserInfo.showLoginView()
                    return
                }
                if code == "0"{
                    
                    if self.toPay{
                        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YuanchengPayController") as! YuanchengPayController
                            ctl.type = 1
                        self.navigationController?.pushViewController(ctl, animated: true)
                        return
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            print(task.originalRequest)
            
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                print(error)
                print(task?.originalRequest)
        }
        SharedNetWorkManager.requestSerializer = originalSerializer
    }
    
    @IBAction func showSicksPickView(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        mailTextFeild.resignFirstResponder()
        addressTextFeild.resignFirstResponder()
        mailNumTextFeild.resignFirstResponder()
        cancleDatePicker()
        canleSickView()
        
        guard dataSicks.count > 0 else {
            YBToastView.showToast(inView: view, withText: "请检查网络，稍后再试")
            return
        }
        data.removeAll()
        subDatas.removeAll()
        data = dataSicks
        subDatas = subSicks
        if let _ = pickView,let _ = buView{
            
        }else{
            buView = UIView(frame: CGRectMake(0,self.view.frame.height - 190, self.view.frame.width,40))
            buView!.backgroundColor = UIColor(hexString: "eeeeee")
            let cancleBt = UIButton(frame: CGRectMake(22,10, 40,20))
            cancleBt.setTitle("取消", forState: .Normal)
            let sureBt = UIButton(frame: CGRectMake(self.view.frame.width - 55,10, 40,20))
            cancleBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            cancleBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            cancleBt.addTarget(self, action: #selector(ModifyInfoController.canleSickView), forControlEvents: UIControlEvents.TouchUpInside)
            sureBt.setTitle("确定", forState: .Normal)
            sureBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sureBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            sureBt.addTarget(self, action: #selector(ModifyInfoController.finishSelectSick), forControlEvents: .TouchUpInside)
            buView!.addSubview(sureBt)
            buView!.addSubview(cancleBt)
            pickView = UIPickerView(frame: CGRectMake(0,self.view.frame.height - 150, self.view.frame.width,194))
            pickView?.delegate = self
            pickView?.dataSource = self
            pickView?.backgroundColor = UIColor(hexString: "eeeeee")
        }
        self.view.addSubview(pickView!)
        self.view.addSubview(buView!)

    }
    
    @IBAction func tapView(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        mailTextFeild.resignFirstResponder()
        addressTextFeild.resignFirstResponder()
        mailNumTextFeild.resignFirstResponder()
        cancleDatePicker()
        canleSickView()
    }
    
    @IBAction func showDatePicker(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        mailTextFeild.resignFirstResponder()
        addressTextFeild.resignFirstResponder()
        mailNumTextFeild.resignFirstResponder()
        cancleDatePicker()
        canleSickView()
        if let _ = datePicker,let _ = buView{
            
        }else{
            buView = UIView(frame: CGRectMake(0,self.view.frame.height - 190, self.view.frame.width,40))
            buView!.backgroundColor = UIColor(hexString: "eeeeee")
            let cancleBt = UIButton(frame: CGRectMake(22,10, 40,20))
            cancleBt.setTitle("取消", forState: .Normal)
            let sureBt = UIButton(frame: CGRectMake(self.view.frame.width - 55,10, 40,20))
            cancleBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            cancleBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            cancleBt.addTarget(self, action: #selector(ModifyInfoController.cancleDatePicker), forControlEvents: UIControlEvents.TouchUpInside)
            sureBt.setTitle("确定", forState: .Normal)
            sureBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sureBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            sureBt.addTarget(self, action: #selector(ModifyInfoController.finishDateSelect), forControlEvents: .TouchUpInside)
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
        currentRow = 0
        currentSubRow = 0
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
    
    func canleSickView(){
        guard let _ = pickView else {
            return
        }
        
        pickView?.removeFromSuperview()
        buView?.removeFromSuperview()
        
        pickView?.delegate = nil
        pickView = nil
        buView = nil
        currentRow = 0
        currentSubRow = 0
    }
    
    func finishSelectSick(){
        guard let pick = pickView else {
            return
        }
        if let id = subSicks[dataSicks[currentRow]["linkageid"] as! String]{
            let sickname = dataSicks[currentRow]["name"] as! String
            let subName = id[currentSubRow]["name"] as! String
            sickBtn.setTitle(sickname + " " + subName, forState: UIControlState.Normal)
            sickBtn.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sicksId = id[currentSubRow]["linkageid"] as? String
        }else{
            sickBtn.setTitle(dataSicks[currentRow]["name"] as? String, forState: UIControlState.Normal)
            sickBtn.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sicksId = dataSicks[currentRow]["linkageid"] as? String
        }
        canleSickView()
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        canleSickView()
        cancleDatePicker()
    }
    
    @IBAction func sexSelected(button:UIButton){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        mailTextFeild.resignFirstResponder()
        addressTextFeild.resignFirstResponder()
        mailNumTextFeild.resignFirstResponder()
        cancleDatePicker()
        canleSickView()
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
    
//choose city
    
    @IBAction func showCityChoose(){
        nameTextFeild.resignFirstResponder()
        phoneTextFeild.resignFirstResponder()
        mailTextFeild.resignFirstResponder()
        addressTextFeild.resignFirstResponder()
        mailNumTextFeild.resignFirstResponder()
        cancleDatePicker()
        canleSickView()
        guard dataCitys.count > 0 else {
            YBToastView.showToast(inView: view, withText: "请检查网络，稍后再试")
            return
        }
        data.removeAll()
        subDatas.removeAll()
        data = dataCitys
        subDatas = subCitys
        if let _ = pickView,let _ = buView{
            
        }else{
            buView = UIView(frame: CGRectMake(0,self.view.frame.height - 190, self.view.frame.width,40))
            buView!.backgroundColor = UIColor(hexString: "eeeeee")
            let cancleBt = UIButton(frame: CGRectMake(22,10, 40,20))
            cancleBt.setTitle("取消", forState: .Normal)
            let sureBt = UIButton(frame: CGRectMake(self.view.frame.width - 55,10, 40,20))
            cancleBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            cancleBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            cancleBt.addTarget(self, action: #selector(ModifyInfoController.canleSickView), forControlEvents: UIControlEvents.TouchUpInside)
            sureBt.setTitle("确定", forState: .Normal)
            sureBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sureBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            sureBt.addTarget(self, action: #selector(ModifyInfoController.finishSelectCity), forControlEvents: .TouchUpInside)
            buView!.addSubview(sureBt)
            buView!.addSubview(cancleBt)
            pickView = UIPickerView(frame: CGRectMake(0,self.view.frame.height - 150, self.view.frame.width,194))
            pickView?.delegate = self
            pickView?.dataSource = self
            pickView?.backgroundColor = UIColor(hexString: "eeeeee")
        }
        self.view.addSubview(pickView!)
        self.view.addSubview(buView!)
        
    }

   
    
    func finishSelectCity(){
        guard let pick = pickView else {
            return
        }
        if let id = subCitys[dataCitys[currentRow]["linkageid"] as! String]{
            let sickname = dataCitys[currentRow]["name"] as! String
            let subName = id[currentSubRow]["name"] as! String
            cityName.text = sickname + " " + subName
            cityName.textColor = UIColor(hexString: "343434")
            cityId = id[currentSubRow]["linkageid"] as? String
        }else{
           cityName.text = dataCitys[currentRow]["name"] as? String
            cityName.textColor = UIColor(hexString: "343434")
            cityId = dataCitys[currentRow]["linkageid"] as? String
        }
        canleSickView()

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFeild.delegate = self
        phoneTextFeild.delegate = self
        mailTextFeild.delegate = self
        addressTextFeild.delegate = self
        mailNumTextFeild.delegate = self
        
        zhuzhiBtn.setBackgroundImage(UIImage(named: "住址框（下拉菜单）")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 5, 0, 25)), forState: .Normal)
        
        nameTextFeild.leftView = UIView(frame: CGRectMake(0,0,16,nameTextFeild.frame.height))
        nameTextFeild.leftViewMode = UITextFieldViewMode.Always
        phoneTextFeild.leftView = UIView(frame: CGRectMake(0,0,16,phoneTextFeild.frame.height))
        phoneTextFeild.leftViewMode = UITextFieldViewMode.Always
        mailTextFeild.leftView = UIView(frame: CGRectMake(0,0,16,mailTextFeild.frame.height))
        mailTextFeild.leftViewMode = UITextFieldViewMode.Always
        addressTextFeild.leftView = UIView(frame: CGRectMake(0,0,16,addressTextFeild.frame.height))
        addressTextFeild.leftViewMode = UITextFieldViewMode.Always
        mailNumTextFeild.leftView = UIView(frame: CGRectMake(0,0,16,mailNumTextFeild.frame.height))
        mailNumTextFeild.leftViewMode = UITextFieldViewMode.Always

        sexBtn[0].selected = true
        nameTextFeild.text = SharedUserInfo.name
        phoneTextFeild.text = SharedUserInfo.mymobile
        if SharedUserInfo.sex == "女"{
            sexBtn[1].selected = true
            sexBtn[0].selected = false
        }
        mailTextFeild.text = SharedUserInfo.myemail
        if SharedUserInfo.birthday != ""{
            birthTextFeild.setTitle(SharedUserInfo.birthday, forState: .Normal)
            birthTextFeild.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
        }else{
            birthTextFeild.setTitle("请选择", forState: .Normal)
        }
        addressTextFeild.text = SharedUserInfo.address
        mailNumTextFeild.text = SharedUserInfo.postcode
        if SharedUserInfo.sickName != ""{
            sickBtn.setTitle(SharedUserInfo.sickName, forState: .Normal)
            sickBtn.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
        }else{
            sickBtn.setTitle("请选择", forState: .Normal)
        }
        if SharedUserInfo.city != ""{
            cityName.text = SharedUserInfo.city
            cityName.textColor = UIColor(hexString: "343434")
        }else{
            cityName.text = "请选择"
            cityName.textColor = UIColor.lightGrayColor()
        }
        
        fetchData()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
    }
    //MARK: - UIPickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0{
            return data.count
        }else{
            guard let id = subDatas[data[currentRow]["linkageid"] as! String] else {
                return 0
            }
            return id.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if component == 0{
            return data[row]["name"] as? String
        }else{
            guard let id = subDatas[data[currentRow]["linkageid"] as! String] else {
                return "空"
            }
            return id[row]["name"] as? String
        }
        
    }

    var currentRow = 0
    var currentSubRow = 0
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0{
            currentRow = row
            pickView?.reloadComponent(1)
        }
        if component == 1{
            currentSubRow = row
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchData(){
        SharedNetWorkManager.GET(kcityAndSickUrlString, parameters: ["keyid":3362], success: { (task, result) -> Void in
            print(task.originalRequest)
            if let result = result as? [String:AnyObject],let data = result["data"] as? [AnyObject]{
                for obj in data{
                    if let sick  = obj as? [String:AnyObject],let parentId = sick["parentid"] as? String{
                        if parentId == "0"{
                            self.dataSicks.append(sick)
                        }else{
                            if self.subSicks[parentId]?.count > 0{
                                self.subSicks[parentId]?.append(sick)
                            }else{
                                self.subSicks[parentId] = [sick]
                            }
                            
                        }
                        
                    }
                }
            }

            }) { (task, error) -> Void in
                
        }
        
        
        SharedNetWorkManager.GET(kcityAndSickUrlString, parameters: ["keyid":1], success: { (task, result) -> Void in
            print(task.originalRequest)
            if let result = result as? [String:AnyObject],let data = result["data"] as? [AnyObject]{
                for obj in data{
                    if let sick  = obj as? [String:AnyObject],let parentId = sick["parentid"] as? String{
                        if parentId == "0"{
                            self.dataCitys.append(sick)
                        }else{
                            if self.subCitys[parentId]?.count > 0{
                                self.subCitys[parentId]?.append(sick)
                            }else{
                                self.subCitys[parentId] = [sick]
                            }
                            
                        }
                        
                    }
                }
            }
            
            }) { (task, error) -> Void in
                
        }

    }

}
