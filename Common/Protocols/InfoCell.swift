//
//  InfoCell.swift
//  HuaXueQuan
//
//  Created by yangbin on 15/8/22.
//  Copyright © 2015年 hxq. All rights reserved.
//

import Foundation


protocol InfoCell {
    func setInfo(info : [String:AnyObject]) -> Void
    func setInfo(info : [AnyObject]) -> Void
    func setInfo(info : JsonModel) -> Void
}

extension InfoCell {
    func setInfo(info : [String:AnyObject]) -> Void {
        
    }
    func setInfo(info : [AnyObject]) -> Void {
        
    }
    func setInfo(info : JsonModel) -> Void {
        
    }
}