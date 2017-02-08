//
//  LeftAlignCollectionViewLayout.swift
//  PowerManage
//
//  Created by yb on 15/12/17.
//  Copyright © 2015年 zhonghengborui. All rights reserved.
//

import UIKit

@objc protocol LeftAlignCollectionViewLayoutDelegate : UICollectionViewDelegateFlowLayout {
    optional func collectionLayoutHasPrepared() -> Void
}

class LeftAlignCollectionViewLayout: UICollectionViewFlowLayout {
    var paddingX : CGFloat = 12
    var paddingY : CGFloat = 16

    var layoutCache = [UICollectionViewLayoutAttributes]()
    
    override func prepareLayout() {
        layoutCache.removeAll()
        guard let collectionView = collectionView else {
            return
        }
        let itemsCount = collectionView.numberOfItemsInSection(0)
        for i in 0..<itemsCount {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            var itemSize = CGSizeMake(10, 10)
            if let layoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout, size = layoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAtIndexPath: indexPath){
                itemSize = size
            }
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            if i == 0 {
                attributes.frame = CGRectMake(0, 0, itemSize.width, itemSize.height)
            } else {
                let lastAtt = layoutCache[i-1]
                if (CGRectGetMaxX(lastAtt.frame) + paddingX + itemSize.width > collectionView.frame.size.width) {
                    attributes.frame = CGRectMake(0, CGRectGetMaxY(lastAtt.frame) + paddingY, itemSize.width, itemSize.height)
                } else {
                    attributes.frame = CGRectMake(CGRectGetMaxX(lastAtt.frame) + paddingX, lastAtt.frame.origin.y, itemSize.width, itemSize.height)
                }
            }
            layoutCache.append(attributes)
        }
        (collectionView.delegate as? LeftAlignCollectionViewLayoutDelegate)?.collectionLayoutHasPrepared?()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()
        for attr in layoutCache {
            if CGRectIntersectsRect(attr.frame, rect) {
                result.append(attr)
            }
        }
        return result
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item < layoutCache.count else {
            return nil
        }
        return layoutCache[indexPath.item]
    }
    
    override func collectionViewContentSize() -> CGSize {
        guard let collectionView = collectionView, last = layoutCache.last else {
            return CGSizeZero
        }
        let height = CGRectGetMaxY(last.frame)
        return CGSizeMake(collectionView.frame.size.width, height)
    }

}
