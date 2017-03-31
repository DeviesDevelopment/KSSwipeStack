//
//  CardController.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2016-09-27.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import Foundation
import UIKit

class SwipeHelper {
    private let screenSize: CGSize = UIScreen.main.bounds.size
    private let screenCenter = CGPoint(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2)
    open var options = SwipeOptions()
    
    func move(_ card: UIView, duration: Double = 0.25, toPoint: CGPoint) {
        move(card, duration: duration, toPoint: toPoint, completion: {})
    }
    
    func move(_ card: UIView, duration: Double = 0.25, toPoint: CGPoint, completion: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            card.frame = CGRect(origin: toPoint, size: card.frame.size)
            card.layoutIfNeeded()
        }, completion: { _ in
            completion()
        }
        )
    }
    
    func moveFastAndTransform(_ card: SwipableView, toPoint: CGPoint, completion: @escaping () -> Void) {
        addBorderToCard(card)
        
        let rotation = self.calculateRotationAnimation(cardCenter: toPoint)
        let scale = self.calculateScaleAnimation(cardCenter: toPoint)
        
        card.respondToSwipe(like: toPoint.x > 0, opacity: toPoint.equalTo(screenCenter) ? 0.0 : 1.0)
        UIView.animate(withDuration: options.dismissAnimationDuration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            card.center = toPoint
            card.layer.transform = CATransform3DConcat(rotation, scale)
            card.layoutIfNeeded()
        }, completion: { _ in
            completion()
        }
        )
    }
    
    func calculateThrowMagnitude(for velocity: CGPoint ) -> Float {
        let velXSq = Float(velocity.x) * Float(velocity.x)
        let velYSq = Float(velocity.y) * Float(velocity.y)
        return sqrtf(velXSq + velYSq)
    }
    
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
        let scaleFactor = CGFloat(1-abs(calculateDistanceFromCenter(cardCenter))/800.0)
        return CATransform3DMakeScale(scaleFactor, scaleFactor, 1.0)
    }
    
    private func calculateRotationAnimation(cardCenter: CGPoint) -> CATransform3D {
        let xFromCenter = Double(cardCenter.x - self.screenSize.width / 2)
        var rads = CGFloat(xFromCenter/10.0 * .pi / 180.0)
        if abs(rads) > 1.4 {
            rads = -rads
        }
        return CATransform3DMakeRotation(rads, 0, 0, 1)
    }
    
    private func calculateDistanceFromCenter(_ cardCenter: CGPoint) -> Double {
        return Double(cardCenter.x - self.screenSize.width / 2)
    }
    
    func calculateEndpoint(_ card: UIView) -> CGPoint {
        let deltaX = card.center.x - screenSize.width / 2
        let deltaY = card.center.y - screenSize.height / 2
        
        let k = deltaY / deltaX
        let toX = deltaX < 0 ? -screenSize.height / 2 : screenSize.width + screenSize.height / 2
        return CGPoint(x: toX, y: toX * k)
    }
    
    func calculateEndpoint(_ card: UIView, basedOn velocity: CGPoint) -> CGPoint {
        let k = velocity.y / velocity.x
        let toX = velocity.x < 0 ? -screenSize.height / 2 : screenSize.width + screenSize.height / 2
        return CGPoint(x: toX, y: toX * k)
    }
    
    func convertToOrigin(center: CGPoint) -> CGPoint {
        return CGPoint(x: center.x - screenSize.width / 2, y: center.y - screenSize.height / 2)
    }
    
    func convertToCenter(origin: CGPoint) -> CGPoint {
        return CGPoint(x: origin.x + screenSize.width / 2, y: origin.y + screenSize.height / 2)
    }
}
