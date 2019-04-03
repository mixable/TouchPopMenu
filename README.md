<p align="center">
  <img src="https://github.com/mixable/TouchPopMenu/raw/master/TouchPopMenu-icon.png" width="140" />
</p>

[![Swift 5.0](https://img.shields.io/badge/swift-5.0-red.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://opensource.org/licenses/MIT)

# TouchPopMenu
A touchable popover menu for iOS made in Swift.

# Installation

...

# Example usage

...

# Configuration and customization

## Properties

### Property `.position`
Type: `TouchPopMenu.Position`
Default: `.auto`

Defines the position of the menu related to the source view.
Normall it should be enough to use the main directions `.left`, `.up`, `.right` and `.down` to define the position of the menu. For those, the menu position will be automatically adjusted if it is close to the screen bounds. If you use the more precise positions (`.leftUp`, `.leftDown`, ...) this adjustment is not performed. In this case you need to make sure, that the menu size fits into the screen.

Value | Description
--- | ---
`.left` | Show menu on the **left** of the source view
`.up` | Show menu **above** the source view
`.right` | Show menu on the **right** of the source view
`.down` | Show menu **below** the source view
--- | ---
`.leftUp` | Show menu on the **left** of the source view, directed **up**
`.leftDown` | Show menu on the **left** of the source view, directed **down**
`.upLeft` | Show menu **above** the source view, directed to the **left**
`.upRight` | Show menu**above** the source view, directed to the **right**
`.rightUp` | Show menu on the **right** of the source view, directed **up**
`.rightDown` | Show menu on the **right** of the source view, directed **down**
`.downLeft` | Show menu **below** the source view, directed to the **left**
`.downRight` | Show menu**below** the source view, directed to the **right**
