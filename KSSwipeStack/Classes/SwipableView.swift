//
//  SwipableView.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import UIKit

open class SwipableView: UIView {
    private var data: SwipableData?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func respondToSwipe(like: Bool, opacity: Float) {
    }
    
    open func resetView() {
    }
    
    open func respondToDismiss() {
    }
    
    open func setData(_ data: SwipableData) {
        self.data = data
    }
    
    open func getData() -> SwipableData? {
        return data
    }
    
    open func isUndoable() -> Bool {
        return false
    }
}
