//
//  UIImageViewExt.swift
//  HuaXueQuan
//
//  Created by yangbin on 15/8/23.
//  Copyright © 2015年 hxq. All rights reserved.
//

import UIKit
import AFNetworking

extension UIImageView {
    func setImageWithNullableURL(url : NSURL?, placeholderImage: UIImage?) {
        if let url = url {
            self.setImageWithURL(url, placeholderImage: placeholderImage)
        }
    }
}