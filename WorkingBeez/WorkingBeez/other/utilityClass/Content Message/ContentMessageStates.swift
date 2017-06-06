//
//  ContentMessageStates.swift
//  InsurenceApp
//
//  Created by Bilal Ahmad on 7/29/16.
//  Copyright © 2016 Bilal Ahmad. All rights reserved.
//

import Foundation

public func ==(lhs: ContentMessageState, rhs: ContentMessageState) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public enum ContentMessageState: Hashable, Equatable {
    
    case `default`
    case networkError
    
    public var hashValue: Int {
        get {
            switch self {
            
            case .default: return -2
            case .networkError: return -3
            }
        }
    }
}
