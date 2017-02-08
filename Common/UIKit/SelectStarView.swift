//
//
//  Created by sogou on 15/6/23.
//

import UIKit

@objc protocol SelectStarViewDelegate {
    optional func selectStarViewDidSelectCount(count : Int) -> Void
}

@IBDesignable
class SelectStarView: StarView {
    
    @IBInspectable var selectedStarImage : UIImage? = UIImage(named: defaultStarImageName)
    @IBInspectable var unSelectedStarImage : UIImage? = UIImage(named: defaultHalfStarImageName)
    @IBInspectable var selectedStarNum : Int = 0 {
        didSet {
            needsRelayoutStars = true
        }
    }
    
    var delegate : SelectStarViewDelegate?
    
    override var starCount : Float{
        didSet {
            self.cleanUp(Int(oldValue))
            needsRelayoutStars = true
        }
    }

    private let gesture : UITapGestureRecognizer
    
    required init?(coder aDecoder: NSCoder) {
        gesture = UITapGestureRecognizer()
        super.init(coder: aDecoder)
        gesture.addTarget(self, action: "didTap:")
        self.addGestureRecognizer(gesture)
        starCount = 5

    }
    override init(frame: CGRect) {
        gesture = UITapGestureRecognizer()
        super.init(frame: frame)
        gesture.addTarget(self, action: "didTap:")
        self.addGestureRecognizer(gesture)
        starCount = 5
    }
    
    func didTap(recognizer : UITapGestureRecognizer){
        let pt = recognizer.locationInView(self)
        for i in 0 ..< Int(starCount) {
            let view = self.viewWithTag(starTag+i)
            if view != nil && CGRectContainsPoint(view!.frame, pt) {
                //find selected star
                self.selectedStarNum = i+1
                self.delegate?.selectStarViewDidSelectCount?(self.selectedStarNum)
                needsRelayoutStars = true
                break
            }
        }
    }
    
    private let starTag = 123321
    func cleanUp(oldCount:Int?){
        let count = oldCount != nil ? oldCount! : Int(starCount)
        for i in 0..<count {
            let view = self.viewWithTag(starTag+i)
            view?.removeFromSuperview()
        }
    }
    
    override func reLayoutStars() {
        // clean up
        self.cleanUp(nil)
        if (self.selectedStarImage == nil || self.unSelectedStarImage == nil) {
            return
        }
        // rebuild
        var views = [String:UIView]()
        let imageSizeWidth : Float = Float(selectedStarImage!.size.width)
        let imgWidth = imageWidth>0.0 ? imageWidth:imageSizeWidth
        let metrics = ["padding":self.imagePadding,"width":imgWidth]
        var vflH = "H:|"
        for i in 0..<selectedStarNum {
            let key = "star\(i)"
            let imageView = UIImageView(image: self.selectedStarImage)
            imageView.useAutoLayout()
            imageView.contentMode = .ScaleAspectFit
            imageView.tag = starTag+i
            self.addSubview(imageView)
            views[key] = imageView
            vflH += ((i == 0 ? "-0-":"-padding-") + "[\(key)(width)]")
        }
        for i in selectedStarNum..<Int(starCount){
            let key = "star\(i)"
            let imageView = UIImageView(image: self.unSelectedStarImage)
            imageView.useAutoLayout()
            imageView.tag = starTag+i
            imageView.contentMode = .ScaleAspectFit
            self.addSubview(imageView)
            views[key] = imageView
            vflH += ((i == 0 ? "-0-":"-padding-") + "[\(key)(width)]")
        }
        NSLayoutConstraint.constraintsWithVisualFormat(vflH, options: [.AlignAllBottom, .AlignAllTop], metrics: metrics, views: views).autolayoutInstall()
        let firstImageView = views["star0"]
        NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view":firstImageView!]).autolayoutInstall()
    }
}
