//
//  JsonModel.swift
//  HuaXueQuan
//
//  Created by yangbin on 15/8/22.
//  Copyright © 2015年 hxq. All rights reserved.
//

import Foundation

protocol JsonModel {
    init(object : AnyObject)
    static func buildWithArray(array : [AnyObject]) -> [Self]
}

protocol JsonModelValidation {
    var isValidate : Bool {get}
}
// MARK: json model convenient set operator
infix operator <- {}
//left is Int or Float , right is any
infix operator <-- {}


func <- <T>(inout left : T, right : T) {
    left = right
}

func <- <T>(inout left : T, right : T?) {
    guard let right = right else {
        return
    }
    left = right
}

func <-- <T>(inout left : Int, right : T?) {
    guard let right = right else {
        return
    }
    if let num = right as? Int {
        left = num
        return
    }
    if let numStr = right as? NSString {
        left = numStr.integerValue
    }
}

func <-- <T>(inout left : Float, right : T?) {
    guard let right = right else {
        return
    }
    if let num = right as? Float {
        left = num
        return
    }
    if let numStr = right as? NSString {
        left = numStr.floatValue
    }
}

func <- <T>(inout left : T, right : AnyObject?) {
    guard let right = right as? T else {
        return
    }
    left = right
}

func <- <T>(inout left : T?, right : AnyObject?) {
    guard let right = right as? T else {
        return
    }
    left = right
}

func <- (inout left : NSURL?, right : AnyObject?) {
    if let right = right as? NSURL {
        left = right
    } else if let right = right as? String {
        left = NSURL(string: right)
    }
}

extension JsonModel {
    static func buildWithArray(array : [AnyObject]) -> [Self]{
        var result = [Self]()
        for object in array {
            let model = Self(object: object)
            result.append(model)
        }
        return result
    }
}