//
//  ContentMessageView.swift
//  InsurenceApp
//
//  Created by Bilal Ahmad on 7/11/16.
//  Copyright © 2016 Bilal Ahmad. All rights reserved.
//

import Foundation
import UIKit

open class ContentMessageView: UIView {
    
    // Members
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    fileprivate var stateInfos: [ContentMessageState : StateInfo] = [ContentMessageState : StateInfo] ()

    // inits
    open class func CreateView(_ parent: UIView,strMessage: String,strImageName: String,color:UIColor) -> ContentMessageView
    {
        let view: ContentMessageView = Bundle.main.loadNibNamed("ContentMessageViewXib", owner: nil, options: nil)![0] as! ContentMessageView
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.contentContent(strMessage, icon: strImageName,color: color, forState: ContentMessageState.default)
        parent.addSubview(view)
        //view.center = parent.center
        //view.frame = CGRect(x: parent.frame.origin.x, y: view.frame.origin.y-64, width: view.frame.size.width, height: view.frame.size.height)
        print(view)
        print(parent)
        /*parent.addConstraints(
            [
                NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: parent, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: parent, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            ])*/
        //view.frame = CGRect(x: parent.frame.origin.x, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.frame = CGRect.init(x: (parent.frame.size.width-view.frame.size.width)/2, y: ((parent.frame.size.height-64-view.frame.size.height)/2), width: view.frame.size.width, height: view.frame.size.height)
        return view
    }
    
    // overrides
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    // actions
    open func contentContent (_ message: String?, icon: String?,color:UIColor?, forState state: ContentMessageState) {
        
        let info: StateInfo = stateInfos[state] ?? StateInfo()
        
        if message != nil {
            info.message = message!
        }
        if icon != nil {
            info.icon = icon!
        }
        if color != nil
        {
            info.color = color!
        }
        stateInfos[state] = info
        setVisibility(true, forState: state)
    }
    open func hide() {
        
        self.isHidden = true
    }
    open func show(_ state: ContentMessageState) {
        
        if let info: StateInfo = stateInfos[state] {
            message.text = info.message
            icon.image = UIImage.init(named: info.icon)
            message.textColor = info.color
        }
        
        self.isHidden = false
    }
    
    open func setVisibility(_ visible: Bool, forState state: ContentMessageState) {
        
        if visible {
            show(state)
        }
        else {
            hide()
        }
    }
    
}

open class StateInfo {
    var message: String = ""
    var icon: String = ""
    var color: UIColor = UIColor.lightGray
    init () { }
    init (message: String, icon: String,color:UIColor) {
        
    }
}








