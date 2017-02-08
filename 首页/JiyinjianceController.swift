//
//  JiyinjianceController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/19.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class JiyinjianceController: UIViewController  ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    var currentTitle : String?
    
    var textTitle : String?
    var textDetail : String?
    
    var contents = [[String:String]]()
    
    @IBAction func apply(){
        guard SharedUserInfo.phoneNumber != "" else {
            SharedUserInfo.showLoginView()
            return
        }
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("KnowMoreController") as! KnowMoreController
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tit = currentTitle{
            navigationItem.title = tit
        }
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        let rBtn = UIButton(frame: CGRectMake(0,0,60,20))
        rBtn.setTitle("立即申请", forState: UIControlState.Normal)
        rBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        rBtn.addTarget(self, action: "apply", forControlEvents: UIControlEvents.TouchUpInside)
        let rBar = UIBarButtonItem(customView: rBtn)
        navigationItem.rightBarButtonItem = rBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SharedNetWorkManager.GET(jingzhunyiliaoInfoUrlString, parameters: nil, success: { (task, result) -> Void in
            guard let result = result as? [String:AnyObject], code = result["code"] as? String else {
                YBToastView.showToast(inView: self.view, withText: "网络错误")
                return
            }
            guard code == "0" else {
                YBToastView.showToast(inView: self.view, withText: result["msg"] as? String ?? "网络错误")
                return
            }
            guard let data = result["data"] as? [[String:String]] else {
                YBToastView.showToast(inView: self.view, withText: "网络错误")
                return
            }
            self.contents = data
            self.tableView.reloadData()
            }) { (task, error) -> Void in
                YBToastView.showToast(inView: self.view, withText: "网络错误")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - tableview dalegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 2 {
            return contents.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath)
            let imageView = cell.viewWithTag(123123) as! UIImageView
            if let bannerInfo = NSUserDefaults.standardUserDefaults().objectForKey(kBannerInfoKey) as? [AnyObject]{
                if bannerInfo.count > 3{
                    if let banner = bannerInfo[3] as? [String:String]{
                        if let url = banner["thumb"]{
                            imageView.setImageWithNullableURL(NSURL(string: url), placeholderImage: nil)
                            
                        }
                    }
                }
            }
            imageView.superview?.sendSubviewToBack(imageView)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCellWithIdentifier("titleCell", forIndexPath: indexPath) as! SupplyCell
            if let tit = textTitle{
                cell.titleLabel.text = tit
            }
            if let des = textDetail{
                cell.detailLabel.text = des
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("supplyCell", forIndexPath: indexPath)
            let titleLabel = cell.viewWithTag(1000) as? UILabel
            let contentLabel = cell.viewWithTag(1001) as? UILabel
            guard indexPath.row < contents.count else {
                return cell
            }
            let oneInfo = contents[indexPath.row]
            titleLabel?.text = oneInfo["title"]
            contentLabel?.text = oneInfo["desc"]
            return cell
        }
    }
    var textHeight : CGFloat = 66
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 88
        }else if indexPath.section == 1{
            return textHeight + 134
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 88
        }else if indexPath.section == 1{
            return textHeight + 134
        }else {
            return 420
        }
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == 0{
            return 0
        }
        return 7
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clearColor()
        return view
    }

}
