//
//  SamplesController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class SamplesController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView:UITableView!
    var header : UITableViewCell?
    var dataCases = [[String:AnyObject]]()
    var dataSicks = [String:AnyObject]()
    var sickId : String?
    
    func refreshCases(notification:NSNotification?){
        if let ids = notification?.object as? [String:String]{
            if let id = ids["id"]{
                sickId = id
            }
        }
        dataCases.removeAll()
        currentPage = 1
        finish = false
        fetchData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        parentViewController?.navigationItem.titleView = nil
        parentViewController?.navigationItem.title = "实 例"
        parentViewController?.navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshCases:", name: "refreshCases", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        if let ctl = parentViewController as? ViewController{
            ctl.tabBtnTap(ctl.tabBtns[0])
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dataCases.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("sampleCell", forIndexPath: indexPath)
        if let image = cell.viewWithTag(1001) as? UIImageView{
            if let url = dataCases[indexPath.row]["thumb"] as? String{
                image.setImageWithNullableURL(NSURL(string: url), placeholderImage: UIImage(named: "暂无图片"))
            }
        }
        if let name = cell.viewWithTag(1002) as? UILabel{
            if let str = dataCases[indexPath.row]["title"] as? String{
                name.text = str
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
//        guard let head = header as? sampleHeaderCell else {
//            return 108
//        }
//        let height = head.collectionView.collectionViewLayout.collectionViewContentSize().height
//        if height > 0{
//            return height + 23
//        }
//        return 108
        return 23
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
//        guard dataSicks.keys.count > 0 else {
//            return nil
//        }
//        if let _ = header{
//            return header?.contentView
//        }else{
//            let cell = tableView.dequeueReusableCellWithIdentifier("sampleHeader") as! sampleHeaderCell
//            cell.dataSicks = dataSicks
//            cell.collectionView.reloadData()
//            header = cell
//            return cell.contentView
//        }
//    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
        ctl.dataDetail = dataCases[indexPath.row]
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if finish{
            return
        }
        if indexPath.row == dataCases.count - 2{
            fetchData()
        }
    }
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var currentPage = 1
    var finish = false
    func fetchData(){
        var dic = [String:AnyObject]()
        dic["page"]  = currentPage
        if let id = sickId{
            dic["maladyId"] = id
        }
        
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kSampleUrlString, parameters: dic, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            guard let result = result as? [String:AnyObject],let data = result["data"] as? [String:AnyObject] else {
                return
            }
                if let obj = data["maladys"] as? [String:AnyObject]{
                    self.dataSicks = obj
                }
                guard let objs = data["items"] as? [AnyObject] else{
                    return
            }
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.dataCases.append(dic)
                        }
                    }
            
            
            
            
            if !self.finish{
                self.tableView.reloadData()
                self.currentPage++
            }
            if objs.count < 10{
                self.finish = true
                
            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                print(error)
        }
    }
}
