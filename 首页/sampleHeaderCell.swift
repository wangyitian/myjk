//
//  sampleHeaderCell.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/17.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit

class sampleHeaderCell: UITableViewCell ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LeftAlignCollectionViewLayoutDelegate{

    @IBOutlet var collectionView:UICollectionView!
    var dataSicks = [String:AnyObject]()
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
         return dataSicks.keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("typeCell", forIndexPath: indexPath)
        if let label = cell.viewWithTag(1009) as? UILabel{
            if let text = dataSicks[dataSicks.keys.sort()[indexPath.item]] as? String{
                label.text = text
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        guard let str = dataSicks[dataSicks.keys.sort()[indexPath.item]] as? String else{
            return CGSizeMake(40, 40)
        }
        let label = UILabel()
        label.text = str
        label.sizeToFit()
        return CGSizeMake(label.frame.size.width + 30, 32)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            if let cctl = self.nearestController() as? ShouYePageController{
                if let ctl = cctl.parentViewController as? ViewController{
                    ctl.tabBtnTap(ctl.tabBtns[1])
                }
            }
        if let tab = self.contentView.superview as? UITableView{
            if let ctl = tab.nearestController() as? ShouYePageController{
                if let cctl = ctl.parentViewController as? ViewController{
                    cctl.tabBtnTap(cctl.tabBtns[1])
                }
            }
        }
        var dic = [String:String]()
        dic["id"] = dataSicks.keys.sort()[indexPath.item]
        NSNotificationCenter.defaultCenter().postNotificationName("refreshCases", object: dic)
        
    }
    
    func collectionLayoutHasPrepared() {
        UIView.performWithoutAnimation { () -> Void in
            self.contentView.relatedTableView()?.reloadData()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for sub in self.subviews {
            let tail = "SeparatorView"
            if sub.dynamicType == NSClassFromString("_UITableViewCell\(tail)") {
                sub.removeFromSuperview()
            }
        }
    }
    
    /*func fetchData(){
        SharedNetWorkManager.GET(kcityAndSickUrlString, parameters: ["keyid":3362], success: { (task, result) -> Void in
            print(task.originalRequest)
            if let result = result as? [String:AnyObject],let data = result["data"] as? [AnyObject]{
                for obj in data{
                    if let sick  = obj as? [String:AnyObject],let parentId = sick["parentid"] as? Int{
                        if parentId == 0{
                            self.dataSicks.append(sick)
                        }
                        
                    }
                }
            }
            if self.dataSicks.count > 0{
                self.collectionView.reloadData()
            }
            }) { (task, error) -> Void in
                
        }
    }*/
}
