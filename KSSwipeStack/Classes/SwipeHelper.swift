//
//  SwipeHelper.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2016-09-27.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import Foundation
import UIKit

class SwipeHelper {
    private let swipeViewSize: CGSize
    private let swipeViewCenter: CGPoint
    open var options = SwipeOptions()
    
    init(with frame: CGRect) {
        swipeViewSize = frame.size
        swipeViewCenter = CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
  
    /// Move and animate a view to a desired position
    ///
    /// - Parameters:
    ///   - card: The view to be move
    ///   - duration: The duration of the animation
    ///   - toPoint: Destination of the move action
    func move(_ card: UIView, duration: Double = 0.25, toPoint: CGPoint) {
        move(card, duration: duration, toPoint: toPoint, completion: {})
    }
    
    /// Move and animate a view to a desired position
    ///
    /// - Parameters:
    ///   - card: The view to be move
    ///   - duration: The duration of the animation
    ///   - toPoint: Destination of the move action
    ///   - completion: Callback fireing when the animation is done and the view is moved.
    func move(_ card: UIView, duration: Double = 0.25, toPoint: CGPoint, completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            card.frame = CGRect(origin: toPoint, size: card.frame.size)
            card.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
    /// Move and animate a view to a desired position,
    /// transforming the view according to the current SwipeOptions
    /// Uses dismissAnimationDuration set in SwipeOptions
    /// - Parameters:
    ///   - card: The view to be move
    ///   - toPoint: Destination of the move action
    ///   - completion: Callback fireing when the animation is done and the view is moved.
    
    func moveFastAndTransform(_ card: SwipableView, toPoint: CGPoint, completion: @escaping () -> Void) {
        addBorderToCard(card)
        
        let rotation = self.calculateRotationAnimation(cardCenter: toPoint)
        let scale = self.calculateScaleAnimation(cardCenter: toPoint)
        
        card.respondToSwipe(like: toPoint.x > 0, opacity: toPoint.equalTo(swipeViewCenter) ? 0.0 : 1.0)
        UIView.animate(withDuration: options.dismissAnimationDuration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            card.center = toPoint
            card.layer.transform = CATransform3DConcat(rotation, scale)
            card.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
    
    /// Calculate the magnitude if a throw based on the velocity vector
    /// Used when determining if a card has been thrown 'hard enough' to be dismissed.
    /// - Parameter velocity: velocity vector of the gesture
    /// - Returns: magnitude of the throw
    func calculateThrowMagnitude(for velocity: CGPoint ) -> Float {
        let velXSq = Float(velocity.x) * Float(velocity.x)
        let velYSq = Float(velocity.y) * Float(velocity.y)
        return sqrtf(velXSq + velYSq)
    }
    
    /// Returns a view to its original visual state in regards to border, rotation and scale.
    /// Animates the reset of the view
    /// - Parameter card: View to reset
    func resetCard(_ card: UIView) {
        let rotation = CATransform3DMakeRotation(0, 0, 0, 1)
        let scale = CATransform3DMakeScale(1.0, 1.0, 1.0)
        
        let borderAnim = CABasicAnimation(keyPath: "borderWidth")
        borderAnim.fromValue = card.layer.borderWidth
        borderAnim.toValue = 0
        borderAnim.duration = 0.1
        card.layer.borderWidth = 0
        
        let cornerAnim = CABasicAnimation(keyPath: "cornerRadius")
        cornerAnim.fromValue = card.layer.cornerRadius
        cornerAnim.toValue = 0
        cornerAnim.duration = 0.1
        card.layer.cornerRadius = 0
        
        let both = CAAnimationGroup()
        both.duration = 0.1
        both.animations = [cornerAnim, borderAnim]
        both.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        card.layer.add(both, forKey: "both")
        
        UIView.animate(withDuration: 0.1) {
            card.layer.transform = CATransform3DConcat(rotation, scale)
        }
    }

    /// Tranforms a view based on the preferences set in SwipeOptions
    ///
    /// - Parameter card: View to tranform
    func transformCard(_ card: SwipableView) {
        let rotation = calculateRotationAnimation(cardCenter: card.center)
        let scale = calculateScaleAnimation(cardCenter: card.center)
        card.layer.transform = CATransform3DConcat(rotation, scale)
        addBorderToCard(card)
    }
    
    func addBorderToCard(_ card: UIView) {
        card.layer.borderWidth = 10
        card.layer.borderColor = UIColor.white.cgColor
        card.layer.cornerRadius = 10
        card.layer.masksToBounds = true
    }
    
    private func calculateScaleAnimation(cardCenter: CGPoint) -> CATransform3D {
        let horizontalDistance = calculateHorizontalDistanceFromCenter(cardCenter)
        let verticalDistance = calculateVerticalDistanceFromCenter(cardCenter)
        
        var scaleFactor = CGFloat(0)
        if horizontalDistance >= verticalDistance {
            scaleFactor = CGFloat(1 - horizontalDistance / 800.0)
        } else {
            scaleFactor = CGFloat(1 - verticalDistance / 1600.0)
        }
        return CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0)
    }
    
    private func calculateRotationAnimation(cardCenter: CGPoint) -> CATransform3D {
        let xFromCenter = Double(cardCenter.x - swipeViewSize.width / 2)
        var rads = CGFloat(xFromCenter/10.0 * .pi / 180.0)
        if abs(rads) > 1.4 {
            rads = -rads
        }
        return CATransform3DMakeRotation(rads, 0, 0, 1)
    }
    
    /// Calculates the distance in the horizontal plane from the position of a view to the center of the screen
    ///
    /// - Parameter cardCenter: A positonal coordinate, preferably the center of a view.
    /// - Returns: The horizontal distance from the center of the screen
    private func calculateHorizontalDistanceFromCenter(_ cardCenter: CGPoint) -> Double {
        return Double(abs(cardCenter.x - swipeViewSize.width / 2))
    }
    
    /// Calculates the distance in the vertical plane from the position of a view to the center of the screen
    ///
    /// - Parameter cardCenter: A positonal coordinate, preferably the center of a view.
    /// - Returns: The vertical distance from the center of the screen
    private func calculateVerticalDistanceFromCenter(_ cardCenter: CGPoint) -> Double {
        return Double(abs(cardCenter.y - swipeViewSize.height / 2))
    }
    
    /// Calculate a proper destination for a dismissal of a view based on its position
    /// Places the view far to the left if the view is to the left the the center of the screen and vice versa.
    /// - Parameter card: View which endpoint to calculate
    /// - Returns: Proper destination for the view
    func calculateEndpoint(_ card: UIView) -> CGPoint {
        let deltaX = card.center.x - swipeViewSize.width / 2
        let deltaY = card.center.y - swipeViewSize.height / 2
        
        let k = deltaY / deltaX
        let toX = deltaX < 0 ? -swipeViewSize.height / 2 : swipeViewSize.width + swipeViewSize.height / 2
        return CGPoint(x: toX, y: toX * k)
    }
    
    /// Calculate a proper destination for a dismissal of a view based on current velocity
    /// Places the view far to the left if the view is currently moving to the left and vice versa.
    /// The angle from the center to the proposed destination of the view is based on the angle of the velocity vector
    /// - Parameter card: View which endpoint to calculate
    /// - Returns: Proper destination for the view
    func calculateEndpoint(_ card: UIView, basedOn velocity: CGPoint) -> CGPoint {
        let k = velocity.y / velocity.x
        let toX = velocity.x < 0 ? -swipeViewSize.height / 2 : swipeViewSize.width + swipeViewSize.height / 2
        return CGPoint(x: toX, y: toX * k)
    }
    
    /// Converts a position with coordinates with the origin of the screen as origo to one using the center of the screen as origo.
    /// Can be used to convert a origin value to a center value refering to the same positioning of a full screen view.
    /// - Parameter center: Position using origin as origo
    /// - Returns: Position with coordinates using center as origo
    func convertToCenter(origin: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x + swipeViewSize.width / 2, y: origin.y + swipeViewSize.height / 2)
    }
}
