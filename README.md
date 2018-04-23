# InfiniteViewSlider
[![CI Status](http://img.shields.io/travis/draupnir45/InfiniteViewSlider.svg?style=flat)](https://travis-ci.org/draupnir45/InfiniteViewSlider)
[![Version](https://img.shields.io/cocoapods/v/InfiniteViewSlider.svg?style=flat)](http://cocoapods.org/pods/InfiniteViewSlider)
[![License](https://img.shields.io/cocoapods/l/InfiniteViewSlider.svg?style=flat)](http://cocoapods.org/pods/InfiniteViewSlider)
[![Platform](https://img.shields.io/cocoapods/p/InfiniteViewSlider.svg?style=flat)](http://cocoapods.org/pods/InfiniteViewSlider)

## Description
Easy-to-use Infinite Paging ScrollView.

## Usage

```swift
let slider = InfiniteViewSlider(frame: ... )

slider.viewArray = [subView1, subView2]
slider.isAutoSlideEnabled = true
slider.slideTimeInterval = 1.0

view.addSubView(slider)

```


## Screenshot

<img src="/screenshot.gif" width = 50%> 

## Example

To run the example project execute `pod try 'InfiniteViewSlider'` from terminal.

## Requirements
- Swift 4.1
- iOS 9.0

## Installation

InfiniteViewSlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InfiniteViewSlider'
```

## Author

Jongchan Park, draupnir45@gmail.com

## License

InfiniteViewSlider is available under the MIT license. See the LICENSE file for more info.
