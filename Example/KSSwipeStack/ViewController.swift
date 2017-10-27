//
//  ViewController.swift
//  KSSwipeStack
//
//  Created by arneson on 03/24/2017.
//  Copyright (c) 2017 Kicksort Consulting AB. All rights reserved.
//

import UIKit
import KSSwipeStack
import RxSwift

/// Example ViewController to demonstrate the functionality of the Kicksort Swipe Stack
/// The example has a fullscreen SwipeView which is the container of the stack of views (cards, if you will)
/// It then generates 15 items of example data and adds them to the SwipeView
class ViewController: UIViewController {
    
    @IBOutlet var swipeView: SwipeView!
    
    private var disposableBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // (Optional step) create a SwipeOptions object and customize any settings you want
        var swipeOptions = SwipeOptions()
        swipeOptions.allowVerticalSwipes = true
        
        // Sets up the SwipeView (the container for the stack) using SwipeOptions object and (Optional step) adds this class as a delegate to handle events
        swipeView.setup(options: swipeOptions, swipeDelegate: self)
        
        for _ in 1...15 {
            swipeView.addCard(ExampleData())
        }
        
        // (Optional) Subscribes to events fired by the swipe view using RxObservables
        swipeView.getSwipes().subscribe(onNext: { swipe in
            print("RX SWIPE EVENT: \(swipe.direction)")
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposableBag)
        
        swipeView.needsRefill().subscribe(onNext: { swipe in
            print("RX REFILL EVENT")
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposableBag)
        
    }
}

/// Example implementation of the data protocol, a representation of the data you wish to swipe in the stack, ex. users, concerts etc.
/// This will be the data return by a successful swipe.
class ExampleData: SwipableData {
    func getView() -> SwipableView {
        let view = ExampleCard()
        view.setData(self)
        return view
    }
}

/// The visual representation of the ExampleData, the view which is rendered in the stack to represent a piece of data.
///
class ExampleCard: SwipableView {

    override func setData(_ data: SwipableData) {
        super.setData(data)
        backgroundColor = .kicksortGray
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width - 100, height: 200))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "kicksortLogoInverted")
        imageView.center = CGPoint(x: center.x, y: center.y - 50)
        addSubview(imageView)
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width - 100, height: 100))
        title.center = CGPoint(x: center.x, y: center.y + 50)
        title.text = "Swipe Stack"
        title.textColor = .kicksortPink
        title.textAlignment = .center
        title.numberOfLines = 3
        title.font = UIFont(name: "HarabaraMaisBold-HarabaraMaisBold", size: 30)
        addSubview(title)
    }
}
/// Implementation of the SwipeDelegate protocol
/// Implement this to handle events from the SwipeView using the delegate pattern.
extension ViewController: SwipeDelegate {
    func onNext(_ swipe: Swipe) {
        dump("DELEGATE SWIPE EVENT")
    }
}

extension UIColor {
    public static var kicksortGray: UIColor {
        get {
            return UIColor(hex: 0x333333)
        }
    }
    public static var kicksortPink: UIColor {
        get {
            return UIColor(hex: 0xea1e63)
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

