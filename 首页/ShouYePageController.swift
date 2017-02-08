//
//  ShouYePageController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/17.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

let kBannerInfoKey = "kBannerInfoKey"

class ShouYePageController: UIViewController,UITableViewDataSource,UITableViewDelegate, UIWebViewDelegate{

    @IBOutlet var tableView:UITableView!
    var headers = [UITableViewCell]()
    var maladys = [String:AnyObject]()
    var cases = [[String:AnyObject]]()
    var news = [[String:AnyObject]]()
    var hospitals = [[String:AnyObject]]()
    var doctors = [[String:AnyObject]]()
    var aboutInfo = ""
    var contactInfo = ""
    var webHeight : CGFloat = 195
    
    var subTitle = [String]()
    var subDetail = [String]()
    
    var aboutUSCell : UITableViewCell?
    var contactUSCell : UITableViewCell?
    
    @IBAction func showMoreNews(){
        if let ctl = parentViewController as? ViewController{
            ctl.tabBtnTap(ctl.tabBtns[2])
        }
    }
    
    @IBAction func showMoreHospitals(){
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HospitalController") as! HospitalController
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    @IBAction func showMoreDocters(){
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DoctersController") as! DoctersController
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    @IBAction func sickClick(){
        if let ctl = parentViewController as? ViewController{
            ctl.tabBtnTap(ctl.tabBtns[1])
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        parentViewController?.navigationItem.titleView = nil
        let img = UIImageView(frame: CGRectMake(0, 0, 60, 17))
        img.image = UIImage(named: "logo_new")
        parentViewController?.navigationItem.titleView = img
        parentViewController?.navigationItem.leftBarButtonItem = nil
        
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
    
    // MARK: - tableview dalegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 1{
            return cases.count
        }
        if section == 2{
            return news.count
        }
        if section == 4{
            return doctors.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("headCell", forIndexPath: indexPath)
            return cell
        }else if indexPath.section == 1{
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
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath)
            if let image = cell.viewWithTag(1001) as? UIImageView{
                if let url = news[indexPath.row]["thumb"] as? String{
                    image.setImageWithNullableURL(NSURL(string: url), placeholderImage: UIImage(named: "暂无图片"))
                }
            }
            if let name = cell.viewWithTag(1002) as? UILabel{
                if let str = news[indexPath.row]["title"] as? String{
                    name.text = str
                }
            }
            if let des = cell.viewWithTag(1003) as? UILabel{
                if let str = news[indexPath.row]["description"] as? String{
                    des.text = str
                }
            }

            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("hospitalCell", forIndexPath: indexPath) as! hospitalCell
            cell.data = hospitals
            cell.collectionView.reloadData()
            return cell
        }else if indexPath.section == 4{
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
        }else if indexPath.section == 5{
            if let cell = aboutUSCell  {
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("onlineCell", forIndexPath: indexPath)
                if let des = cell.viewWithTag(1009) as? UIWebView{
                    des.loadHTMLString(aboutInfo, baseURL: nil)
                    des.delegate = self
                    des.scrollView.scrollEnabled = false
                }
                aboutUSCell = cell;
                return cell
            }
        }else{
            if let cell = contactUSCell  {
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("onlineCell", forIndexPath: indexPath)
                if let des = cell.viewWithTag(1009) as? UIWebView{
                    des.loadHTMLString(contactInfo, baseURL: nil)
                    des.delegate = self
                    des.scrollView.scrollEnabled = false
                }
                contactUSCell = cell;
                return cell
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 112
        }else if indexPath.section == 1{
            return 94
        }else if indexPath.section == 2{
            return 94
        }else if indexPath.section == 3{
            return 248
        }else if indexPath.section == 4{
            return 105
        }else if indexPath.section == 5 {
            if let cell = aboutUSCell, let webView = cell.viewWithTag(1009) as? UIWebView{
                return webView.scrollView.contentSize.height
            } else {
                return 80
            }
        }else{
            if let cell = contactUSCell, let webView = cell.viewWithTag(1009) as? UIWebView{
                return webView.scrollView.contentSize.height
            } else {
                return 80
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 1{
            guard headers.count > 0 ,let head = headers[0] as? sampleHeaderCell else {
                return 160
            }
            let height = head.collectionView.collectionViewLayout.collectionViewContentSize().height
            if height > 0{
                let heightForHeader = height + 58
                var frame = head.frame
                frame.size.height = heightForHeader
                head.frame = frame
                return heightForHeader
            }
            return 160
        }else if section == 2{
            return 39
        }else if section == 3{
            return 39
        }else if section == 4{
            return 39
        }else if section == 5{
            return 39
        }else if section == 6{
            return 39
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        guard maladys.keys.count > 0 else {
            return nil
        }
        if section == 1{
            
            if headers.count >= section{
                return headers[section - 1].contentView
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("sampleHeader") as! sampleHeaderCell
                    cell.dataSicks = maladys
                    cell.collectionView.reloadData()
                headers.append(cell)
                return cell.contentView
            }
        }else if section == 2{
            if headers.count >= section{
                return headers[section - 1].contentView
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("newsHeader")
                headers.append(cell!)
                return cell?.contentView
            }
        }else if section == 3{
            if headers.count >= section{
                return headers[section - 1].contentView
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("hospitalHeader")
                headers.append(cell!)
                return cell?.contentView
            }
        }else if section == 4{
            if headers.count >= section{
                return headers[section - 1].contentView
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("doctorHeader")
                headers.append(cell!)
                return cell?.contentView
            }
        }else if section == 5{
            let cell = tableView.dequeueReusableCellWithIdentifier("aboutHeader")
            return cell?.contentView
        }else if section == 6{
            let cell = tableView.dequeueReusableCellWithIdentifier("contactHeader")
            return cell?.contentView
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 7
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            ctl.dataDetail = cases[indexPath.row]
            navigationController?.pushViewController(ctl, animated: true)
        }
        if indexPath.section == 2 {
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            ctl.dataDetail = news[indexPath.row]
            navigationController?.pushViewController(ctl, animated: true)
        }
        if indexPath.section == 4{
            let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
            ctl.dataDetail = doctors[indexPath.row]
            navigationController?.pushViewController(ctl, animated: true)
        }
        
    }


    func fetchData(){
        YBToastView.showLoadingToast(inView: self.view, blockSuperView: true)
        SharedNetWorkManager.GET(kShouYeUrlString, parameters: nil, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let data = result["data"] as? [String:AnyObject]{
                if let obj = data["maladys"] as? [String:AnyObject]{
                    self.maladys = obj
                }
                if let objs = data["cases"] as? [AnyObject]{
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.cases.append(dic)
                        }
                    }
                }
                if let objs = data["news"] as? [AnyObject]{
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.news.append(dic)
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
                if let info = data["aboutInfo"] as? String{
                    self.aboutInfo = info
                }
                if let info = data["contactInfo"] as? String{
                    self.contactInfo = info
                }
                if let banners = data["banners"] as? [AnyObject] {
                    NSUserDefaults.standardUserDefaults().setObject(banners, forKey: kBannerInfoKey)
                    for obj in banners{
                        if let banner = obj as? [String:String]{
                            if let thumb = banner["thumb"]{
                                let imageView = UIImageView()
                                if let imageURL = NSURL(string: thumb) {
                                    let request = NSURLRequest(URL: imageURL)
                                    imageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, resp, image) -> Void in
                                        imageView.image = image
                                        if let data = UIImageJPEGRepresentation(image, 1) ,let resp = resp {
                                            let cacheResp = NSCachedURLResponse(response: resp, data:data)
                                            NSURLCache.sharedURLCache().storeCachedResponse(cacheResp, forRequest: request)
                                        }
                                        }, failure: nil)
                                }
                            }
                            if let tit = banner["title"]{
                                self.subTitle.append(tit)
                            }
                            if let tit = banner["desc"]{
                                self.subDetail.append(tit)
                            }
                        }
                    }
                    
                }
            }
            self.tableView.reloadData()
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                print(error)
        }
    }
    var webHeightContact : CGFloat = 0
    func webViewDidFinishLoad(webView: UIWebView) {
        UIView.performWithoutAnimation { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
