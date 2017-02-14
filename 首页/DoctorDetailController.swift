//
//  DoctorDetailController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class DoctorDetailController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    
    
    var header : UITableViewCell?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "医生"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(DoctorDetailController.back))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            return 1
        }
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("doctorCell", forIndexPath: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("sampleCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 170
        }
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 38
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if let _ = header{
            return header?.contentView
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell")
            header = cell
            return cell?.contentView
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 7
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
