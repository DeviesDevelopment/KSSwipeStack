//
//  SwipableData.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import Foundation

/**
Protocol which must be implemented by all data models meant to be swiped in the card stack.
 */
public protocol SwipableData {
    /**
     - returns: The view to be rendered in the card stack representing this piece of data.
     */
    func getView(with frame: CGRect) -> SwipableView
}
