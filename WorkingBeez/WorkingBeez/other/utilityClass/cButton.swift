//
//  cButton.swift
//  orderpilz
//
//  Created by Brainstorm on 11/26/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class cButton: UIButton
{
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet { self.layer.cornerRadius = cornerRadius }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white
        {
        didSet{self.layer.borderColor = borderColor.cgColor}
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet { self.layer.borderWidth = borderWidth }
    }
}
