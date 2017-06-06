//
//  cView.swift
//  orderpilz
//
//  Created by Brainstorm on 11/26/16.
//  Copyright © 2016 Brainstorm. All rights reserved.
//

import UIKit

open class cView: UIView 
{
    fileprivate var isSettingCorners: Bool = false
    @IBInspectable var cornerRadius: CGFloat = 0.0
        {
        didSet { self.layer.cornerRadius = cornerRadius }
    }
    @IBInspectable var DropShadow: Bool = false {
        didSet {
            if (DropShadow) { applyShadow() }
            else {
                self.layer.masksToBounds = true;
            }
        }
    }
    
    @IBInspectable var RadiiSize : CGSize = CGSize()
        {
        didSet
        {
            if (oldValue != RadiiSize) { applyRoundness() }
        }
    }
    @IBInspectable var BottomLeftCorner : Bool = false
        { didSet { if (oldValue != BottomLeftCorner) {  applyRoundness() } } }
    
    @IBInspectable var BottomRightCorner : Bool = false
        { didSet { if (oldValue != BottomRightCorner) { applyRoundness() } } }
    
    @IBInspectable var TopLeftCorner : Bool = false
        { didSet { if (oldValue != TopLeftCorner) { applyRoundness() } } }
    
    @IBInspectable var TopRightCorner : Bool = false
        { didSet { if (oldValue != TopLeftCorner) { applyRoundness() } } }
    
    @IBInspectable var borderWidth : CGFloat = 5
        {
        didSet
        {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor : UIColor = UIColor.clear
        {
        didSet
        {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var ConsumeTouch : Bool = false
    
    internal func setRoundCorners(_ top: Bool, bottom: Bool)
    {
        setRoundCorners(top, topRight: top, bottomLeft: bottom, bottomRight: bottom)
    }
    internal func applyShadow () {
        let shadowPath: UIBezierPath = UIBezierPath.init(rect: self.bounds);
        layer.masksToBounds = false;
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath;
    }
    internal func setRoundCorners(_ topLeft: Bool, topRight: Bool, bottomLeft: Bool, bottomRight: Bool)
    {
        isSettingCorners = true
        
        TopLeftCorner = topLeft
        TopRightCorner = topRight
        BottomLeftCorner = bottomLeft
        BottomRightCorner = bottomRight
        
        isSettingCorners = false
        applyRoundness()
    }
    fileprivate func applyRoundness()
    {
        if (DropShadow) { return }
        if isSettingCorners { return }
        
        var corners: UInt = 0
        
        if BottomLeftCorner { corners |= UIRectCorner.bottomLeft.rawValue }
        if BottomRightCorner { corners |= UIRectCorner.bottomRight.rawValue }
        if TopLeftCorner { corners |= UIRectCorner.topLeft.rawValue }
        if TopRightCorner { corners |= UIRectCorner.topRight.rawValue }
        
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: UIRectCorner(rawValue: corners), cornerRadii:RadiiSize)
        
        if var maskLayer: CAShapeLayer? = CAShapeLayer()
        {
            maskLayer!.frame = self.bounds
            maskLayer!.path = maskPath.cgPath
            
            layer.mask = maskLayer;
            maskLayer = nil
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if !ConsumeTouch { return super.point(inside: point, with: event) }
        
        for v in subviews
        {
            if v.point(inside: point, with: event) { return true }
        }
        
        return false
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        applyRoundness()
        if (DropShadow) {
            applyShadow()
        }
    }
}
