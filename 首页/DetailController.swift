//
//  DetailController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/26.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    var dataDetail : [String:AnyObject]?
    @IBOutlet var webView:UIWebView!
    var currentUrl :String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let data = dataDetail else {
            return
        }
        guard let tit = data["title"] as? String else {
            return
        }
        navigationItem.title = tit
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(DetailController.back))
        let rBtn = UIButton()
        rBtn.frame = CGRectMake(0, 0, 18, 20)
        //rBtn.sizeToFit()
        rBtn.setBackgroundImage(UIImage(named: "share"), forState: .Normal)
            //setImage(UIImage(named: "share"), forState: .Normal)
        rBtn.addTarget(self, action: #selector(DetailController.share), forControlEvents: UIControlEvents.TouchUpInside)
        let rView = UIBarButtonItem(customView: rBtn)
        navigationItem.rightBarButtonItem = rView
    }
    
    
    
    func share(){
        guard let data = dataDetail else {
            return
        }
        guard let tit = data["title"] as? String else {
            return
        }
        guard let url = currentUrl else {
            return
        }
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShareController") as! ShareController
        ctl.shareTitle = tit
        ctl.shareUrl = url
        if let photoUrl = data["thumb"] as? String{
            ctl.photoUrl = photoUrl
        }
        self.addChildControllerAndView(ctl)
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

    

    func fetchData(){
        guard let data = dataDetail else {
            return
        }
        guard let mid = data["modelid"] else {
            return
        }
        guard let id = data["id"] else {
            return
        }
        let urlString = kNetBaseString + kdetailUrlString + "?id=\(id)&modelid=\(mid)"
        if let url =  NSURL(string: urlString){
            currentUrl = urlString
            webView.loadRequest(NSURLRequest(URL:url))
        }
        
    }

}

extension DetailController : UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let url = request.URL, compoments = NSURLComponents(string: url.absoluteString!) else {
            return false
        }
        if let host = compoments.host where compoments.scheme == "meiyuyiliao" {
            switch host {
            case "shili":
                let viewCtl = (AppRootController as! UINavigationController).viewControllers[0] as! ViewController
                viewCtl.tabBtns[1].sendActionsForControlEvents(.TouchUpInside)
                let sampleCtl = viewCtl.controllers[1] as! SamplesController
                if let querys = compoments.queryItems {
                    let id = querys[0]
                    if id.name == "id" {
                        sampleCtl.sickId = id.value
                    }
                }
                sampleCtl.refreshCases(nil)
                navigationController?.popToRootViewControllerAnimated(true)
                return false
            case "hospital":
                let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HospitalController") as! HospitalController
                navigationController?.pushViewController(ctl, animated: true)
                return false
            case "doctor":
                let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DoctersController") as! DoctersController
                navigationController?.pushViewController(ctl, animated: true)
                return false
            case "news":
                let viewCtl = (AppRootController as! UINavigationController).viewControllers[0] as! ViewController
                viewCtl.tabBtns[2].sendActionsForControlEvents(.TouchUpInside)
                let newsCtl = viewCtl.controllers[2] as! NewsController
                if let querys = compoments.queryItems {
                    let id = querys[0]
                    if id.name == "id" {
                        if let vId = id.value{
                            newsCtl.maladyId = Int(vId)
                        }
                        
                    }
                }
                newsCtl.refreshAction()
                navigationController?.popToRootViewControllerAnimated(true)
                return false
            default:
                return true
            }
        }
        return true
    }
}
