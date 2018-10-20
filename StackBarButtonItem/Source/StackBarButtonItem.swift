import UIKit
import RxSwift
import RxCocoa


public final class StackBarButtonItem {
    /// NavigationBarButtonItem Position
    ///
    /// - right:
    /// - left:
    enum BarButtonPosition {
        case right
        case left
    }
    
    /// dispose variable
    private var compositeDisposable = CompositeDisposable()
    private let disposeBag = DisposeBag()
    
    /// use in navigation margin setting
    private let marginItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    
    
    private weak var navigationItem: UINavigationItem?
    private let position: BarButtonPosition 
    
    init(navigationItem: UINavigationItem, position: BarButtonPosition) {
        self.navigationItem = navigationItem
        self.position = position
    }
}


// MARK: public method
public extension StackBarButtonItem{
    
    /// Set stackView on the right or left side of the navigation bar
    ///
    ///
    /// - Parameters:
    ///   - views: An array of views to display on the right or left side of the navigation bar
    ///   - spacing: Space value between view and view
    ///   - margin: Margin from right or left end of naigationBar
    ///   - reversed: Switch view order
    ///   - animated: Animation flag
    func setStackBarButtonItems(views: [UIView], spacing: CGFloat = 0, margin: CGFloat = 0, reversed: Bool = false, animated: Bool = false) {
        disposeAll()
        
        let items = configureItems(views: views, spacing: spacing, margin: margin, reversed: reversed, animated: animated)
        switch self.position {
        case .right:
            self.navigationItem?.setRightBarButtonItems(items, animated: animated)
        case .left:
            self.navigationItem?.setLeftBarButtonItems(items, animated: animated)
        }
    }
}

// MARK: private method
private extension StackBarButtonItem {
    
    /// compositeDisposable dispose and assign CompositeDisposable
    func disposeAll() {
        if compositeDisposable.count != 0 {
            compositeDisposable.dispose()
            compositeDisposable = CompositeDisposable()
        }
    }
    
    func addDisposable(_ disposable: Disposable) {
        _ = compositeDisposable.insert(disposable)
        disposable.disposed(by: disposeBag)
    }
    
    /// Configure UIBarButtonItems
    ///
    ///
    /// - Parameters:
    ///   - views: An array of views to display on the right or left side of the navigation bar
    ///   - spacing: Space value between view and view
    ///   - margin: Margin from right or left end of naigationBar
    ///   - reversed: Switch view order
    ///   - animated: Animation flag
    /// - Returns: configured items
    func configureItems(views: [UIView], spacing: CGFloat = 0, margin: CGFloat = 0, reversed: Bool = false, animated: Bool = false) -> [UIBarButtonItem]{
        let views = reversed ? views.reversed(): views
        let childStackView = createChildStackView(barButtonPosition: self.position, views: views, margin: margin, spacing: spacing)
        let items = convertIntoItems(childStackView)
        
        congifureNavigationMargin(barButtonPosition: self.position, childStackView: childStackView)
        return items
    }
    
    /// Create StackView to embed in BarButtonItem
    ///
    /// - Parameters:
    ///   - barButtonPosition: right or left
    ///   - views: An array of views to display on the right or left side of the navigation bar
    ///   - margin: Margin from the right or left end of navigationBar
    ///   - spacing: Space value between view and view
    /// - Returns: StackView which has finished setting such as mergin and space
    func createChildStackView(barButtonPosition: BarButtonPosition, views: [UIView], margin: CGFloat = 0, spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = spacing
        
        // configure margin
        if margin > 0 {
            let marginView = UIView(frame: CGRect(x: 0, y: 0, width: margin, height: 0))
            marginView.widthAnchor.constraint(equalToConstant: margin).isActive = true
            
            switch barButtonPosition {
            case .left:
                stackView.insertArrangedSubview(marginView, at: 0)
            case .right:
                stackView.addArrangedSubview(marginView)
            }
        }
        
        // configure stackview size and space
        let spaceWidth = CGFloat(max(stackView.arrangedSubviews.count - 1, 0)) * stackView.spacing
        let width = stackView.arrangedSubviews.reduce(CGFloat(0), { $0 + $1.frame.size.width }) + spaceWidth
        let height = stackView.arrangedSubviews.reduce(CGFloat(0), { max($0, $1.frame.size.height) })
        stackView.frame.size = CGSize(width: width, height: height)
        
        return stackView
    }
    
    /// Configure navigationMargin
    ///
    /// - Parameters:
    ///   - barButtonPosition: left or rihgt
    ///   - childStackView: StackView for embedding in BarButtonItem
    func congifureNavigationMargin(barButtonPosition: BarButtonPosition, childStackView: UIStackView) {
        if #available(iOS 11, *) {
            hideExtraMarginView(barButtonPosition, childStackView)
        } else {
            configureMargin()
        }
    }
    
    /// Convert stackView(customView) into BarButtonItem
    ///
    /// - Parameter stackView: CustomView of BarButtonItem
    /// - Returns: An array of UIBarButtonItem with marginItem in case of iOS 10 or less
    func convertIntoItems(_ stackView: UIStackView) -> [UIBarButtonItem] {
        let items: [UIBarButtonItem]
        if #available(iOS 11, *) {
            items = [UIBarButtonItem(customView: stackView)]
        } else {
            items = [marginItem, UIBarButtonItem(customView: stackView)]
        }
        return items
    }
}


// MARK: iOS11 or later private method
@available(iOS 11, *)
private extension StackBarButtonItem {
    
    /// Hide extra margin view
    ///
    /// - Parameters:
    ///   - barButtonPosition: right or left
    ///   - childStackView: StackView for embedding in BarButtonItem
    func hideExtraMarginView(_ barButtonPosition: BarButtonPosition, _ childStackView: UIStackView) {

        let disposable = childStackView.rx.methodInvoked(#selector(UIView.didMoveToSuperview))
            .observeOn(ConcurrentMainScheduler.instance)
            .flatMap { [weak childStackView] _ -> Observable<UIStackView> in
                childStackView.flatMap { ($0.superview as? UIStackView).map(Observable.just) } ?? .empty()
            }
            .do(onNext: { (superStackView) in
                // Add constraint
                guard let guide = superStackView.superview?.safeAreaLayoutGuide else { return }
                switch barButtonPosition {
                case .right:
                    superStackView.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
                case .left:
                    superStackView.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
                }
            })
            .flatMap({ [weak self] (superStackView) -> Observable<UIStackView> in
                guard let me = self else { return .empty() }
                return me.didAddSubView(superStackView)
            })
            .subscribe(onNext: { (superStackView) in
                // hide all views except UIStackView
                (superStackView.arrangedSubviews + superStackView.subviews)
                    .filter {type(of: $0) != UIStackView.self }
                    .forEach { $0.isHidden = true }
            })
        
        addDisposable(disposable)
    }
    
    /// Check didAddSubView timing
    ///
    /// - Parameter stackView: superView of childStackView
    /// - Returns: An Observable sequence
    func didAddSubView(_ stackView: UIStackView) -> Observable<UIStackView> {
        return stackView.rx.methodInvoked(#selector(UIStackView.didAddSubview(_:)))
            .map { _ in stackView }
    }
}

// MARK: iOS10 or less private method
@available(iOS, introduced: 9.0, obsoleted: 11.0)
private extension StackBarButtonItem {
    
    /// Configure margin width
    func configureMargin() {
        guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController?.children.first else { return }
        
        // observe viewWillLayoutSubviews(transition)
        let disposable = rootVC.rx.methodInvoked(#selector(UIViewController.viewWillLayoutSubviews))
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let me = self else { return }
                
                // configure margin
                me.marginItem.width = me.minusMargin(rootVC.traitCollection)
            })
        
        addDisposable(disposable)
    }
    
    /// Minus margin width in case of iOS 10 or or less
    ///
    /// - Parameter traitCollection: Use for iPhone Orientation
    /// - Returns: Appropriate minus margin width
    func minusMargin(_ traitCollection: UITraitCollection) -> CGFloat {
        if UIDevice.current.isPad || UIDevice.current.isPlus {
            return -20
        }
        
        // iPhone
        return traitCollection.verticalSizeClass == .regular ? -16: -20
    }
}
