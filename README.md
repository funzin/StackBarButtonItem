# StackBarButtonItem
<p align="center">
    <img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Logo/logo.png alt="StackBarButtonItem" width="70%" />
</p>

<p align="center">
  <img src="http://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform" />
  <a href="https://developer.apple.com/swift">
    <img src="http://img.shields.io/badge/Swift-4.2-brightgreen.svg?style=flat" alt="Language">
  </a>
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage" />
  </a>
  <br />
  <a href="https://cocoapods.org/pods/StackBarButtonItem">
    <img src="https://img.shields.io/cocoapods/v/StackBarButtonItem.svg?style=flat" alt="Version" />
  </a>
  <a href="https://cocoapods.org/pods/StackBarButtonItem">
    <img src="https://img.shields.io/cocoapods/l/StackBarButtonItem.svg?style=flat" alt="License" />
  </a>
</p>

StackBarButtonItem can use BarButtonItem like stackView.


## Features
- NavigationBar margin 
- Spacing between view
- Reverse view 

## Support
- Device: iPad | iPhone
- Orientation: Portrait | Landscape
- Multitasking

## Requirements
- Xcode10 or greater
- iOS9 or greater
- Swift4.2
  
## Dependencies
- [RxSwift](https://github.com/ReactiveX/RxSwift) (>= 4.3.1)
- [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa) (>= 4.3.1)

## Installation
### Carthage

If you’re using [Carthage](https://github.com/Carthage/Carthage), simply add
StackBarButtonItem to your `Cartfile`:

```ruby
github "funzin/StackBarButtonItem"
```

### CocoaPods
StackBarButtonItem is available through [CocoaPods](https://cocoapods.org). To instal
it, simply add the following line to your Podfile:

```ruby
pod 'StackBarButtonItem'
```

## Usage
### Correspondence Table
|position|Default|StackBarButtonItem|
|:-:|:-:|:-:|
|right|`navigationItem.setRightBarButtonItems`|`navigationItem.right.setStackBarButtonItems`|
|left|`navigationItem.setLeftBarButtonItems`|`navigationItem.left.setStackBarButtonItems`|

### Introduction
#### iOS11 or later
If iOS version is iOS11 or later, you must use autolayout.
```swift
import StackBarButtonItem
・
・
・

// use autolayout
let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
NSLayoutConstraint.activate([
    rightButton.widthAnchor.constraint(equalToConstant: 44),
    rightButton.heightAnchor.constraint(equalToConstant: 44)
])
self.navigationItem.right.setStackBarButtonItems(views: [rightButton])
```

#### iOS9 or iOS10
If iOS version is iOS9 or iOS10, you must configure frame.
```swift
import StackBarButtonItem
・
・
・

// configure frame
let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
self.navigationItem.right.setStackBarButtonItems(views: [rightButton])
```

### Margin
```swift
// e.g. set margin to 10
self.navigationItem.right.setStackBarButtonItems(views: [rightButton], margin: 10)
```

#### Example
|Margin|ScreenShot|
|:-:|:-:|
|`margin == 0`|<img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Screenshot/Margin/margin_0.png width=600>|
|`margin == 10`|<img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Screenshot/Margin/margin_10.png width=600>|
    
### Spacing
```swift
// e.g. set spacing to 10
self.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2], spacing: 10)
```

#### Example
|Spacing|ScreenShot|
|:-:|:-:|
|`spacing == 0`|<img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Screenshot/Spacing/spacing_0.png width=600>|
|`spacing == 10`|<img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Screenshot/Spacing/spacing_10.png width=600>|

### Reverse
```swift
// e.g. set reversed to true
self.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2], reversed: true)
```

#### Example
|Reverse|ScreenShot|
|:-:|:-:|
|`reversed == false`|<img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Screenshot/Reverse/reversed_false.png width=600>|
|`reversed == true`|<img src=https://github.com/funzin/StackBarButtonItem/blob/master/Resources/Screenshot/Reverse/reversed_true.png width=600>|

## Demo
If you are interested in StackBarButtonItem, please check demo after `carthage update`

## Author
funzin, nakazawa.fumito@gmail.com
## License
StackBarButtonItem is available under the MIT license. See the [LICENSE file](https://github.com/funzin/StackBarButtonItem/blob/master/LICENSE) for more info.
