//
//  AnquanController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/19.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class AnquanController: UIViewController {

    @IBOutlet var selectBtn:UIButton!
    
    @IBAction func modifyPassword(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "账户安全"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
        selectBtn.selected = true
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
