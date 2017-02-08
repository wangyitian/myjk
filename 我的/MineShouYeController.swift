//
//  MineShouYeController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/19.
//  Copyright © 2015年 yb. All rights reserved.

import UIKit

class MineShouYeController: UIViewController ,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView:UITableView!
    
    var headers = [UITableViewCell]()
    
    //var data = [[SharedUserInfo.realname],["远程会诊","赴美就医","高端体检","精准医疗"],["系统消息"],["个人信息","账户安全","退出"]]
    var data = [[SharedUserInfo.realname],["立即申请"],["系统消息"],["个人信息","账户安全","退出"]]
    //let dataHeaders = ["病历管理","服务订单","消息中心","账户管理"]
    let dataHeaders = ["病历管理","帮您康复","消息中心","账户管理"]
    let dataImages = ["病历管理ICON","服务订单ICON","消息中心ICON","账户管理ICON"]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        parentViewController?.navigationItem.titleView = nil
        parentViewController?.navigationItem.title = SharedUserInfo.name
        parentViewController?.navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        data[0][0] = SharedUserInfo.realname
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reNewInfo", name: "quit", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reNewInfo(){
        parentViewController?.navigationItem.titleView = nil
        parentViewController?.navigationItem.title = SharedUserInfo.name
        parentViewController?.navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        data[0][0] = SharedUserInfo.realname
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func back(){
        if let ctl = parentViewController as? ViewController{
            ctl.tabBtnTap(ctl.tabBtns[0])
        }
    }

    // MARK: - tableview dalegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return data.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       return data[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath)
        if let name = cell.viewWithTag(1003) as? UILabel{
            name.text = data[indexPath.section][indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == data[indexPath.section].count - 1{
            return 54
        }
       return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 62
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if headers.count > section{
            return headers[section].contentView
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("headCell")
            
            if let tit = cell!.viewWithTag(1002) as? UILabel{
                tit.text = dataHeaders[section]
            }
            if let image = cell!.viewWithTag(1001) as? UIImageView{
                image.image = UIImage(named: dataImages[section])
            }
            headers.append(cell!)
            return cell?.contentView
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
        guard SharedUserInfo.phoneNumber != "" else {
            SharedUserInfo.showLoginView()
            return
        }
        if indexPath.section == 0{
            let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("BingliController") as! BingliController
            navigationController?.pushViewController(ctl, animated: true)
        }
        if indexPath.section == 3 && indexPath.row == 0{
            let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("MineInfoController") as! MineInfoController
            navigationController?.pushViewController(ctl, animated: true)
        }
        if indexPath.section == 3 && indexPath.row == 1{
            let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("AnquanController") as! AnquanController
            navigationController?.pushViewController(ctl, animated: true)
        }
        if indexPath.section == 3 && indexPath.row == 2{
            let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("QuitController") as! QuitController
            self.parentViewController?.addChildControllerAndView(ctl)
        }
        if indexPath.section == 1{
            /*let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("OrderController") as! OrderController
            ctl.type = indexPath.row + 1
           navigationController?.pushViewController(ctl, animated: true)*/
            let ctl:ApplyViewController = ApplyViewController()
            navigationController?.pushViewController(ctl, animated: true)
        }
        if indexPath.section == 2{
            let ctl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("InformationsController") as! InformationsController
            navigationController?.pushViewController(ctl, animated: true)
        }
    }
}
