//
//  TableCell.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/15.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet var log_date : UILabel!
    
    @IBOutlet var order_name : UIButton!
    @IBOutlet var order_name_label : UILabel!
    @IBOutlet var pay_name : UIButton!
    
    var reportEnURL : String = ""
    var reportZhURL : String = ""
    var bookingURL : String = ""
    
    @IBAction func lastBtnAction() {
        if reportEnURL != "" || reportZhURL != "" {
            let reportCtl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("ReportController") as! ReportController
            reportCtl.reportEnURL = reportEnURL
            reportCtl.reportZhURL = reportZhURL
            nearestController()?.navigationController?.pushViewController(reportCtl, animated: true)
        } else if bookingURL != "" {
            let bookingCtl = UIStoryboard(name: "Mine", bundle: nil).instantiateViewControllerWithIdentifier("ConfirmMailController") as! ConfirmMailController
            bookingCtl.bookingURL = bookingURL
            nearestController()?.navigationController?.pushViewController(bookingCtl, animated: true)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reportEnURL = ""
        reportZhURL = ""
        bookingURL = ""
        order_name.enabled = false
    }

}
