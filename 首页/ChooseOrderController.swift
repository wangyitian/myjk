//
//  ChooseOrderController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class ChooseOrderController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    var productName : String?
    var header : UITableViewCell?
    var type : Int?
    var tijian_type : Int?
    var dataProducts = [[String:AnyObject]]()
    
    
    @IBAction func nextStep(){
        guard SharedUserInfo.phoneNumber != "" else {
            SharedUserInfo.showLoginView()
            return
        }
        if self.type == 2{//zaiPay提交订单
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YuanchengPayController") as! YuanchengPayController
            ctl.type = 2
            if let name = productName{
                ctl.productName = name
                if let subName = dataProducts[selectedRow]["name"] as? String{
                    ctl.productName += "-" + subName
                }
            }
            if let price = dataProducts[selectedRow]["price"] as? String{
                ctl.price = price
            }
            if let id = dataProducts[selectedRow]["product_id"] as? String{
                ctl.productId = id
            }
            self.navigationController?.pushViewController(ctl, animated: true)
        }
        if self.type == 3{//体检再pay的页面提交订单了
            guard let tijiantype = self.tijian_type else {
                return
            }
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PayController") as! PayController
            
            ctl.selectProduct = tijiantype
            ctl.selectSub = self.selectedRow
            self.navigationController?.pushViewController(ctl, animated: true)
        }
    }
    
    @IBAction func showHeTong(sender:UIButton){
        guard let tii = type else {
            return
        }
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HeTongController") as! HeTongController
        ctl.typeNum = tii
        if let name = sender.titleForState(.Normal){
            ctl.titleName = name
        }
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "选择套餐"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(ChooseOrderController.back))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return dataProducts.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! productCell
                cell.name.text = dataProducts[indexPath.row]["name"] as? String
            let str = dataProducts[indexPath.row]["price"] as! String
            if str != "0" {
                cell.price.text = "价格￥" + str
            } else {
                cell.price.text = "价格：待商谈"
            }
            cell.detail.text = dataProducts[indexPath.row]["description"] as? String
            if indexPath.row == selectedRow{
                cell.checkBtn.selected = true
            }else{
                cell.checkBtn.selected = false
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("footCell", forIndexPath: indexPath)
            if let hetBtn = cell.viewWithTag(8880) as? UIButton{
                if let name = productName{
                    hetBtn.setTitle(name + "合同", forState: UIControlState.Normal)
                }
                if type == 3{
                    hetBtn.setTitle("高端体检合同", forState: UIControlState.Normal)
                }
            }
            if let checkBtn = cell.viewWithTag(8881) as? UIButton{
                checkBtn.selected = true
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 125
        }
        return 97
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0{
            return 45
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 0{
            if let _ = header{
                if let name = productName{
                    if let tit = header?.viewWithTag(1119) as? UILabel{
                        tit.text = name
                    }
                }
                return header?.contentView
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
                header = cell
                if let name = productName{
                    if let tit = header?.viewWithTag(1119) as? UILabel{
                        tit.text = name
                    }
                }
                return cell?.contentView
            }

        }else{
            return nil
        }
    }
    var selectedRow  = 0
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let oldCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedRow, inSection: 0)) as? productCell{
            oldCell.checkBtn.selected = false
        }
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? productCell{
            cell.checkBtn.selected = true
            selectedRow = indexPath.row
        }
        
    }
    
    func fetchData(){
        guard let id = type else {
            return
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kproductListUrlString, parameters: ["type":id], success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String,let data = result["data"] as? [AnyObject]{
                if msg != ""{
                    
                YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "0"{
                    for obj in data{
                        if let one = obj as? [String:AnyObject]{
                            self.dataProducts.append(one)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
        }

    }
    
    func fetchOrder(){//赴美 无需支付，只提交
        guard let tii = type else {
            return
        }
        guard let id = dataProducts[selectedRow]["product_id"] as? String else {
            return
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kbuyUrlString, parameters: ["type":tii,"product_id":id], success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String{
                if msg != ""{
                    
                    YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "401"{
                    SharedUserInfo.showLoginView()
                    return
                }
                if code == "0"{
                    let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FuMeiAlertController") as! FuMeiAlertController
                    self.addChildControllerAndView(ctl)
                }
            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                YBToastView.showToast(inView: self.view, withText: "网络错误")
        }
        
    }

}
