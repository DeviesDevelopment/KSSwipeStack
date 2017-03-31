//
//  PanDirectionGestureRecognizer.swift
//  KSSwipeStack
//
//  Created by Gustav Sundin on 26/09/16.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//
//  See http://stackoverflow.com/a/30607392/948942
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

public enum PanDirection {
    case Vertical
    case Horizontal
}

public class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    let direction: PanDirection
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            guard let view = self.view else {
                return
            }
            
            let v = velocity(in: view)
            switch direction {
            case .Horizontal where fabs(v.y) > fabs(v.x):
                state = .cancelled
            case .Vertical where fabs(v.x) > fabs(v.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}
