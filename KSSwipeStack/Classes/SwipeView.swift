//
//  SwipeView.swift
//  KSSwipeStack
//
//  Created by Simon Arneson on 2017-03-24.
//  Copyright © 2017 Kicksort Consulting AB. All rights reserved.
//

import UIKit
import RxSwift

public class SwipeView: UIView {
    private var swipeHelper = SwipeHelper()
    private var horizontalPan: PanDirectionGestureRecognizer?
    fileprivate var dataset: [SwipableData] = []
    fileprivate var renderedCards: [SwipableView] = []
    fileprivate var previousCard: SwipableView?
    fileprivate var options = SwipeOptions()
    
    fileprivate var swipeDelegate: SwipeDelegate?
    fileprivate var swipeSubject: PublishSubject<Swipe>?
    fileprivate var refillSubject: PublishSubject<Swipe>?
    
    public func setup(options: SwipeOptions?, swipeDelegate: SwipeDelegate?) {
        if let swipeOptions = options {
            self.options = swipeOptions
            swipeHelper.options = swipeOptions
        }
        
        if let swipeDelegate = swipeDelegate {
            self.swipeDelegate = swipeDelegate
        }
        
        horizontalPan = PanDirectionGestureRecognizer(direction: .Horizontal, target: self, action: #selector(respondToHorizontalPan))
        if let horizontalPan = horizontalPan {
            addGestureRecognizer(horizontalPan)
        }
    }
    
    public func addCard(_ data: SwipableData) {
        dataset.append(data)
        notifyDatasetUpdated()
    }
    
    public func addCardToTop(_ data: SwipableData) {
        let renderedCard = renderCard(data.getView())
        renderedCards.insert(renderedCard, at: 0)
        addSubview(renderedCard)
        bringSubview(toFront: renderedCard)
    }
    
    public func getSwipes() -> Observable<Swipe> {
        if let swipeSubject = swipeSubject {
            return swipeSubject.asObserver()
        }
        swipeSubject = PublishSubject<Swipe>()
        return getSwipes()
    }
    
    public func needsRefill() -> Observable<Swipe> {
        if let refillSubject = refillSubject {
            return refillSubject.asObserver()
        }
        refillSubject = PublishSubject<Swipe>()
        return needsRefill()
    }
    
    fileprivate func setupSwipeCards() {
        
    }
    
    fileprivate func getCurrentCard() -> SwipableView? {
        return renderedCards.first
    }
    
    public func notifyDatasetUpdated() {
        if self.renderedCards.count < options.maxRenderedCards, !dataset.isEmpty {
            fillStack()
        }
    }
    
    private func fillStack() {
        let card = renderCard(dataset.removeFirst().getView())
        self.renderedCards.append(card)
        if self.renderedCards.count < options.maxRenderedCards, !dataset.isEmpty {
            fillStack()
        }
    }
    
    func renderCard(_ view: SwipableView) -> SwipableView {
        if !renderedCards.isEmpty, let lastCard = renderedCards.last {
            insertSubview(view, belowSubview: lastCard)
        } else {
            addSubview(view)
            sendSubview(toBack: view)
        }
        return view
    }
    
    func showNextCard() {
        if !renderedCards.isEmpty {
            let swipedCard = renderedCards.removeFirst()
            self.isUserInteractionEnabled = true
            swipedCard.removeFromSuperview()
            swipedCard.respondToDismiss()
        }
        
        if self.renderedCards.count < options.maxRenderedCards, !dataset.isEmpty {
            fillStack()
        }
        
        isUserInteractionEnabled = true
    }
    
    @objc func respondToHorizontalPan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        let magnitude = swipeHelper.calculateThrowMagnitude(for: velocity)
        
        if let card = getCurrentCard(){
            let previousOrigin = card.frame.origin
            let nextOrigin = CGPoint(x: self.frame.origin.x + translation.x, y: self.frame.origin.y + translation.y)
            card.center = CGPoint(x: options.screenSize.width/2 + translation.x, y: options.screenSize.height/2 + translation.y)
            swipeHelper.transformCard(card)
            
            let opacity = abs(Float(card.center.x.distance(to: self.center.x).divided(by: options.screenSize.width.divided(by: 4))))
            card.respondToSwipe(like: translation.x > 0, opacity: opacity)
            
            if gesture.state == .ended {
                let throwingThresholdExceeded = magnitude > options.throwingThreshold
                let panThresholdExceeded = abs(nextOrigin.x) > options.screenSize.width * options.horizontalPanThreshold
                if throwingThresholdExceeded {
                    if velocity.x > 0 {
                        respondToSwipe(.right, gesture: gesture)
                    } else {
                        respondToSwipe(.left, gesture: gesture)
                    }
                } else if panThresholdExceeded {
                    if previousOrigin.x < options.visibleImageOrigin.x {
                        respondToSwipe(.left, gesture: gesture)
                    } else {
                        respondToSwipe(.right, gesture: gesture)
                    }
                } else {
                    snapBack()
                }
            } else if gesture.state == .cancelled {
                snapBack()
            }
        }
    }
    
    func respondToSwipe(_ direction: SwipeDirection, gesture: UIGestureRecognizer) {
        guard let card = getCurrentCard() else {
            // TODO
            return
        }
        
        previousCard = card.isUndoable() ? card : nil
        
        dismissCard(toPoint: options.rightStackOrigin, gesture: gesture, completion: { [weak self] in
            let swipe = Swipe(direction: direction, data: card.getData())
            if let swipeHandler = self?.swipeDelegate {
                swipeHandler.onNext(swipe)
            }
            if let swipeSubject = self?.swipeSubject {
                swipeSubject.onNext(swipe)
            }
            if self?.needsRefill() ?? false, let refillSubject = self?.refillSubject {
                refillSubject.onNext(swipe)
            }
        })
    }
    
    func snapBack() {
        if let currentCard = getCurrentCard() {
            swipeHelper.resetCard(currentCard)
            swipeHelper.move(currentCard, duration: options.snapDuration, toPoint: options.visibleImageOrigin)
            currentCard.resetView()
        }
    }
    
    func getDataCount() -> Int {
        return self.renderedCards.count + self.dataset.count
    }
    
    func needsRefill() -> Bool {
        return getDataCount() <= options.refillThreshold
    }
    
    fileprivate func dismissCard(toPoint: CGPoint, gesture: UIGestureRecognizer?, completion: @escaping () -> Void) {
        guard let card = getCurrentCard() else {
            return
        }
        
        isUserInteractionEnabled = !options.freezeWhenDismissing
        
        var toPoint = swipeHelper.convertToCenter(origin: toPoint)
        if !(card.frame.origin.x == 0 && card.frame.origin.y == 0) {
            if card.center.x > options.screenSize.width / 2 {
                toPoint = swipeHelper.calculateEndpoint(card)
            } else if let gesture = gesture as? UIPanGestureRecognizer{
                let velocity = gesture.velocity(in: self)
                if !(velocity.x == 0 && velocity.y == 0) {
                    toPoint = swipeHelper.calculateEndpoint(card, basedOn: velocity)
                }
            }
        }
        
        swipeHelper.moveFastAndTransform(card, toPoint: toPoint, completion: {
            completion()
            self.showNextCard()
        })
    }

}
