//
//  SupplyCell.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/25.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class SupplyCell: UITableViewCell {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var detailLabel : UILabel!
    
    @IBAction func checkMoreDetail(button:UIButton){
        button.selected = !button.selected
        var height : CGFloat = 66
        if button.selected{
            //zhankai
            guard let text = detailLabel.text  where text != "" else {
                return
            }
            
            let size = text.boundingRectWithSize(CGSizeMake(self.contentView.bounds.width-32, CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFontOfSize(18)], context: nil)
            height = ceil(size.height) + 4
        }
        if let ctl = self.nearestController() as? YuanchenghuizhenController{
            ctl.textHeight = height
            ctl.tableView.beginUpdates()
            ctl.tableView.endUpdates()
        }
        if let ctl = self.nearestController() as? FumeiyiliaoController{
            ctl.textHeight = height
            ctl.tableView.beginUpdates()
            ctl.tableView.endUpdates()
        }
        if let ctl = self.nearestController() as? JingmitijianController{
            ctl.textHeight = height
            ctl.tableView.beginUpdates()
            ctl.tableView.endUpdates()
        }
        if let ctl = self.nearestController() as? JiyinjianceController{
            ctl.textHeight = height
            ctl.tableView.beginUpdates()
            ctl.tableView.endUpdates()
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
