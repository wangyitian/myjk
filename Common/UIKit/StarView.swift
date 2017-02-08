//
//
//  Created by bin on 6/7/15.
//

import UIKit

 let defaultStarImageName = "oneStar"
 let defaultHalfStarImageName = "star_half.png"
 let defaultEmptyStarImageName = "halfStar"

@IBDesignable
class StarView: UIView {
    @IBInspectable var starImage:UIImage? = UIImage(named: defaultStarImageName) {
        didSet {
            needsRelayoutStars = true
        }
    }
    @IBInspectable var halfImage:UIImage? = UIImage(named: defaultEmptyStarImageName) {
        didSet {
            needsRelayoutStars = true
        }
    }
    @IBInspectable var halfPartImage:UIImage? = UIImage(named: defaultHalfStarImageName) {
        didSet {
            needsRelayoutStars = true
        }
    }
    @IBInspectable var imageWidth:Float = 0.0 {
        didSet {
            if imageWidth != oldValue{
                needsRelayoutStars = true
            }
        }
    }
    @IBInspectable var imagePadding:Float = 1.0 {
        didSet {
            if imagePadding != oldValue{
                needsRelayoutStars = true
            }
        }
    }
    @IBInspectable var starCount : Float = 0 {
        didSet {
            if starCount != oldValue{
                needsRelayoutStars = true
            }
        }
    }
    @IBInspectable var totalStarCount : Int = 5 {
        didSet {
            if totalStarCount != oldValue{
                needsRelayoutStars = true
            }
        }
    }
    
    var needsRelayoutStars = false {
        didSet {
            if needsRelayoutStars && !oldValue {
                self.setNeedsLayout()
            }
        }
    }

    override func layoutSubviews() {
        if needsRelayoutStars {
            self.reLayoutStars()
            needsRelayoutStars = false
        }
        super.layoutSubviews()
    }
    
    func reLayoutStars() {
        // clean up
        let starTag = 123321
        for view in self.subviews {
            if view.tag == starTag {
                view.removeFromSuperview()
            }
        }
        if (self.starImage == nil || self.halfImage == nil) {
            return
        }
        // rebuild
        if Float(totalStarCount) < starCount {
            return
        }
        let fullStarCount = Int(starCount);
        let halfStarsCount = abs(starCount - Float(fullStarCount)) < FLT_EPSILON ? 0 : 1;
//        if fullStarCount + halfStarsCount == 0 {
//            if !self.translatesAutoresizingMaskIntoConstraints() {
//                NSLayoutConstraint.constraintsWithVisualFormat("H:[self(==0@250)]", options: nil, metrics: nil, views: ["self":self]).autolayoutInstall()
//                NSLayoutConstraint.constraintsWithVisualFormat("V:[self(==0@250)]", options: nil, metrics: nil, views: ["self":self]).autolayoutInstall()
//            } else {
//                var frame = self.frame
//                frame.size.width = 0
//                frame.size.height = 0
//                self.frame = frame
//            }
//            return
//        } else {
//            for constraint in self.constraints() {
//                let c = (constraint as! NSLayoutConstraint)
//                if (c.firstItem as! NSObject == self && c.firstAttribute == .Width && c.constant == 0){
//                    c.uninstall()
//                }
//            }
//        }
        var views = [String:UIView]()
        let imageSizeWidth : Float = Float(starImage!.size.width)
        let imgWidth = imageWidth>0.0 ? imageWidth:imageSizeWidth
        let metrics = ["padding":self.imagePadding,"width":imgWidth]
        var vflH = "H:|"
        for i in 0..<fullStarCount {
            let key = "star\(i)"
            let imageView = UIImageView(image: self.starImage)
            imageView.useAutoLayout()
            imageView.contentMode = .ScaleAspectFit
            imageView.tag = starTag
            self.addSubview(imageView)
            views[key] = imageView
            vflH += ((i == 0 ? "-0-":"-padding-") + "[\(key)(width)]")
        }
        for i in fullStarCount..<(fullStarCount+halfStarsCount){
            let key = "star\(i)"
            let imageView = UIImageView(image: self.halfPartImage)
            imageView.useAutoLayout()
            imageView.tag = starTag
            imageView.contentMode = .ScaleAspectFit
            self.addSubview(imageView)
            views[key] = imageView
            vflH += ((i == 0 ? "-0-":"-padding-") + "[\(key)(width)]")
        }
        for i in (fullStarCount+halfStarsCount)..<totalStarCount{
            let key = "star\(i)"
            let imageView = UIImageView(image: self.halfImage)
            imageView.useAutoLayout()
            imageView.tag = starTag
            imageView.contentMode = .ScaleAspectFit
            self.addSubview(imageView)
            views[key] = imageView
            vflH += ((i == 0 ? "-0-":"-padding-") + "[\(key)(width)]")
        }
        NSLayoutConstraint.constraintsWithVisualFormat(vflH, options: [.AlignAllBottom , .AlignAllTop], metrics: metrics, views: views).autolayoutInstall()
        let firstImageView = views["star0"]
        NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":firstImageView!]).autolayoutInstall()
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
