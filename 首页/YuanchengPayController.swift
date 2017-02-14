//
//  YuanchengPayController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/13.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit
import BeeCloud

class YuanchengPayController: UIViewController ,BeeCloudDelegate{

    @IBOutlet var chooseBtn:UIButton!
    @IBOutlet var product_name:UILabel!
    @IBOutlet var product_price:UILabel!
    @IBOutlet var hetongCheck:UIButton!
    @IBOutlet var hetongBtn : UIButton!
    var price : String?
    var productId : AnyObject?
    var type : Int?
    var productName = ""
    @IBAction func toPay(){
        guard let tii = type else {
            return
        }
        guard let pri = price else {//获取订单成功
            return
        }
        guard let id = productId else {//获取订单成功
            return
        }
        if pri == "0"{
            YBToastView.showToast(inView: view, withText: "该项目未定价，请联系客服后再支付")
            return
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kbuyUrlString, parameters: ["type":tii,"product_id":id], success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String,let data = result["data"] as? [String:AnyObject]{
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
                        if let order_amount = order["order_amount"] as? String,let order_sn = order["order_sn"] as? String,let product_name = order["product_name"] as? String{
                            guard let priceY = Double(order_amount) else {
                                return
                            }
                            let priceYuan = Int(priceY)
                            let priceFee  = String(priceYuan * 100)
                            print(product_name)
                            let payReq = BCPayReq()
                            payReq.title = product_name
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
                YBToastView.showToast(inView: self.view, withText: "网络错误")
                YBToastView.hideLoadingToast()
        }

        
        
    }
    
    @IBAction func showHeTong(){
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HeTongController") as! HeTongController
        ctl.typeNum = type
        ctl.titleName = productName + "合同"
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "支 付"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(YuanchengPayController.back))
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
        chooseBtn.selected = true
        hetongCheck.selected = true
        
        if type == 1{
            SharedNetWorkManager.GET(kproductListUrlString, parameters: ["type":1], success: { (task, result) -> Void in
                if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String,let data = result["data"] as? [AnyObject]{
                    if msg != ""{
                        
                        YBToastView.showToast(inView: self.view, withText: msg)
                    }
                    if code == "0"{
                        for obj in data{
                            if let one = obj as? [String:AnyObject]{
                                
                                if let pri = one["price"] as? String{
                                    self.price = pri
                                    self.product_price.text = "￥\(pri)"
                                }
                                if let id = one["product_id"]{
                                    self.productId = id
                                }
                            }
                        }
                    }
                }
                }) { (task, error) -> Void in
                    
            }

        }else{
            hetongBtn.setTitle(productName + "合同", forState: .Normal)
            product_name.text = productName
            if let pri = price{
                self.product_price.text = "￥\(pri)"
            }
        }
               // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: BeeCloud delegate
    func onBeeCloudResp(resp: BCBaseResp!) {
        YBToastView.showToast(inView: view, withText: resp.resultMsg)
        if resp.resultCode == 0{
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
   
    
}
