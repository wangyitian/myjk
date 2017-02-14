//
//  InformationsController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class InformationsController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    var data = [[String:AnyObject]]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "消息中心"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(InformationsController.back))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SharedNetWorkManager.GET(kinfosUrlString, parameters: nil, success: { (task, result) -> Void in
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let msg = result["msg"] as? String{
                if msg != ""{
                    YBToastView.showToast(inView: self.view, withText: msg)
                }
                if code == "0"{
                    if let data = result["data"] as? [String:AnyObject],let items = data["items"] as? [AnyObject]{
                        for item in items{
                            if let one = item as? [String:AnyObject]{
                                self.data.append(one)
                            }
                        }
                    }
                }
            }
            if self.data.count > 0{
                self.tableView.reloadData()
            }else{
                YBToastView.showToast(inView: self.view, withText: "暂无消息")
                Delay(1.0, block: { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
            }) { (task, error) -> Void in
                YBToastView.showToast(inView: self.view, withText: "网络错误")
                Delay(1.0, block: { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if data.count < 12 && data.count > 0{
            return 12
        }
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.row >= data.count{
            let cell = tableView.dequeueReusableCellWithIdentifier("lineCell", forIndexPath: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath)
        if let time = cell.viewWithTag(1001) as? UILabel{
            if let str = data[indexPath.row]["created"] as? String{
                time.text = str
            }
        }
        if let info = cell.viewWithTag(1002) as? UILabel{
            if let str = data[indexPath.row]["content"] as? String{
                info.text = str
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 68
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
