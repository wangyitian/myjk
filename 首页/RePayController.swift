//
//  RePayController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/23.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit
import BeeCloud

class RePayController: UIViewController  ,BeeCloudDelegate{

    @IBOutlet var productName : UILabel!
    @IBOutlet var priceLabel : UILabel!
    @IBOutlet var payChooseBtn : UIButton!
    
    var pro_name : String?
    var price : String?
    var orderNum : String?
    
    @IBAction func toPay(){
        guard let snd = orderNum else {
            return
        }
        guard let pri = price else {
            return
        }
        guard let priceY = Double(pri) else {
            return
        }
        let priceYuan = Int(priceY)
        let priceFee  = String(priceYuan * 100)
        print(pro_name)
        let payReq = BCPayReq()
        payReq.title = pro_name
        payReq.channel = .WxApp
        payReq.totalFee = priceFee
        payReq.billTimeOut = 3600
        payReq.billNo = snd
        payReq.viewController = self
        BeeCloud.sendBCReq(payReq)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "支 付"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(RePayController.back))
        payChooseBtn.selected = true
        if let name = pro_name{
            productName.text = name
        }
        if let pri = price{
            priceLabel.text = "￥" + pri
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    //MARK: BeeCloud delegate
    func onBeeCloudResp(resp: BCBaseResp!) {
        YBToastView.showToast(inView: view, withText: resp.resultMsg)
        if resp.resultCode == 0{
            NSNotificationCenter.defaultCenter().postNotificationName("refreshOrder", object: nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
