

import UIKit

let SDRefreshViewDefaultHeight:CGFloat = 70.0
let HXQRefreshViewObservingkeyPath = "contentOffset"

class RefreshView: UIView {
    
    private weak var scrollView : UIScrollView?
    var refreshImageView : UIImageView?
    var timeLabel : UILabel?
    var beginRefreshTarget:AnyObject?
    var refreshAction:Selector?
    var refreshStatus = false
    var originalInset = UIEdgeInsetsZero
    var originalOffset = CGPointZero
    var lastRefreshDate : NSDate?
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: HXQRefreshViewObservingkeyPath)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let startImageView = UIImageView(frame: CGRectMake(frame.width/2-50, 0, 20, 20))
        startImageView.image = UIImage(named: "refresh")
        refreshImageView = startImageView
        let label = UILabel(frame: CGRectMake(frame.width/2-20, 0, 50, 10))
        label.text = "松开看看"
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.darkGrayColor()
        
        timeLabel = UILabel(frame: CGRectMake(frame.width/2-20, 13, 100, 10))
        timeLabel!.font = UIFont.systemFontOfSize(9)
        timeLabel!.textColor = UIColor.darkGrayColor()
        if let last = lastRefreshDate{
            timeLabel?.text = GetTimeInfoFromLastDate(last)
        }else{
            timeLabel?.text = "从未刷新"
        }
        self.addSubview(refreshImageView!)
        self.addSubview(label)
        self.addSubview(timeLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let scView = self.scrollView else {
            return
        }
        self.bounds = CGRectMake(0, 0, scView.frame.size.width, SDRefreshViewDefaultHeight)
    }
    
    func addtoScrollView(scllView:UIScrollView){
        originalInset = scllView.contentInset
        originalOffset = scllView.contentOffset
        self.scrollView?.removeObserver(self, forKeyPath: HXQRefreshViewObservingkeyPath)
        self.scrollView = scllView
        self.scrollView?.addSubview(self)
        self.scrollView?.addObserver(self, forKeyPath: HXQRefreshViewObservingkeyPath, options: NSKeyValueObservingOptions.New, context: nil)
        frame = CGRectMake(scllView.frame.width/2-25,-55,50,50)
        scrollView?.addSubview(self)
    }
    
    func addTarget(target:AnyObject,action:Selector){
        beginRefreshTarget = target
        refreshAction = action
    }

    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard keyPath == HXQRefreshViewObservingkeyPath else {
            return
        }
        guard let cuChange = change else {
            return
        }
        guard let _ = self.scrollView else {
            return
        }
        setTimeLabel()
        
        let y = cuChange["new"]?.CGPointValue.y
        
        if((y > 0) || (self.scrollView!.bounds.size.height == 0)){return}
        let step : CGFloat = 15
        if let scrollV = object as? UIScrollView where scrollV.dragging {
           
        }
        if(y < originalOffset.y-step*5 && !self.scrollView!.dragging){
            self.scrollView!.contentInset = UIEdgeInsets(top:step*5+originalInset.top, left: 0, bottom: 0, right: 0)
           
           
            guard let target = beginRefreshTarget else {
                return
            }
            guard let action = refreshAction else {
                return
            }
            if(!refreshStatus){
                target.respondsToSelector(action)
                target.performSelector(action)
                refreshStatus = true
            }
        }
    }
    
    func endReFresh(){
        UIView.animateWithDuration(0.6, animations:{
            self.scrollView!.contentInset = self.originalInset
            }) { (finished) -> Void in
                self.refreshStatus = false
                
        }
    }
    
    
    func GetTimeInfoFromLastDate(lastDate:NSDate) -> String{
        //let timeTemp = timeStamp / 1000
        //let date = NSDate(timeIntervalSince1970: timeTemp)
        let dateNow = NSDate()
        let time = dateNow.timeIntervalSinceDate(lastDate)
        
        var retTime : NSTimeInterval = 1.0
        
        if time < 3600 {
            retTime = time / 60
            var retTimeInt = Int(retTime)
            retTimeInt = retTimeInt <= 0 ? 1 : retTimeInt
            return "更新于\(retTimeInt)分钟前"
        }else if (time < (3600 * 24)) {
            retTime = time / 3600
            var retTimeInt = Int(retTime)
            retTimeInt = retTimeInt <= 0 ? 1 : retTimeInt
            return "更新于\(retTimeInt)小时前"
        }else if (time < 3600 * 24 * 7) {
            retTime = time / (3600 * 24)
            var retTimeInt = Int(retTime)
            retTimeInt = retTimeInt <= 0 ? 1 : retTimeInt
            return "更新于\(retTimeInt)天前"
        }else if (time > 3600 * 24 * 7) {
            retTime = time / (3600 * 24 * 7)
            var retTimeInt = Int(retTime)
            retTimeInt = retTimeInt <= 0 ? 1 : retTimeInt
            return "更新于\(retTimeInt)周前"
        }else{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.stringFromDate(lastDate)
            return "更新于" + dateString
        }
    }

    func setTimeLabel(){
        guard let time = timeLabel else {
            return
        }
        if let last = lastRefreshDate{
            time.text = GetTimeInfoFromLastDate(last)
        }else{
            time.text = "从未刷新"
        }
    }
}

