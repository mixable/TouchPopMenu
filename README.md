<p align="center">
  <img src="https://github.com/mixable/TouchPopMenu/raw/master/TouchPopMenu-icon.png" width="140" />
</p>

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

# TouchPopMenu
A touchable popover menu for iOS made in Swift.

<p style="color:darkred">This library is still under development and not ready for use!</p>

## Installation
Using CocoaPods, add the pod to your podfile:
```
pod 'TouchPopMenu'
```

## Example usage
Below is a simple example how to attach TouchPopMenu to an UIButton. This also works with every other UIView.

```swift
// A source view to attach the menu
let myButton = UIButton()
myButton.setTitle("Touch Me", forState: .Normal)
myButton.frame = CGRectMake(0, 0, 100, 50)
self.view.addSubview(myButton)

// Create menu
let menu = TouchPopMenu(pointTo: myButton)
menu.position = .auto

// Add actions
menu.addAction(action: TouchPopMenuAction(title: "Copy", selected: nil))
menu.addAction(action: TouchPopMenuAction(title: "Paste", selected: nil))
menu.addAction(action: TouchPopMenuAction(title: "Undo last action", selected: nil))
```

TouchPopMenu handles all the touch events by its own. To manually show or hide the menu, you can use the following methods:

```swift
// Show or hide TouchPopMenu manually
menu.show()
menu.hide()
```

## Configuration and customization

For a full list of all properties and settings, please refer to the [wiki](https://github.com/mixable/TouchPopMenu/wiki/Configuration-and-customization).

## Changelog

...
