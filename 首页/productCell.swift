//
//  productCell.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/12.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class productCell: UITableViewCell {

    @IBOutlet var name:UILabel!
    @IBOutlet var detail:UILabel!
    @IBOutlet var price :UILabel!
    @IBOutlet var checkBtn:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
