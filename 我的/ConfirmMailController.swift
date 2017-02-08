//
//  ConfirmMailController.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/22.
//  Copyright © 2015年 yb. All rights reserved.
//

import UIKit
import AFNetworking

class ConfirmMailController: UIViewController {

    var bookingURL = ""
    @IBOutlet var webView : UIWebView!
    
    @IBAction func saveToPhoto() {
        guard bookingURL != "" else {
            return
        }
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFImageResponseSerializer()
        manager.GET(bookingURL, parameters: nil, success: { (task, image) -> Void in
            guard let image = image as? UIImage else {
                YBToastView.showToast(inView: self.view, withText: "保存失败")
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, self, "imageSaveFinish:error:contextInfo:", nil)
            }) { (task, error) -> Void in
                YBToastView.showToast(inView: self.view, withText: "保存失败")
                print(error)
        }
    }
    dynamic func imageSaveFinish(image : UIImage, error : NSError?, contextInfo: UnsafeMutablePointer<Void>) {
        if error == nil {
            YBToastView.showToast(inView: self.view, withText: "保存成功")
        } else {
            YBToastView.showToast(inView: self.view, withText: "保存失败")
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "预约确认函"
        navigationItem.leftBarButtonItem = GetLeftBarButtonItem(self, action: "back")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = NSURL(string: bookingURL) where bookingURL != "" else {
            return
        }
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func back(){
        navigationController?.popViewControllerAnimated(true)
    }

}
