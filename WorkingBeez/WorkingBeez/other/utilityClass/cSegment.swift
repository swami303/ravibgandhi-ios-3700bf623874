//
//  cSegment.swift
//  WorkingBeez
//
//  Created by Brainstorm on 2/25/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class cSegment: UISegmentedControl {

        @IBInspectable var height: CGFloat = 29 {
            didSet {
                let centerSave = center
                frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: height)
                center = centerSave
            }
        }
}
