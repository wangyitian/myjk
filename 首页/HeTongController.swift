//
//  HeTongController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/12.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class HeTongController: UIViewController {

    @IBOutlet var content : UILabel!
    var typeNum : Int?
    var titleName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = titleName{
            navigationItem.title = name
        }
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        guard let type = typeNum else {
            return
        }
        YBToastView.showLoadingToast(inView: view, blockSuperView: true)
        SharedNetWorkManager.GET(kxieyiUrlString, parameters: ["type":type], success: { (task, result) -> Void in
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
    

}
