//
//  JingmitijianController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/19.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class JingmitijianController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    var headers = [UITableViewCell]()
    var currentTitle : String?
    var cases = [[String:AnyObject]]()
    var hospitals = [[String:AnyObject]]()
    var doctors = [[String:AnyObject]]()
    
    var textTitle : String?
    var textDetail : String?
    
    @IBAction func appply(){
        guard SharedUserInfo.phoneNumber != "" else {
            SharedUserInfo.showLoginView()
            return
        }
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PayController") as! PayController
        
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tit = currentTitle{
            navigationItem.title = tit
        }
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(JingmitijianController.back))
        let rBtn = UIButton(frame: CGRectMake(0,0,60,20))
        rBtn.setTitle("立即申请", forState: UIControlState.Normal)
        rBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        rBtn.addTarget(self, action: #selector(JingmitijianController.appply), forControlEvents: UIControlEvents.TouchUpInside)
        let rBar = UIBarButtonItem(customView: rBtn)
        navigationItem.rightBarButtonItem = rBar
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
    
    // MARK: - tableview dalegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 6
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 3{
                return cases.count
            }
        if section == 5{
            return doctors.count
        }
            return 1
         }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath)
                let imageView = cell.viewWithTag(123123) as! UIImageView
                if let bannerInfo = NSUserDefaults.standardUserDefaults().objectForKey(kBannerInfoKey) as? [AnyObject]{
                    if bannerInfo.count > 3{
                        if let banner = bannerInfo[2] as? [String:String]{
                            if let url = banner["thumb"]{
                                imageView.setImageWithNullableURL(NSURL(string: url), placeholderImage: nil)
                                
                            }
                        }
                    }
                }
                imageView.superview?.sendSubviewToBack(imageView)
                return cell
            }else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCellWithIdentifier("supplyCell", forIndexPath: indexPath) as! SupplyCell
                if let tit = textTitle{
                    cell.titleLabel.text = tit
                }
                if let des = textDetail{
                    cell.detailLabel.text = des
                }
                return cell
            }else if indexPath.section == 2{
                let cell = tableView.dequeueReusableCellWithIdentifier("introduceCell", forIndexPath: indexPath)
                return cell
            }else if indexPath.section == 3{
                let cell = tableView.dequeueReusableCellWithIdentifier("sampleCell", forIndexPath: indexPath)
                if let image = cell.viewWithTag(1001) as? UIImageView{
                    if let url = cases[indexPath.row]["thumb"] as? String{
                        image.setImageWithNullableURL(NSURL(string: url), placeholderImage: UIImage(named: "暂无图片"))
                    }
                }
                if let name = cell.viewWithTag(1002) as? UILabel{
                    if let str = cases[indexPath.row]["title"] as? String{
                        name.text = str
                    }
                }
                return cell
            }else if indexPath.section == 5{
                let cell = tableView.dequeueReusableCellWithIdentifier("doctorCell", forIndexPath: indexPath)
                if let image = cell.viewWithTag(1001) as? UIImageView{
                    if let url = doctors[indexPath.row]["thumb"] as? String{
                        image.setImageWithNullableURL(NSURL(string: url), placeholderImage: UIImage(named: "暂无图片"))
                    }
                }
                if let name = cell.viewWithTag(1002) as? UILabel{
                    if let str = doctors[indexPath.row]["title"] as? String{
                        name.text = str
                    }
                }
                if let special = doctors[indexPath.row]["specialties"] as? [String:String]{
                    if let des = cell.viewWithTag(1003) as? UILabel{
                        var sick = ""
                        for key in special.keys{
                            sick = sick + " " + special[key]!
                        }
                        des.text = "擅长:" + sick
                    }
                    
                }
                if let des = cell.viewWithTag(1004) as? UILabel{
                    if let str = doctors[indexPath.row]["description"] as? String{
                        des.text = str
                    }
                }
                
                return cell
                
                
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("hospitalCell", forIndexPath: indexPath) as! hospitalCell
                cell.data = hospitals
                cell.collectionView.reloadData()
                return cell
        }

        }
    var textHeight : CGFloat = 66
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.section == 0{
                return 90
            }else if indexPath.section == 1{
               return textHeight + 134
            }else if indexPath.section == 2{
                return 145
            }else if indexPath.section == 3{
                return 94
            }else if indexPath.section == 4{
                var row = 0
                if hospitals.count % 2 == 0{
                    row = hospitals.count / 2
                }else{
                    row = hospitals.count / 2 + 1
                }
                return CGFloat(136 * row)

            }else{
                return 105
            }
        }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
            if section == 3 || section == 4 || section == 5{
                return 38
            }else{
                return 0
            }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 3{
                if headers.count >= 1{
                    return headers[0].contentView
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("sampleHeader")
                    headers.append(cell!)
                    return cell?.contentView
                }
            }else if section == 4{
                if headers.count >= 2{
                    return headers[1].contentView
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("hospitalHeader")
                    headers.append(cell!)
                    return cell?.contentView
                }
            }else if section == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("doctorHeader")
            return cell?.contentView
        }else{
            return nil
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3{
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            ctl.dataDetail = cases[indexPath.row]
            navigationController?.pushViewController(ctl, animated: true)
            
        }
        if indexPath.section == 4{
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            ctl.dataDetail = hospitals[indexPath.row]
            navigationController?.pushViewController(ctl, animated: true)
            
        }
        if indexPath.section == 5{
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            ctl.dataDetail = doctors[indexPath.row]
            navigationController?.pushViewController(ctl, animated: true)
            
        }    }
    
    
    func fetchData(){
        SharedNetWorkManager.GET(kusMeUrlString, parameters: nil, success: { (task, result) -> Void in
            if let result = result as? [String:AnyObject],let data = result["data"] as? [String:AnyObject]{
                if let objs = data["cases"] as? [AnyObject]{
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.cases.append(dic)
                        }
                    }
                }
                if let objs = data["hospitals"] as? [AnyObject]{
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.hospitals.append(dic)
                        }
                    }
                }
                if let objs = data["doctors"] as? [AnyObject]{
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.doctors.append(dic)
                        }
                    }
                }
            }
            self.tableView.reloadData()
            }) { (task, error) -> Void in
                print(error)
        }
    }

}
