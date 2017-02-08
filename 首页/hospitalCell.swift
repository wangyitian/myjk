//
//  hospitalCell.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/17.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class hospitalCell: UITableViewCell  ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    @IBOutlet var collectionView:UICollectionView!
    var data = [[String:AnyObject]]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("hospital", forIndexPath: indexPath)
        if let image = cell.viewWithTag(1008) as? UIImageView{
            if let url = data[indexPath.item]["thumb"] as? String{
            image.setImageWithNullableURL(NSURL(string:url), placeholderImage: UIImage(named: "暂无图片"))
            }
        }
        if let label = cell.viewWithTag(1009) as? UILabel{
            if let name = data[indexPath.item]["title"] as? String{
            label.text = name
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake((self.contentView.frame.width - 32 - 2)/2, 121)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ctl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailController") as! DetailController
        ctl.dataDetail = data[indexPath.item]
        self.nearestController()?.navigationController?.pushViewController(ctl, animated: true)
    }
    
}
