//
//  DesignableView.swift
//  NutrientPlus
//
//  Created by hoo on 11/5/19.
//  Copyright © 2019 hoo. All rights reserved.
//
// tutorial followed: https:// www.youtube.com/watch?v=DmWv-JtQH4Q&t=918s

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
