//
//  SwipeOptions.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import UIKit

public struct SwipeOptions {
    let throwingThreshold = Float(800)
    let snapDuration = 0.1
    let horizontalPanThreshold = CGFloat(0.5)
    let screenSize: CGSize = UIScreen.main.bounds.size
    let visibleImageOrigin = CGPoint(x: 0, y: 0)
    let rightStackOrigin = CGPoint(x: UIScreen.main.bounds.size.width * 2, y: 0)
    let leftStackOrigin = CGPoint(x: -UIScreen.main.bounds.size.width * 2, y: 0)
    let allowUndo = true
    var maxRenderedCards = 5
    var refillThreshold = 10
    var dismissAnimationDuration = 0.25
    var freezeWhenDismissing = false
    
    public init(){}
}
