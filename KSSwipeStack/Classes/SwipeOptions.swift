//
//  SwipeOptions.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import UIKit

public struct SwipeOptions {
    public var throwingThreshold = Float(800)
    public var snapDuration = 0.1
    public var allowHorizontalSwipes = true
    public var allowVerticalSwipes = false
    public var horizontalPanThreshold = CGFloat(0.5)
    public var verticalPanThreshold = CGFloat(0.5)
    public var visibleImageOrigin = CGPoint(x: 0, y: 0)
    public var allowUndo = true
    public var maxRenderedCards = 5
    public var refillThreshold = 10
    public var dismissAnimationDuration = 0.25
    public var freezeWhenDismissing = false
    
    public init(){}
}
