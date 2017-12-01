//
//  SwipableView.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import UIKit
/**
 Class which all view means to be presented in the card stack must inherit from.
 */
open class SwipableView: UIView {
    private var data: SwipableData?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /**
     Is fired when the view is being moved within the stack. 
     ## You can here change the visuals of the view based on:
        - Whether or not the card is being swiped to the right (liked) or (disliked)
        - The requested opacity of any overlays the view might have, based on the x-position of the view.
     
     - parameter like: true for like (right) and false for dislike (left)
     - parameter opacity: the requested opacity of overlays. Based on x-position
     */
    open func respondToSwipe(like: Bool, opacity: Float) {
    }
    
    /**
     Should contain logic to reset the view to its initial, visual state. 
     This is for example called when a card is released, and snaps back to the center of the view.
     */
    open func resetView() {
    }
    
    /**
     This is being fired when a view is 'dimissed' from the stack.
     For example when it has been swiped away and left the view.
     */
    open func respondToDismiss() {
    }
    /**
     Set the data this SwipableView is a representation of.
     - parameter data: The data it is meant to represent.
     
     */
    open func setData(_ data: SwipableData) {
        self.data = data
    }
    
    /**
     Get the data this SwipableView is a representation of.
     - returns: The data it is meant to represent.
     
     */
    open func getData() -> SwipableData? {
        return data
    }
    
    /**
     Should return whether or not the user is to be allowed to undo swiping this card.
     */
    open func isUndoable() -> Bool {
        return true
    }
}
