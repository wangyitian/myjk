//
//  DoctersController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/7.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class DoctersController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var tableView:UITableView!
    var data = [[String:AnyObject]]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "医 生"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(DoctersController.back))
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("doctorCell", forIndexPath: indexPath)
        if let image = cell.viewWithTag(1001) as? UIImageView{
            if let url = data[indexPath.row]["thumb"] as? String{
                image.setImageWithNullableURL(NSURL(string:url), placeholderImage: UIImage(named: "暂无图片"))
            }
        }
        if let name = cell.viewWithTag(1002) as? UILabel{
            if let str = data[indexPath.row]["title"] as? String{
                name.text = str
            }
        }
        if let des = cell.viewWithTag(1003) as? UILabel{
            if let str = data[indexPath.row]["description"] as? String{
                des.text = str
            }
        }
        if let spe = cell.viewWithTag(1004) as? UILabel{
            if let str = data[indexPath.row]["specialties"] as? String{
                spe.text = "擅长:" + str
            }
        }
        return cell    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if finish{
            return
        }
        if indexPath.row == data.count - 2{
            fetchData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
        ctl.dataDetail = data[indexPath.row]
    
        navigationController?.pushViewController(ctl, animated: true)
    }
    
    //network
    var currentPage = 1
    var finish = false
    func fetchData(){
        SharedNetWorkManager.GET(kdoctersUrlString, parameters: ["page":currentPage], success: { (task, result) -> Void in
            if self.finish{
                return
            }
            guard let result = result as? [String:AnyObject],let data = result["data"] as? [String:AnyObject] else{
                return
            }
                if let objs = data["items"] as? [AnyObject]{
                    for obj in objs{
                        if let dic = obj as? [String:AnyObject]{
                            self.data.append(dic)
                        }
                    }
                    if objs.count < 10{
                        self.finish = true
                    }
                }
            self.tableView.reloadData()
            self.currentPage++
            
            }) { (task, error) -> Void in
                print(error)
        }
    }
    
}
