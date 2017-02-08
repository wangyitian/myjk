//
//  NetWork.swift
//  AmericanMedical
//
//  Created by yangbin on 15/12/23.
//  Copyright © 2015年 yb. All rights reserved.
//

import Foundation
import AFNetworking

let SharedNetWorkManager : AFHTTPSessionManager = {
    let manager = AFHTTPSessionManager(baseURL:kNetBaseUrl)
    var set = manager.responseSerializer.acceptableContentTypes
    set?.insert("text/html")
    set?.insert("text/plain")
    manager.responseSerializer.acceptableContentTypes = set
    //
    let netCache = NSURLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity : 1024 * 1024  * 500, diskPath : nil)
    NSURLCache.setSharedURLCache(netCache)
    return manager
}()

let SharedJsonPostNetWorkManager : AFHTTPSessionManager = {
    let manager = AFHTTPSessionManager(baseURL:kNetBaseUrl)
    var set = manager.responseSerializer.acceptableContentTypes
    set?.insert("text/html")
    set?.insert("text/plain")
    manager.responseSerializer.acceptableContentTypes = set
    manager.requestSerializer = AFJSONRequestSerializer()
    return manager
}()


//let kNetBaseString = "http://api.moklr.com/"
let kNetBaseString = "http://meiyujiankang.com/"
let kNetBaseUrl = NSURL(string: kNetBaseString)!

let kShouYeUrlString = "v1/index/init"
let kSampleUrlString = "v1/index/cases"
let kNewsUrlString = "v1/index/news"
let kYuanChengUrlString = "v1/index/telemedicine"
let kusMeUrlString = "v1/index/usmedical"
let khospitalUrlString = "v1/content/hospitals"
let kdoctersUrlString = "v1/content/doctors"
let kdetailUrlString = "v1/content/show"
let kregisterUrlString = "v1/account/register"
let kloginUrlString = "v1/account/login"
let klogoutUrlString = "v1/account/logout"
let kagreementUrlString = "v1/account/agreement"
let kmodifyInfoUrlString = "v1/account/update"
let kcityAndSickUrlString = "v1/account/linkage"
let kfindPasswordUrlString = "v1/account/password"
let kxieyiUrlString = "v1/service/agreement"
let kproductListUrlString = "v1/service/products"
let kbuyUrlString = "v1/service/buy"
let kuserInfoUrlString = "v1/account/detail"
let kordersUrlString = "v1/service/detail"
let kjingzhunUrlString = "v1/service/precision"
let kformUrlString = "v1/service/myform"
let kinfosUrlString = "v1/account/message"
let jingzhunyiliaoInfoUrlString = "/v1/index/jingzhun"

func GetcollectionParentCell(view : UIView) -> UICollectionViewCell? {
    var parent = view.superview
    while parent != nil {
        if let p = parent as? UICollectionViewCell {
            return p
        }
        parent = parent?.superview
    }
    return nil
}
