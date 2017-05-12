//  SwipeDelegate.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import Foundation
/**
 Implement this protocol to observe swipes in the card stack.
 */
public protocol SwipeDelegate {
    /**
     Fires on every swipe in the stack
     - parameter swipe: The swipe which just occured.
     */
    func onNext(_ swipe: Swipe)
 }
