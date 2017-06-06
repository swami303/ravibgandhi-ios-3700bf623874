//
//  CustomViewSingleButton.swift
//  CustomViewFromXib
//
//  Created by Paul Solt on 12/10/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

@IBDesignable class CustomViewSingleButton: UIView
{
    
    // Our custom view from the XIB file
    var view: UIView!
    var strText : String = ""
    var img2 : String = ""
    var backColor: UIColor!
    var borderColor: UIColor!
    // Outlets
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnSecondOutlet: UIButton!
    
    @IBAction func btnSecondAction(_ sender: Any)
    {
        print("Pressed second button")
    }
    
   
    

    @IBInspectable var labelText: String?
        {
        get {
            return lblText.text
        }
        set(text) {
            lblText.text = text
        }
    }
    
    @IBInspectable var secondButtonImage: UIImage?
        {
        get {
            return btnSecondOutlet.currentImage
        }
        set(image) {
            btnSecondOutlet.setImage(image, for: UIControlState.normal)
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
    
    
    
//    override init(frame: CGRect)
//    {
//        // 1. setup any properties here
//        
//        // 2. call super.init(frame:)
//        super.init(frame: frame)
//        
//        // 3. Setup view from .xib file
//        xibSetup()
//    }

    init(s: String, image1name : String, image2name : String,viewBorderColor:UIColor,viewBackColor:UIColor)
    {
        strText = s
        img2 = image2name
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
        self.btnSecondOutlet.setImage(UIImage.init(named: img2), for: UIControlState.normal)
        //self.btnFirstOutlet.frame = CGRect.init(x: self.btnFirstOutlet.frame.origin.x, y: self.btnFirstOutlet.frame.origin.y, width: 0, height: self.btnFirstOutlet.frame.size.height)
        if(img2 == "")
        {
            self.btnSecondOutlet.frame = CGRect.init(x: self.btnSecondOutlet.frame.origin.x, y: self.btnSecondOutlet.frame.origin.y, width: 0, height: self.btnSecondOutlet.frame.size.height)
        }
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        view.backgroundColor = backColor
        view.layer.borderColor = borderColor.cgColor
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomViewSingleButton", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    
    // If you add custom drawing, it'll be behind any view loaded from XIB
    
    
    }
    */
    
}
