//
//  CustomViewWithoutButton.swift
//  xibView
//
//  Created by Swami on 3/2/17.
//  Copyright © 2017 brainstorm. All rights reserved.
//

import UIKit

class CustomViewWithoutButton: UIView
{

    var view: UIView!
    var strText : String = ""
    var backColor: UIColor!
    var borderColor: UIColor!
    @IBOutlet weak var lblText: UILabel!
    @IBInspectable var labelText: String?
        {
        get {
            return lblText.text
        }
        set(text) {
            lblText.text = text
        }
    }
    @IBInspectable var labelFrame: CGRect?
        {
        get {
            return lblText.frame
        }
        set(frame) {
            lblText.frame = frame!
        }
    }
    @IBInspectable var viewBackColor: UIColor?
        {
        get {
            return self.backgroundColor
        }
        set(color) {
            self.backgroundColor = color
        }
    }
    init(s: String,viewBorderColor:UIColor,viewBackColor:UIColor)
    {
        strText = s
        backColor = viewBackColor
        borderColor = viewBorderColor
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup()
    {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        self.lblText.text = strText
        //self.btnFirstOutlet.frame = CGRect.init(x: self.btnFirstOutlet.frame.origin.x, y: self.btnFirstOutlet.frame.origin.y, width: 0, height: self.btnFirstOutlet.frame.size.height)
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
//        view.backgroundColor = backColor
//        view.layer.borderWidth = 1
//        view.layer.borderColor = borderColor.cgColor
//        view.clipsToBounds = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomViewWithoutButton", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }


}
