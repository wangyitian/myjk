//
//  OrderController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class OrderController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    var type : Int?
    var data = [[String:AnyObject]]()
    var order = [String:AnyObject]()
    var header : UITableViewCell?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "服务订单"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshOrder", name: "refreshOrder", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
    }

  
    
    @IBAction func toPay(){
        guard let id = type else {
            return
        }
        if id == 4{
            YBToastView.showToast(inView: view, withText: "请联系客服")
            return
        }
        guard let name = nameHeader["product"] as? String else {
            return
        }
        guard let price = order["order_amount"] as? String else {
            return
        }
        guard let snd = order["order_sn"] as? String else {
            return
        }
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RePayController") as! RePayController
        ctl.pro_name = name
        ctl.price = price
        ctl.orderNum = snd
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    @IBAction func showDetail(){
        
    }
    
    func refreshOrder(){
        data.removeAll()
        order.removeAll()
        fetchData()
    }
    
    //MARK:-TABLEVIEW DELEGATE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return 1
        }
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("nameCell", forIndexPath: indexPath)
            if let name = cell.viewWithTag(1000) as? UILabel{
                if let nn = nameHeader["realname"] as? String{
                    name.text = nn
                }
            }
            if let pro = cell.viewWithTag(1001) as? UILabel{
                if let stt = nameHeader["type"] as? String{
                    pro.text = stt
                }
                
            }
            if let pro = cell.viewWithTag(1002) as? UILabel{
                if let str = nameHeader["product"] as? String{
                    pro.text = str
                }
                
            }

            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! TableCell
            let dataString = data[indexPath.row]["log_date"] as! String
            cell.log_date.text = "\n"+dataString+"\n"
            /*if  let medical_name = data[indexPath.row]["medical_name"] as? String{
                cell.medical_name.setTitle(medical_name, forState: .Normal)
                if  let medical_status = data[indexPath.row]["medical_status"] as? String{
                    switch(medical_status){
                    case "0":
                        cell.medical_name.enabled = true
                    case "1":
                        cell.medical_name.enabled = false
                    default:break
                    }
                }
            }*/
            
            if  let pay_name = data[indexPath.row]["pay_name"] as? String{
                cell.pay_name.setTitle(pay_name, forState: .Normal)
                if  let pay_status = data[indexPath.row]["pay_status"] as? String{
                    switch(pay_status){
                    case "0":
                        cell.pay_name.enabled = true//未支付
                        cell.pay_name.setTitle("去支付", forState: .Normal)
                    case "1":
                        cell.pay_name.enabled = false
                    default:break
                    }
                }
            }
            if let pri = order["order_amount"] as? String{
                if let priInt = Double(pri){
                    if priInt == 0.00{
                        cell.pay_name.enabled = false//未支付
                        cell.pay_name.setTitle("价格未定", forState: .Normal)
                    }
                }
            }
            cell.order_name.enabled = false
            if  let note = data[indexPath.row]["action_note"] as? String{
                let reporgRange = ("\n"+note+"\n" as NSString).rangeOfString("查看会诊报告")
                if reporgRange.location != NSNotFound {
                    cell.reportEnURL = (order["report_en"] as? String) ?? ""
                    cell.reportZhURL = (order["report_zh"] as? String) ?? ""
                    let attributeTitle = NSMutableAttributedString(string: "\n"+note+"\n")
                    attributeTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0,note.characters.count))
                    if cell.reportEnURL != "" || cell.reportZhURL != "" {
                        //有数据
                        attributeTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "51B5EC"), range: reporgRange)
                        cell.order_name.enabled = true
                    }
                    cell.order_name_label.attributedText = attributeTitle
                } else {
                    let range = ("\n"+note+"\n" as NSString).rangeOfString("预约确认函")
                    if (range.location != NSNotFound){
                        cell.bookingURL = (order["booking_url"] as? String) ?? ""
                        let attributeTitle = NSMutableAttributedString(string: "\n"+note+"\n")
                        attributeTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0,note.characters.count))
                        if cell.bookingURL != "" {
                            //有数据
                            attributeTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "51B5EC"), range: range)
                            cell.order_name.enabled = true
                        }
                        cell.order_name_label.attributedText = attributeTitle
                    } else {
                        let attributeTitle = NSMutableAttributedString(string: "\n"+note+"\n")
                        attributeTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0,note.characters.count))
                        cell.order_name_label.attributedText = attributeTitle
                    }
                }
            }
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 113
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 113
        }
        return 45
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0 {
            return 0
        }
        if data.count > 0{
            return 37
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        guard data.count > 0 else {
            return nil
        }
        if let _ = header{
            return header?.contentView
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
            
            header = cell
            return cell?.contentView
        }
    }
    var nameHeader = [String:AnyObject]()
    func fetchData(){
        guard let id = type else {
            return
        }
        
        SharedNetWorkManager.GET(kordersUrlString, parameters: ["type":id], success: { (task, result) -> Void in
            print(result)
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String{
                if msg != ""{
                    
                    YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "401"{
                    SharedUserInfo.clearUserInfo()
                    SharedUserInfo.showLoginView()
                    return
                }
                if code == "0",let data = result["data"] as? [String:AnyObject],let actions = data["actions"] as? [AnyObject],let header = data["header"] as? [String:AnyObject],let order = data["order"] as? [String:AnyObject]{
                    for obj in actions{
                        if let one = obj as? [String:AnyObject]{
                            self.data.append(one)
                        }
                    }
                    self.order = order
                    self.nameHeader = header
                    self.tableView.reloadData()
                }else{
                    Delay(1.0, block: { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    
                }
            }
            }) { (task, error) -> Void in
                
        }
        
    }


}
