//
//  MineInfoController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/19.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class MineInfoController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    
    @IBOutlet var tableView:UITableView!
    var dataName = ["姓名","手机号","病症","邮箱","出生日期","性别","住址","邮编"]
    var data = [String:String]()
    var dataSicks = [[String:AnyObject]]()
    var dataCitys = [[String:AnyObject]]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "个人信息"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(MineInfoController.back))
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data["姓名"] = SharedUserInfo.name
        data["手机号"] = SharedUserInfo.mymobile
        data["病症"] = SharedUserInfo.sickName
        data["邮箱"] = SharedUserInfo.myemail
        data["出生日期"] = SharedUserInfo.birthday
        data["性别"] = SharedUserInfo.sex
        data["住址"] = SharedUserInfo.city + " " + SharedUserInfo.address
        data["邮编"] = SharedUserInfo.postcode
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return dataName.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
            if let name = cell.viewWithTag(1110) as? UILabel{
                name.text = dataName[indexPath.row]
            }
            if let detail = cell.viewWithTag(1111) as? UILabel{
                if let text = data[dataName[indexPath.row]]{
                    detail.text = text
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("footCell", forIndexPath: indexPath)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
   
        return 0
    }
    
    
    func fetUserInfo(){
        SharedNetWorkManager.GET(kuserInfoUrlString, parameters: nil, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
            if let result = result as? [String:AnyObject],let code = result["code"] as? String,let data = result["data"] as? [String:AnyObject]{
                if code == "401"{
                    SharedUserInfo.clearUserInfo()
                    SharedUserInfo.showLoginView()
                    return
                }
                if code == "0"{
                    self.data.removeAll()
                    if let nicknameinfo = data["nickname"] as? String{
                        self.data["姓名"] = nicknameinfo
                        SharedUserInfo.name = nicknameinfo
                    }
                    if let mymobileinfo = data["mymobile"] as? String{
                        self.data["手机号"] = mymobileinfo
                        SharedUserInfo.mymobile = mymobileinfo
                    }
                    if let maladyidinfo = data["maladyid"]{
                        self.data["病症"] = ""
                        SharedUserInfo.maladyid <-- maladyidinfo
                        for sick in self.dataSicks{
                            if let id = sick["linkageid"] as? String{
                               if id == "\(SharedUserInfo.maladyid)"{
                                if let parentId = sick["parentid"] as? String where parentId != "0"{
                                    for praSick in self.dataSicks{
                                        if parentId == praSick["linkageid"] as! String{
                                            let str = praSick["name"] as! String!
                                            let sst = sick["name"] as! String
                                            self.data["病症"] = str + " " + sst
                                            SharedUserInfo.sickName = str + " " + sst
                                            break
                                        }
                                    }
                                }else{
                                    self.data["病症"] = sick["name"] as? String
                                    SharedUserInfo.sickName = sick["name"] as! String
                                    
                                }
                                break
                                }
                            }
                        }
                        
                    }
                    if let myemailinfo = data["myemail"] as? String{
                        self.data["邮箱"] = myemailinfo
                        SharedUserInfo.myemail = myemailinfo
                    }
                    if let birthdayinfo = data["birthday"] as? String{
                        self.data["出生日期"] = birthdayinfo
                        SharedUserInfo.birthday = birthdayinfo
                    }
                    if let genderinfo = data["gender"] as? String{
                        self.data["性别"] = genderinfo
                        SharedUserInfo.sex = genderinfo
                    }
                    
                    if let areaidinfo = data["areaid"]{
                        
                        SharedUserInfo.areaid <-- areaidinfo
                        for city in self.dataCitys{
                            if let id = city["linkageid"] as? String{
                                if id == "\(SharedUserInfo.areaid)"{
                                    if let parentId = city["parentid"] as? String where parentId != "0"{
                                        for praCity in self.dataCitys{
                                            if parentId == praCity["linkageid"] as! String{
                                                let str = praCity["name"] as! String!
                                                let sst = city["name"] as! String
                                                self.data["住址"] = str + " " + sst
                                                SharedUserInfo.city = str + " " + sst
                                                break
                                            }
                                        }
                                    }else{
                                        self.data["住址"] = city["name"] as? String
                                        SharedUserInfo.city = city["name"] as! String
                                        
                                    }
                                    break
                                }
                            }
                        }
                        
                    }
                    if let addressinfo = data["address"] as? String{
                        if let add = self.data["住址"]{
                            self.data["住址"] = add + " " + addressinfo
                        }else{
                            self.data["住址"] = addressinfo
                        }
                        
                        SharedUserInfo.address = addressinfo
                    }
                    if let postcodeinfo = data["postcode"] as? String{
                        self.data["邮编"] = postcodeinfo
                        SharedUserInfo.postcode = postcodeinfo
                    }
                    if let useridinfo = data["userid"] as? String{
                        SharedUserInfo.userId = useridinfo
                    }
                    SharedUserInfo.synchronize()
                    self.tableView.reloadData()
                }
            }
            }) { (task, error) -> Void in
              YBToastView.hideLoadingToast()
        }
    }

    
    func fetchData(){
        SharedNetWorkManager.GET(kcityAndSickUrlString, parameters: ["keyid":3362], success: { (task, result) -> Void in
            print(task.originalRequest)
            if let result = result as? [String:AnyObject],let data = result["data"] as? [AnyObject]{
                for obj in data{
                    if let sick  = obj as? [String:AnyObject]{
                        self.dataSicks.append(sick)
                        
                    }
                }
            }
            self.fetchCityDate()
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
        }
        
        
        
        
    }

    func fetchCityDate(){
        SharedNetWorkManager.GET(kcityAndSickUrlString, parameters: ["keyid":1], success: { (task, result) -> Void in
            print(task.originalRequest)
            if let result = result as? [String:AnyObject],let data = result["data"] as? [AnyObject]{
                for obj in data{
                    if let sick  = obj as? [String:AnyObject]{
                        self.dataCitys.append(sick)
                        
                    }
                }
            }
            self.fetUserInfo()
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
        }
    }

}
