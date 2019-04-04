<p align="center">
  <img src="https://github.com/mixable/TouchPopMenu/raw/master/TouchPopMenu-icon.png" width="140" />
</p>

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

# TouchPopMenu
A touchable popover menu for iOS made in Swift.

## Installation

...

## Example usage

...

## Configuration and customization

### Properties

Configuration properties:

* [.position](#property-position)

Dimensions:

* [.arrowLength](#property-arrowlength)
* [.cornerRadius](#property-cornerradius)
* [.labelHeight](#property-labelheight)
* [.labelInset](#property-labelinset)
* [.screenInset](#property-screeninset)

Color customization:

* [.dividerColor](#property-dividercolor)
* [.menuColor](#property-menucolor)
* [.overlayColor](#property-overlaycolor)
* [.selectedColor](#property-selectedcolor)
* [.textColor](#property-textcolor)

Animation:

* [.animationDuration](#property-animationduration)
* [.animationOffset](#property-animationoffset)


#### Property `.position`

Type: `TouchPopMenu.Position`

Default: `.auto`

Defines the position of the menu related to the source view.
Normall it should be enough to use the main directions `.left`, `.up`, `.right` and `.down` to define the position of the menu. For those, the menu position will be automatically adjusted if it is close to the screen bounds. If you use the more precise positions (`.leftUp`, `.leftDown`, ...) this adjustment is not performed. In this case you need to make sure, that the menu size fits into the screen.

Value | Description
--- | ---
`.auto` | Automatically set the position of the menu related to the source view **(default)**
`.left` | Show menu on the **left** of the source view
`.up` | Show menu **above** the source view
`.right` | Show menu on the **right** of the source view
`.down` | Show menu **below** the source view
`.leftUp` | Show menu on the **left** of the source view, directed **up**
`.leftDown` | Show menu on the **left** of the source view, directed **down**
`.upLeft` | Show menu **above** the source view, directed to the **left**
`.upRight` | Show menu **above** the source view, directed to the **right**
`.rightUp` | Show menu on the **right** of the source view, directed **up**
`.rightDown` | Show menu on the **right** of the source view, directed **down**
`.downLeft` | Show menu **below** the source view, directed to the **left**
`.downRight` | Show menu **below** the source view, directed to the **right**


#### Property `.arrowLength`

Type: `CGFloat`

Default: `15.0`

Size of the arrow triangle.


#### Property `.cornerRadius`

Type: `CGFloat`

Default: `10.0`

The corner radius of the menu content view.


#### Property `.labelHeight`

Type: `CGFloat`

Default: `40.0`

The height of the action labels.


#### Property `.labelInset`

Type: `CGFloat`

Default: `15.0`

The horizontal spacing of label text.


#### Property `.screenInset`

Type: `CGFloat`

Default: `8.0`

Space between menu and screen edges.


#### Property `.dividerColor`

Type: `UIColor`

Default: `UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)`

The color of the menu action divider.


#### Property `.menuColor`

Type: `UIColor`

Default: `.white`

The background color of the menu content view.


#### Property `.overlayColor`

Type: `UIColor`

Default: `UIColor(white: 0.0, alpha: 0.05)`

The background color of the overlay view.


#### Property `.selectedColor`

Type: `UIColor`

Default: `UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)`

The background color of the selected action.


#### Property `.textColor`

Type: `UIColor`

Default: `.black`

The color of the action text.


#### Property `.animationDuration`

Type: `TimeInterval`

Default: `0.15`

The duration of the show/hide animations.


#### Property `.animationOffset`

Type: `CGFloat`

Default: `10.0`

Moving offset of the show/hide animations.
