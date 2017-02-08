//
//  NewsHeaderCell.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/21.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class NewsHeaderCell: UITableViewCell ,SeMobSlideTabViewDelegate{

    @IBOutlet var sliderView:SeMobSlideTabView! {
        didSet {
            sliderView?.alignType = .AlignFixMargin(left : nil, mid : nil, right : nil)
        }
    }
    
    func slideTabViewDidSelect(index:Int) -> Void{
        var dic = [String:Int]()
        switch(index){
        case 1:
            dic["id"] = 1
        case 2:
            dic["id"] = 3
        case 3:
            dic["id"] = 4
        case 4:
            dic["id"] = 8
        default:
            break
        }
    NSNotificationCenter.defaultCenter().postNotificationName("refreshNews", object: dic)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderView.delegate = self
        sliderView.titles = ["全部","新药","新疗法","行业动态","美域公告"]
        sliderView.titleTextColor = UIColor.blackColor()
        sliderView.slideLineColor = UIColor(red: 80.0/255.0, green: 181.0/255.0, blue: 237.0/255.0, alpha: 1)
        sliderView.slideLineSize = CGSizeMake(25, 2)
        sliderView.slideLineBottom = 0
        sliderView.titleFont = UIFont.systemFontOfSize(14)
        sliderView.selectedIndex = 0
        sliderView.useAutoLayout()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
