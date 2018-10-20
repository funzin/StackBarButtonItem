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
        
        var items: [UIBarButtonItem] = []
        if !views.isEmpty {
            items = configureItems(views: views, spacing: spacing, margin: margin, reversed: reversed, animated: animated)
        }
        
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
        
        let baseStackView = createBaseStackView(barButtonPosition: self.position, views: views, spacing: spacing, margin: margin)
        let items = convertIntoItems(baseStackView)
        
        congifureNavigationMargin(barButtonPosition: self.position, childStackView: baseStackView)
        return items
    }
    
    /// Create BaseStackView to embed in BarButtonItem. baseStackView includes childStackView(views and spacing) and margin view
    /// - Parameters:
    ///   - barButtonPosition: right or left
    ///   - views: An array of views to display on the right or left side of the navigation bar
    ///   - spacing: Space value between view and view
    ///   - margin: Margin from the right or left end of navigationBar
    /// - Returns: StackView which has finished setting such as margin and space
    func createBaseStackView(barButtonPosition: BarButtonPosition, views: [UIView], spacing: CGFloat = 0, margin: CGFloat = 0) -> UIStackView {
        let childStackView = createChildStackView(views: views, spacing: spacing)
        let baseStackView = UIStackView(arrangedSubviews: [childStackView])
        
        baseStackView.configure(spacing: 0)
        baseStackView.addMarginView(barButtonPosition: self.position, margin: margin)
        baseStackView.updateFrameSize()
        
        return baseStackView
    }
    
    /// Create childStackView. childStackView includes views and spacing
    /// - Parameters:
    ///   - views: An array of views to display on the right or left side of the navigation bar
    ///   - spacing: Space value between view and view
    /// - Returns: StackView which has finished setting such as spacing
    func createChildStackView(views: [UIView], spacing: CGFloat = 0) -> UIStackView {
        let childStackView = UIStackView(arrangedSubviews: views)
        childStackView.configure(spacing: spacing)
        childStackView.updateFrameSize()
        
        return childStackView
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
            configureMinusMargin()
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
    func configureMinusMargin() {
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
