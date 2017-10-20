//
//  SwipeDirection.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import Foundation

public enum SwipeDirection {
    case left
    case right
    case up
    case down
    
    func getSwipeEndpoint() -> CGPoint {
        switch self {
        case .left:
            return CGPoint(x: -UIScreen.main.bounds.size.width * 2, y: 0)
        case .right:
            return CGPoint(x: UIScreen.main.bounds.size.width * 2, y: 0)
        case .up:
            return CGPoint(x: 0, y: -UIScreen.main.bounds.size.width * 2)
        case .down:
            return CGPoint(x: 0, y: UIScreen.main.bounds.size.width * 2)
        }
    }
}
