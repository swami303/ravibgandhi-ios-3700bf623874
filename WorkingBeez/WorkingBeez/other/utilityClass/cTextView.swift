//
//  cTextView.swift
//  SnowSensei
//
//  Created by Brainstorm on 12/6/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class cTextView: UITextView {

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
