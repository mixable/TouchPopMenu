class DirectionView : UIView
{
  private var position: TouchPopMenu.Position
  private var color: CGColor

  override init(frame: CGRect, position: TouchPopMenu.Position, color: CGColor = .lightgrey)
  {
    self.position = position
    self.color = color
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func draw(_ rect: CGRect)
  {
    guard let context = UIGraphicsGetCurrentContext() else { return }

    context.beginPath()
    if (position == .left) {
      context.move(to: CGPoint(x: rect.minX, y: rect.minY))
      context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
      context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    }
    if (position == .top) {
      context.move(to: CGPoint(x: rect.minX, y: rect.minY))
      context.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.maxY))
      context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    }
    if (position == .right) {
      context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
      context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY / 2))
      context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    }
    if (position == .bottom) {
      context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
      context.addLine(to: CGPoint(x: rect.maxX / 2, y: rect.minY))
      context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    }
    context.closePath()

    context.setFillColor(color)
    context.fillPath()
  }
}