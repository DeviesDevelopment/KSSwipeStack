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
[SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift) is the container of the swipe stack. 

1. Add a [SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift) to your Storyboard/nib and create an outlet for it.

2. Run setup on said [SwipeView](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeView.swift), using one of the provided `setup` methods.  
- The simplest form takes no arguments:
```swift
swipeView.setup()
```
_____
- You can also use the setup method which takes a [SwipeOptions](#options) as argument in order to modify the behavior of the stack. See the [Options](#options) section for further details on how to use SwipeOptions.

```swift
var swipeOptions = SwipeOptions()
swipeOptions.allowVerticalSwipes = true

swipeView.setup(options: swipeOptions)
```
_____
- Finally you can pass along a [SwipeDelegate](#using-swipedelegate) reference (if you don't want to use RxSwift), either by itself:
```swift
swipeView.setup(swipeDelegate: self)
```
_____
- ...or together with some custom SwipeOptions:
```swift
swipeView.setup(swipeOptions: swipeOptions, swipeDelegate: self)
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
func getView(with frame: CGRect) -> SwipableView {
    let view = ExampleCard(frame: frame)
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
#### Using [RxSwift](https://github.com/ReactiveX/RxSwift)
You can observe all swipe events coming from the stack using RxSwift by simply setting up an observer.
```swift
swipeView.getSwipes().subscribe(onNext: { (swipe) in
    print("RX SWIPE EVENT")
}, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposableBag)
```

You can also observe if the stack needs a refill based on the refill threshold provided in [SwipeOptions](#options).
```swift
swipeView.needsRefill().subscribe(onNext: { (swipe) in
    print("RX REFILL EVENT")
}, onError: nil, onCompleted: nil, onDisposed: nil).addDisposableTo(disposableBag)
```

#### Using [SwipeDelegate](https://github.com/Kicksort/KSSwipeStack/KSSwipeStack/Classes/SwipeDelegate.swift)
When setting up the SwipeView you can provide a Class implementing SwipeDelegate to handle the swipes received from the stack.
```swift

swipeView.setup(options: SwipeOptions(), swipeDelegate: self)

extension ViewController: SwipeDelegate {
    func onNext(_ swipe: Swipe) {
        dump("DELEGATE SWIPE EVENT")
    }
}
```

## Extras

### Undo swipe
Call the `undoSwipe()` method in order to move the latest swiped card back to the stack. You can call the method any number of times in order to go back additional steps through the swipe history. Note that this feature can be disabled by setting `allowUndo` in SwipeOptions to false.
```swift
swipeView.undoSwipe()
```

If you want to prevent a specific card from being added to the swipe history (and therefore skipped when calling `undoSwipe()`), you should override `isUndoable()` for that SwipableView and return false.

## Options
Using the SwipeOptions struct you can modify the behavior ot the swipe stack.
```swift
public struct SwipeOptions {
    public var throwingThreshold = Float(800)
    public var snapDuration = 0.1
    public var allowHorizontalSwipes = true
    public var allowVerticalSwipes = false
    public var horizontalPanThreshold = CGFloat(0.5)
    public var verticalPanThreshold = CGFloat(0.5)
    public var visibleImageOrigin = CGPoint(x: 0, y: 0)
    public var allowUndo = true
    public var maxRenderedCards = 5
    public var refillThreshold = 10
    public var dismissAnimationDuration = 0.25
    public var freezeWhenDismissing = false
    
    public init(){}
}
```
Specifying how 'hard' you have to throw a card for it to be dismissed.
```swift
public var throwingThreshold = Float(800)
```
Duration of the snap-back animation
```swift
public var snapDuration = 0.1
```
Make the swipe stack respond to horizontal swipes.
```swift
public var allowHorizontalSwipe = true
```
Make the swipe stack respond to vertical swipes.
```swift
public var allowVerticalSwipe = false
```
X-axis threshold for if a card is dismissed upon release.
```swift
public var horizontalPanThreshold = CGFloat(0.5)
```
Origin of a card in the 'original' state.
```swift
public var visibleImageOrigin = CGPoint(x: 0, y: 0)
```
Allow undoing of swipes.
```swift
public var allowUndo = true
```
How many cards should be rendered in the SwipeView at the same time.
```swift
public var maxRenderedCards = 5
```
Threshold of when a refill event is sent to refill subscribers.
```swift
public var refillThreshold = 10
```
Duration of the dismiss animation.
```swift
public var dismissAnimationDuration = 0.25
```
You can optionally choose to freeze the stack as a card is being dismissed to prevent the user from swiping 
```swift
public var freezeWhenDismissing = false
```

## Authors

[arneson](https://github.com/arneson), Simon Arneson, arneson@kicksort.se

[Sundin](https://github.com/Sundin), Gustav Sundin, gustav@kicksort.se

## License

KSSwipeStack is available under the MIT license. See the LICENSE file for more info.
