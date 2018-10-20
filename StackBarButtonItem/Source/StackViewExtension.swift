import UIKit

extension UIStackView {
    func configure(spacing: CGFloat = 0) {
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fill
        self.spacing = spacing
    }
    
    func updateFrameSize() {
        let spaceWidth = CGFloat(max(self.arrangedSubviews.count - 1, 0)) * self.spacing
        let width = self.arrangedSubviews.reduce(CGFloat(0), { $0 + $1.frame.size.width }) + spaceWidth
        let height = self.arrangedSubviews.reduce(CGFloat(0), { max($0, $1.frame.size.height) })
        self.frame.size = CGSize(width: width, height: height)
    }
    
    func addMarginView(barButtonPosition: StackBarButtonItem.BarButtonPosition, margin: CGFloat = 0) {
        if margin > 0 {
            let marginView = UIView(frame: CGRect(x: 0, y: 0, width: margin, height: 0))
            marginView.widthAnchor.constraint(equalToConstant: margin).isActive = true
            
            switch barButtonPosition {
            case .left:
                self.insertArrangedSubview(marginView, at: 0)
            case .right:
                self.addArrangedSubview(marginView)
            }
        }
    }
}
