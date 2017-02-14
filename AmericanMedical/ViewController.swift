//
//  ViewController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/16.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let controllers : [UIViewController] = {
        let ctl0 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShouYePageController")
        let ctl1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SamplesController")
        let ctl2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewsController")
        let ctl3 = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("MineShouYeController")
        return [ctl0,ctl1,ctl2,ctl3]
        
        
    }()
    
    @IBOutlet var tabBtns : [UIButton]!
    @IBOutlet var tabView : UIView!
    
    @IBAction func tabBtnTap (sender : UIButton) {
        guard let index = tabBtns.indexOf(sender) else {
            return
        }
        
        for i in 0  ..< tabBtns.count {
            
            if i != index {
                tabBtns[i].selected = false
                
            }else{
              tabBtns[i].selected = true
            }
        }
        let ctl = controllers[index]
        ctl.view.useAutoLayout()
        for childCtl in childViewControllers {
            childCtl.removeControllerAndViewFromParent()
        }
        self.addChildControllerAndView(ctl)
        NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":ctl.view]).autolayoutInstall()
        NSLayoutConstraint.constraintsWithVisualFormat("V:[topGuide]-0-[view]-0-[tab]", options: [], metrics: nil, views: ["topGuide":self.topLayoutGuide,"view":ctl.view, "tab":tabView]).autolayoutInstall()
        view.bringSubviewToFront(tabView)
        
        if index == 3{
            guard SharedUserInfo.phoneNumber != "" else {
                SharedUserInfo.showLoginView()
                return
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBtnTap(tabBtns[0])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

