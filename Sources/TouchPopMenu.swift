class TouchPopMenu
{
  public enum Position {
    case auto
    case left
    case top
    case right
    case bottom
  }

  public enum Source {
    case view
    case button
    case barButtonItem
  }

  /*
   Position relative to source view
   */
  var position: Position = .auto

  /*
   Corner radius of menu content view
   */
  var cornerRadius: Double = 10.0

  /*
   Background color of the menu content view
   */
  var backgroundColor: CGColor = .lightgray

  /*
   Text color of the menu actions
   */
  var textColor: CGColor = .black

  /*
   Source to attach the menu
   */
  private var source : Source = .view
  
  private var sourceView : UIView
  private var sourceButton : UIButton
  private var sourceBarButtonItem : UIBarButtonItem

  /*
   Menu views
   */
  var menuView : UIView
  var menuDirectionView : UIView
  var menuContentView : UIView

  func init(for view: UIView)
  {
    source = .view
    sourceView = view
    
    initMenu()
  }
  
  func init(for button: UIButton)
  {
    source = .button
    sourceButton = button

    initMenu()
  }
  
  func init(for barButtonItem: UIBarButtonItem)
  {
    source = .barButtonItem
    sourceBarButtonItem = barButtonItem

    initMenu()
  }

  func initMenu()
  {
  }

  /*
   Frame of the source view
   */
  private var sourceFrame : CGRect {
    get {
      if source == .view {
        return sourceView.frame
      }      
      if source == .button {
        return sourceButton.frame
      }      
      if source == .barButtonItem {
        return sourceBarButtonItem.frame
      }      
    }
  }
  
  /*
   Center point of source view
   */
  private var sourceCenter: Point {
    get {
      let frame = sourceFrame
      return Point(x: frame.origin.x + frame.size.width / 2,
                   y: frame.origin.y + frame.size.height / 2)
    }
  }

  /*
   Calculated position
   */  
  private var menuPosition: Position {
    get {
      if position == .auto {
        // Calculate position of menu
        let screenSize = UIScreen.main.bounds
        if screenSize.width > screenSize.height {
          if sourceCenter.x < screenSize.width / 2 {
            return .right
          } else {
            return .left
          }
        }
        else {
          if sourceCenter.y < screenSize.height / 2 {
            return .top
          } else {
            return .bottom
          }
        }
      }
      else {
        return position
      }
    }
  }

  var menuDirectionOrigin : Point {
    let menuDirectionSize = menuDirectionView.frame.size
    let sourceSize = sourceFrame.size

    if self.menuPosition == .left {
      return Point(x: sourceCenter.x - (sourceSize.width / 2) - menuDirectionSize.width,
                   y: sourceCenter.y - (menuDirectionSize.height / 2))
    }
    if self.menuPosition == .top {
      return Point(x: sourceCenter.x - (menuDirectionSize.width / 2),
                   y: sourceCenter.y - (sourceSize.height / 2) - menuDirectionSize.height)
    }
    if self.menuPosition == .right {
      return Point(x: sourceCenter.x + (sourceSize.width / 2),
                   y: sourceCenter.y - (menuDirectionSize.height / 2))
    }
    if self.menuPosition == .bottom {
      return Point(x: sourceCenter.x - (menuDirectionSize.width / 2),
                   y: sourceCenter.y + (sourceSize.height / 2) + menuDirectionSize.height)
    }
  }
  
  var menuContentOrigin : Point {
    let screenSize = UIScreen.main.bounds
    let menuContentSize = menuContentView.frame.size

    if self.menuPosition == .left {
      var originX = menuDirectionOrigin.x - menuContentSize.width
      var originY = sourceCenter.y - (menuContentSize.height / 2)
      
      // Fix origin
      if originY < 0 {
        originY = 0
      }
      if originY + menuContentSize.height > screenSize.height {
        originY = screenSize.height - menuContentSize.height
      }
      return Point(x: originX, y: originY)
    }
    
    // TODO: .top
    // TODO: .right
    // TODO: .bottom
  }
  
  func attach()
  {
    // Create action views
    menuContentView = UIView()
    
    var totalHeight = 0.0
    var totalWidth = 0.0
    let labelHeight = 44.0
    for action in actions
    {
      let size: CGSize = action.title.size(withAttributes: [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)
      ])
      var label = UILabel(frame: CGRectMake(0, totalHeight, size.width, labelHeight))
      label.font = UIFont.systemFont(ofSize: 14.0)
      label.text = action.label
      label.textColor = textColor
      menuContentView.addSubview(label)
      totalHeight += labelHeight
      if size.width > totalWidth {
        totalWidth = size.width
      }
    }
    
    // Resize container view to match max dimension of labels
    menuContentView.frame = CGRectMake(0, 0, totalWidth, totalHeight)
    
    // TODO: add touch event handler
    
    // Create menu view
    var menuWidth = totalWidth
    var menuHeight = totalHeight
    
    if menuPosition == .left || menuPosition == .right {
      menuWidth = totalWidth + menuDirectionSize.width
    }
    if menuPosition == .top || menuPosition == .bottom {
      menuHeight = totalheight + menuDirectionSize.height
    }

    menuView = UIView(frame: CGRectMake(menuContentOrigin.x, menuContentOrigin.y, menuWidth, menuHeight))
    menuView.layer.cornerRadius = cornerRadius;
    menuView.layer.masksToBounds = true;
    
    menuView.addSubview(menuContentView)
    
    // Create direction view
    menuDirectionView = DirectionView(frame: CGRectMake(menuDirectionOrigin.x, menuDirectionOrigin.y, 50.0, 50.0),
                                      position: menuPosition, 
                                      color: .lightgrey)
    menuView.addSubview(menuDirectionView)
  }
  
  func show()
  {
    menuView.isHidden = false
  }
  
  func hide()
  {
    menuView.isHidden = true
  }
}