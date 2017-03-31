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

class ViewController: UIViewController {
    
    @IBOutlet var swipeView: SwipeView!
    
    private var disposableBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeView.setup(options: SwipeOptions(), swipeDelegate: self)
        
        for _ in 1...15 {
            swipeView.addCard(ExampleData())
        }
        
        swipeView.getSwipes().subscribe(onNext: { (swipe) in
            print("RX SWIPE EVENT")
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposableBag)
        
        swipeView.needsRefill().subscribe(onNext: { (swipe) in
            print("RX REFILL EVENT")
        }, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposableBag)
        
    }
}

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

class ExampleData: SwipableData {
    func getView() -> SwipableView {
        let view = ExampleCard()
        view.setData(self)
        return view
    }
}

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

