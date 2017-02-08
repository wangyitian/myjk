//
//  DetailHeaderCell.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/17.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class DetailHeaderCell: UITableViewCell {

    @IBOutlet var tabBtns:[UIButton]!

    @IBAction func headerBtnTap(sender:UIButton){
        guard let index = tabBtns.indexOf(sender) else {
            return
        }
        guard let nctl = self.nearestController() as? ShouYePageController else {
            return
        }
        guard nctl.subTitle.count > 3 && nctl.subDetail.count > 3 else {
            return
        }
        switch(index){
        case 0:
             let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YuanchenghuizhenController") as! YuanchenghuizhenController
            ctl.currentTitle = "国际会诊"
             ctl.textTitle = nctl.subTitle[0]
             ctl.textDetail = nctl.subDetail[0]
            pushCtl(ctl)
        case 1:
              let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FumeiyiliaoController") as! FumeiyiliaoController
            ctl.currentTitle = "赴美就医"
              ctl.textTitle = nctl.subTitle[1]
              ctl.textDetail = nctl.subDetail[1]
            pushCtl(ctl)
        case 2:
             let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("JingmitijianController") as! JingmitijianController
            ctl.currentTitle = "高端体检"
             ctl.textTitle = nctl.subTitle[2]
             ctl.textDetail = nctl.subDetail[2]
            pushCtl(ctl)
        case 3:
             let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("JiyinjianceController") as! JiyinjianceController
            ctl.currentTitle = "精准医疗"
             ctl.textTitle = nctl.subTitle[3]
             ctl.textDetail = nctl.subDetail[3]
            pushCtl(ctl)
        default:
            break
        }
        
    }

    func pushCtl(ctl:UIViewController){
        if let parent = self.nearestController() as? ShouYePageController{
            parent.navigationController?.pushViewController(ctl, animated: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
