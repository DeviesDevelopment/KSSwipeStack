<p align="center">
  <img src="http://kicksort.se/img/logo.png" alt="Kicksort" width="300"/>
</p>

# KSSwipeStack

[![CI Status](http://img.shields.io/travis/scanniza/KSSwipeStack.svg?style=flat)](https://travis-ci.org/scanniza/KSSwipeStack)
[![Version](https://img.shields.io/cocoapods/v/KSSwipeStack.svg?style=flat)](http://cocoapods.org/pods/KSSwipeStack)
[![License](https://img.shields.io/cocoapods/l/KSSwipeStack.svg?style=flat)](http://cocoapods.org/pods/KSSwipeStack)
[![Platform](https://img.shields.io/cocoapods/p/KSSwipeStack.svg?style=flat)](http://cocoapods.org/pods/KSSwipeStack)

KSSwipeStack is a lightweight card swiping library for iOS written in Swift. 

KSSwipeStack handles any data model and the design/layout of the swipe cards are completely customizable.

Using the options provided you can customize the behavior and animations used in the swipe stack.

<p align="center">
  <img src="https://media.giphy.com/media/w8BnmsjcJyFKU/giphy.gif" alt="Example GIF" width="270" height="480"/>
</p>

## Features

Built-in support for:
- [Custom Views](https://github.com/Kicksort/KSSwiftStack#Create-a-custom-class-extending-SwipableView)
- [Custom data model](https://github.com/Kicksort/KSSwiftStack#Create-a-simple-data-model-implementing-the-protocol-SwipableData)
- [Delegate pattern](https://github.com/Kicksort/KSSwiftStack#Using-SwipeDelegate)
- [RxSwift observables](https://github.com/Kicksort/KSSwiftStack#Using-RxSwift)

## Example

To run the [example project](https://github.com/Kicksort/KSSwiftStack/Example/), clone the repo, and run `pod install` from the Example directory first.

## Installation

KSSwipeStack is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KSSwipeStack"
```

## Getting started

### Create a [SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift)
[SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift#) is the container of the swipe stack. 

Add a [SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift) to your Storyboard/nib and create an outlet for it.

Run setup on said [SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift). The setup method takes a [SwipeOptions](https://github.com/Kicksort/KSSwiftStack#options) parameter which you can use to modify the behavior of the stack.

```swift
swipeView.setup(options: SwipeOptions(), swipeDelegate: nil)
```

### Create a custom class extending [SwipableView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipableView.swift)
Styled to properly represent on item of your data. 

```swift
class ExampleCard: SwipableView {

    override func setData(_ data: SwipableData) {
        super.setData(data)
        backgroundColor = .kicksortGray
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width - 100, height: 200))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "kicksortLogoInverted")
        imageView.center = center
        addSubview(imageView)
    }
}
```

### Create a simple data model implementing the protocol [SwipableData](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipableData.swift). 
The protocol contains only one method, getView, in which you need to return a [SwipableView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipableView.swift).
```swift
func getView() -> SwipableView {
    let view = ExampleCard()
    view.setData(self)
    return view
}
```

### Add cards to the stack
You can add any number of cards of any number of different types to the same stack. 
You add a card by simply calling addCard with a parameter implementing [SwipableData](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipableData.swift).
```swift
swipeView.addCard(ExampleData())
```

### Handle swipes
### Using [RxSwift](https://github.com/ReactiveX/RxSwift)
You can observe all swipe events coming from the stack using RxSwift by simply setting up an observer.
```swift
swipeView.getSwipes().subscribe(onNext: { (swipe) in
    print("RX SWIPE EVENT")
}, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposableBag)
```

You can also observe if the stack needs a refill based on the refill threshold provided in [SwipeOptions](https://github.com/Kicksort/KSSwiftStack#options).
```swift
swipeView.needsRefill().subscribe(onNext: { (swipe) in
    print("RX REFILL EVENT")
}, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposableBag)
```

### Using [SwipeDelegate](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeDelegate.swift)
When setting up the SwipeView you can provide a Class implementing SwipeDelegate to handle the swipes received from the stack.
```swift

swipeView.setup(options: SwipeOptions(), swipeDelegate: self)

extension ViewController: SwipeDelegate {
    func onNext(_ swipe: Swipe) {
        dump("DELEGATE SWIPE EVENT")
    }
}
```

### Options
Using the SwipeOptions struct you can modify the behavior ot the swipe stack.
```swift
public struct SwipeOptions {
    let throwingThreshold = Float(800)
    let snapDuration = 0.1
    let horizontalPanThreshold = CGFloat(0.5)
    let screenSize: CGSize = UIScreen.main.bounds.size
    let visibleImageOrigin = CGPoint(x: 0, y: 0)
    let rightStackOrigin = CGPoint(x: UIScreen.main.bounds.size.width * 2, y: 0)
    let leftStackOrigin = CGPoint(x: -UIScreen.main.bounds.size.width * 2, y: 0)
    let allowUndo = true
    var maxRenderedCards = 5
    var refillThreshold = 10
    var dismissAnimationDuration = 0.25
    var freezeWhenDismissing = false
    
    public init(){}
}
```
Specifying how 'hard' you have to throw a card for it to be dismissed.
```swift
let throwingThreshold = Float(800)
```
Duration of the snap-back animation
```swift
let snapDuration = 0.1
```
X-axis threshold for if a card is dismissed upon release.
```swift
let horizontalPanThreshold = CGFloat(0.5)
```
Size of the view containing the SwipeView
```swift
let screenSize: CGSize = UIScreen.main.bounds.size
```
Origin of a card in the 'original' state.
```swift
let visibleImageOrigin = CGPoint(x: 0, y: 0)
```
Where dismissed cards visually end up if dismissed to the right.
```swift
let rightStackOrigin = CGPoint(x: UIScreen.main.bounds.size.width * 2, y: 0)
```
Where dismissed cards visually end up if dismissed to the left.
```swift
let leftStackOrigin = CGPoint(x: -UIScreen.main.bounds.size.width * 2, y: 0)
```
Allow undoing of swipes.
```swift
let allowUndo = true
```
How many cards should be rendered in the SwipeView at the same time.
```swift
var maxRenderedCards = 5
```
Threshold of when a refill event is sent to refill subscribers.
```swift
var refillThreshold = 10
```
Duration of the dismiss animation.
```swift
var dismissAnimationDuration = 0.25
```
You can optionally choose to freeze the stack as a card is being dismissed to prevent the user from swiping 
```swift
var freezeWhenDismissing = false
```

## Authors

[arneson](https://github.com/arneson), Simon Arneson, arneson@kicksort.se

[Sundin](https://github.com/Sundin), Gustav Sundin, gustav@kicksort.se

## License

KSSwipeStack is available under the MIT license. See the LICENSE file for more info.
