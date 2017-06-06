//
//  jobAnnotation.swift
//  WorkingBeez
//
//  Created by Brainstorm on 3/11/17.
//  Copyright © 2017 Brainstorm. All rights reserved.
//

import UIKit

class jobAnnotation: NSObject,MKAnnotation
{
    
    var title : String?
    var subTit : String?
    var coordinate : CLLocationCoordinate2D
    
    init(title:String,coordinate : CLLocationCoordinate2D,subtitle:String){
        
        self.title = title;
        self.coordinate = coordinate;
        self.subTit = subtitle;
        
    }
}
