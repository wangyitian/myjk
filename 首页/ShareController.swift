//
//  ShareController.swift
//  AmericanMedical
//
//  Created by yangbin on 16/1/23.
//  Copyright © 2016年 yb. All rights reserved.
//

import UIKit
import BeeCloud

class ShareController: UIViewController {

    var shareTitle = ""
    var shareUrl = ""
    var photoUrl = ""
    @IBAction func shareToWeixin(){
        shareWithType(Int32(WXSceneSession.rawValue))
    }
    
    @IBAction func shareToPengyouQ(){
        shareWithType(Int32(WXSceneTimeline.rawValue))
    }
    
    func shareWithType(type : Int32) {
        guard let url = NSURL(string: photoUrl) else {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            guard let imageData = NSData(contentsOfURL: url) else {
                return
            }
            let image = UIImage(data: imageData)
            let thumbData = UIImage.resizeImage(image, maxDataSize: 30, resizedQuality: nil)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let msg = WXMediaMessage()
                msg.title = self.shareTitle
                msg.thumbData = thumbData
                
                let ext = WXWebpageObject()
                ext.webpageUrl = self.shareUrl
                msg.mediaObject = ext
                let req = SendMessageToWXReq()
                req.bText = false
                req.message = msg
                req.scene = type
                WXApi.sendReq(req)
            })
        }
    }
    
    @IBAction func tapView(){
        self.removeControllerAndViewFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
