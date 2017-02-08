//
//  XieYiController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/4.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class XieYiController: UIViewController {

    @IBOutlet var content : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kagreementUrlString, parameters: nil, success: { (task, result) -> Void in
            YBToastView.hideLoadingToast()
                print(task.originalRequest)
            if let result = result as? [String:AnyObject],let data = result["data"] as? String{
                self.content.text = data
            }
            }) { (task, error) -> Void in
                YBToastView.hideLoadingToast()
                print(task?.originalRequest)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back(){
        navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
