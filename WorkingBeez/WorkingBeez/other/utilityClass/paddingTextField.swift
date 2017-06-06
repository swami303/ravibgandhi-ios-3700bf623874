//
//  paddingTextField.swift
//  orderpilz
//
//  Created by Brainstorm on 11/25/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

class paddingTextField: UITextField
{
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return CGRect(origin: CGPoint(x: bounds.origin.x + paddingLeft,y :bounds.origin.y), size: CGSize(width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return textRect(forBounds: bounds)
    }
    //Placeholder color
     func placeHolderColor(forColor color:UIColor) -> UIColor
    {
        return color
    }
    func placeHolderColorText(forColor color:UIColor) -> UIColor
    {
        return placeHolderColor(forColor: color)
    }
    
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
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.image = image
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSForegroundColorAttributeName: color])
    }
}

extension UITextField
{
    @IBInspectable var placeHolderColor: UIColor?
        {
        get
        {
            return self.placeHolderColor
        }
        set
        {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
private var maxLengths = [UITextField: Int]()

extension UITextField {
    
    @IBInspectable var maxLength: Int
        {
        
        get {
            
            guard let length = maxLengths[self]
                else {
                    return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControlEvents.editingChanged
            )
        }
    }
    func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text,
            prospectiveText.characters.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}


