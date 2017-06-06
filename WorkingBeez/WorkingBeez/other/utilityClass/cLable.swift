//
//  cLable.swift
//  orderpilz
//
//  Created by Brainstorm on 11/28/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class cLable: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet { self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white
        {
        didSet{self.layer.borderColor = borderColor.cgColor}
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet { self.layer.borderWidth = borderWidth }
    }
//    let topInset = CGFloat(10)
//    let bottomInset = CGFloat(10)
//    let leftInset = CGFloat(10)
//    let rightInset = CGFloat(10)
//    
//    override func drawText(in rect: CGRect)
//    {
//        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//    }
//    
//    override public var intrinsicContentSize: CGSize
//    {
//        var intrinsicSuperViewContentSize = super.intrinsicContentSize
//        intrinsicSuperViewContentSize.height += topInset + bottomInset
//        intrinsicSuperViewContentSize.width += leftInset + rightInset
//        return intrinsicSuperViewContentSize
//    }
}
