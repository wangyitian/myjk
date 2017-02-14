//
//  ReportController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class ReportController: UIViewController{

    
    var reportEnURL = ""
    var reportZhURL = ""
    @IBOutlet var ChinesewebView : UIWebView!
     @IBOutlet var EnglishwebView : UIWebView!
    @IBOutlet var buttons : [UIButton]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "诊疗报告"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: #selector(ReportController.back))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        buttons[0].backgroundColor = UIColor(hexString: "f0f0f0")
        ChinesewebView.loadRequest(NSURLRequest(URL: NSURL(string: reportZhURL)!))
        EnglishwebView.loadRequest(NSURLRequest(URL: NSURL(string: reportEnURL)!))
        EnglishwebView.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func slideTabViewDidSelect(button:UIButton){
        guard let index = buttons.indexOf(button) else {
            return
        }
        if index == 0{
            buttons[0].backgroundColor = UIColor(hexString: "f0f0f0")
            buttons[1].backgroundColor = UIColor.whiteColor()
            ChinesewebView.hidden = false
            EnglishwebView.hidden = true
        }else{
            buttons[1].backgroundColor = UIColor(hexString: "f0f0f0")
            buttons[0].backgroundColor = UIColor.whiteColor()
            ChinesewebView.hidden = true
            EnglishwebView.hidden = false
        }
    }
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
    }

    
}
