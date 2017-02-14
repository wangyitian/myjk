//
//  PayController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
import BeeCloud

class PayController: UIViewController, BeeCloudDelegate {
    @IBOutlet var chooseBtn:UIButton!
    @IBOutlet var hetongBtn:UIButton!
    @IBOutlet var product_name:UILabel!
    @IBOutlet var product_sub:UILabel!
    @IBOutlet var product_price:UILabel!
    @IBOutlet var hetong:UIButton!
    @IBOutlet var hetongCheck:UIButton!
    @IBOutlet var changeBtn : UIButton!
    
    var dataPro = ["行政体检项目","心脏评估项目","肺部状况评估项目"]
    var dataSub = [[String:AnyObject]]()
    
    var selectProduct : Int?
    var selectSub : Int?
    var pickView:UIPickerView?
    var buView : UIView?
    
    @IBAction func toPay(){
        guard let row = selectProduct else {
            YBToastView.showToast(inView: view, withText: "请选择项目")
            return
        }
        guard let subRow = selectSub else {
            YBToastView.showToast(inView: view, withText: "请选择套餐")
            return
        }
        guard let productId = dataSub[subRow]["product_id"] as? String else {
            return
        }
       
        guard let price = dataSub[subRow]["price"] as? String else {
            
            return
        }
        if price == "0"{
            YBToastView.showToast(inView: view, withText: "该项目未定价，请联系客服后再支付")
            return
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedJsonPostNetWorkManager.POST(kbuyUrlString, parameters: ["type":3,"classify":row + 1,"product_id":productId], success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String ,let data = result["data"] as? [String:AnyObject]{
                if msg != ""{
                    
                    YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "401"{
                    SharedUserInfo.showLoginView()
                    return
                }
                if code == "0"{
                     YBToastView.showToast(inView: self.view, withText: "订单提交成功")
                    if let order = data["order"] as? [String:AnyObject]{
                        if let order_amount = order["order_amount"] as? String,let order_sn = order["order_sn"] as? String,let productName = order["product_name"] as? String{
                            guard let priceY = Double(order_amount) else {
                                return
                            }
                            print(productName)
                            let priceYuan = Int(priceY)
                            let priceFee  = String(priceYuan * 100)
                            let payReq = BCPayReq()
                            payReq.title = productName
                            payReq.channel = .WxApp
                            payReq.totalFee = priceFee
                            payReq.billTimeOut = 3600
                            payReq.billNo = order_sn
                            payReq.viewController = self
                            BeeCloud.sendBCReq(payReq)
                        }
                    }
                }

            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
        }
    }
    
  
    
    @IBAction func showHeTong(){
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HeTongController") as! HeTongController
        ctl.typeNum = 3
        ctl.titleName = "高端体检合同"
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    @IBAction func showList(sender:UIButton){
        canclePickView()
        
        guard dataSub.count > 0 else {
            YBToastView.showToast(inView: view, withText: "请检查网络，稍后再试")
            return
        }
        
        if let _ = pickView,let _ = buView{
            
        }else{
            buView = UIView(frame: CGRectMake(0,self.view.frame.height - 190, self.view.frame.width,40))
            buView!.backgroundColor = UIColor(hexString: "eeeeee")
            let cancleBt = UIButton(frame: CGRectMake(22,10, 40,20))
            cancleBt.setTitle("取消", forState: .Normal)
            let sureBt = UIButton(frame: CGRectMake(self.view.frame.width - 55,10, 40,20))
            cancleBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            cancleBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            cancleBt.addTarget(self, action: #selector(PayController.canclePickView), forControlEvents: UIControlEvents.TouchUpInside)
            sureBt.setTitle("确定", forState: .Normal)
            sureBt.setTitleColor(UIColor(hexString: "343434"), forState: UIControlState.Normal)
            sureBt.titleLabel?.font = UIFont.systemFontOfSize(13)
            sureBt.addTarget(self, action: #selector(PayController.finishSelected), forControlEvents: .TouchUpInside)
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
    
    
    func canclePickView(){
        guard let _ = pickView else {
            return
        }
        
        pickView?.removeFromSuperview()
        buView?.removeFromSuperview()
        
        pickView?.delegate = nil
        pickView = nil
        buView = nil
   
    }
    
    func finishSelected(){
        guard let _ = pickView else {
            return
        }
        selectProduct = pickView?.selectedRowInComponent(0)
        selectSub = pickView?.selectedRowInComponent(1)
        
        product_name.text = "高端体检-" + dataPro[selectProduct!]
        product_sub.text = dataSub[selectSub!]["name"] as? String
        product_price.text = "￥\(dataSub[selectSub!]["price"] as! String)"
        canclePickView()
        changeBtn.setTitle("点击更改", forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "支 付"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(PayController.back))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        BeeCloud.setBeeCloudDelegate(self)
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        if BeeCloud.getBeeCloudDelegate() === self {
            BeeCloud.setBeeCloudDelegate(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hetongBtn.selected = true
        chooseBtn.selected = true
        hetongCheck.selected = true
        if let selectRow = selectProduct{
            product_name.text = dataPro[selectRow]
        }else{
            product_name.text = ""
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
    
    func fetchData(){
        
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kproductListUrlString, parameters: ["type":3], success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String,let data = result["data"] as? [AnyObject]{
                if msg != ""{
                    
                    YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "0"{
                    
                    for obj in data{
                        if let one = obj as? [String:AnyObject]{
                            self.dataSub.append(one)
                        }
                    }
                    if self.dataSub.count > 0{
                        if let row = self.selectSub{
                            self.product_sub.text = self.dataSub[row]["name"] as? String
                            let str = self.dataSub[row]["price"] as! String
                            self.product_price.text = "￥" + str
                            self.changeBtn.setTitle("点击更改", forState: .Normal)
                        }else{
                            self.product_sub.text = ""
                            self.product_price.text = ""
                            self.changeBtn.setTitle("请选择", forState: .Normal)
                        }
                    }
                }
            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
        }
        
    }

}
extension PayController:UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0{
            return dataPro.count
        }else{
            return dataSub.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if component == 0{
            return dataPro[row]
        }else{
            return dataSub[row]["name"] as? String
        }
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        if component == 0{
            return self.view.frame.width * 0.6
        }else{
            return self.view.frame.width * 0.4
        }
    }
    
    
    //MARK: BeeCloud delegate
    func onBeeCloudResp(resp: BCBaseResp!) {
        YBToastView.showToast(inView: view, withText: resp.resultMsg)
        if resp.resultCode == 0{
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
