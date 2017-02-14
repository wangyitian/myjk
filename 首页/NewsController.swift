//
//  SamplesController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class NewsController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var tableView:UITableView!
    var dataNews = [[String:AnyObject]]()
    var maladyId : Int?
    var header : UITableViewCell?
    var refreshView : RefreshView?
    
    func refreshNews(notification:NSNotification){
        if let ids = notification.object as? [String:Int]{
            if let id = ids["id"]{
                maladyId = id
            }else{
                maladyId = nil
            }
        }
        refreshFlag = true
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        currentPage = 1
        finish = false
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if refreshView == nil {
            refreshView =  RefreshView(frame: CGRectMake(tableView.frame.width/2-25,-50,50,50))
            refreshView!.addtoScrollView(self.tableView)
            refreshView!.addTarget(self, action: #selector(NewsController.refreshAction))
           
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        parentViewController?.navigationItem.titleView = nil
        parentViewController?.navigationItem.title = "新 闻"
        parentViewController?.navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(NewsController.back))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewsController.refreshNews(_:)), name: "refreshNews", object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var refreshFlag = false
    func refreshAction(){
        refreshView?.lastRefreshDate = NSDate()
        refreshFlag = true
        currentPage = 1
        finish = false
        fetchData()
    }
    
    func back(){
        if let ctl = parentViewController as? ViewController{
            ctl.tabBtnTap(ctl.tabBtns[0])
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dataNews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath)
        if let image = cell.viewWithTag(1001) as? UIImageView{
            if let url = dataNews[indexPath.row]["thumb"] as? String{
                image.setImageWithNullableURL(NSURL(string: url), placeholderImage: UIImage(named: "暂无图片"))
            }
        }
        if let name = cell.viewWithTag(1002) as? UILabel{
            if let str = dataNews[indexPath.row]["title"] as? String{
                name.text = str
            }
        }
        if let des = cell.viewWithTag(1003) as? UILabel{
            if let str = dataNews[indexPath.row]["description"] as? String{
                des.text = str
            }
        }
        
        return cell    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 38
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if let _ = header{
            return header?.contentView
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("newsHeader") as! NewsHeaderCell
            header = cell
            return cell.contentView
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if finish{
            return
        }
        if indexPath.row == dataNews.count - 2{
            fetchData()
        }
    }
    
       
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
        ctl.dataDetail = dataNews[indexPath.row]
        navigationController?.pushViewController(ctl, animated: true)
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
        dic["page"] = currentPage
        if let id = maladyId{
            dic["modelid"] = id
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kNewsUrlString, parameters: dic, success: { (task, result) -> Void in
            print(task.originalRequest)
            YBToastView.hideLoadingToast()
            if self.refreshFlag{
                self.dataNews.removeAll()
                self.refreshFlag = false
            }
            guard let result = result as? [String:AnyObject],let data = result["data"] as? [String:AnyObject] else{
                return
            }
            
            guard let objs = data["items"] as? [AnyObject] else{
                    return
            }
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.dataNews.append(dic)
                        }
                    }
            
            if !self.finish{
               
                self.tableView.reloadData()
                if let refresh = self.refreshView{
                    refresh.endReFresh()
                }
                self.currentPage+=1
            }
            if objs.count < 10{
                self.finish = true
               
            }
            
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                if let refresh = self.refreshView{
                    refresh.endReFresh()
                }
                print(error)
        }
    }
}
