//
//  Swipe.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import Foundation
/**
 Representation of the swiping of a card in the stack
 */
public struct Swipe {
    public var direction: SwipeDirection
    public var data: SwipableData?
}
