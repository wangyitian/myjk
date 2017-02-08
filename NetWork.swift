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
    let netCache = NSURLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity : 1024 * 1024  * 200, diskPath : nil)
    NSURLCache.setSharedURLCache(netCache)
    return manager
}()


let kNetBaseString = "http://api.moklr.com/"
let kNetBaseUrl = NSURL(string: kNetBaseString)!

let kShouYeUrlString = "v1/index/init"
let kSampleUrlString = "v1/index/cases"
let kNewsUrlString = "v1/index/news"
let kYuanChengUrlString = "v1/index/telemedicine"
let kusMeUrlString = "v1/index/usmedical"
let khospitalUrlString = "v1/content/hospitals"
let kdetailUrlString = "v1/content/show"