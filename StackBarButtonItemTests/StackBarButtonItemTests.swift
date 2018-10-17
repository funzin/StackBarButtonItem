import XCTest
@testable import StackBarButtonItem

class StackBarButtonItemTests: XCTestCase {
    
    var vc: UIViewController!
    
    var rightButton1: UIButton!
    var rightButton2: UIButton!
    
    var leftButton1: UIButton!
    var leftButton2: UIButton!
    
    override func setUp() {
        super.setUp()
        vc = UIViewController()
        
        rightButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        rightButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        leftButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        leftButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        [rightButton1, rightButton2, leftButton1, leftButton2]
            .forEach {
                $0!.widthAnchor.constraint(equalToConstant: 44).isActive = true
                $0!.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testArrangedSubViewsCount() {
        vc.navigationItem.setLeftStackBarButtonItems(views: [leftButton1, leftButton2])
        vc.navigationItem.setRightStackBarButtonItems(views: [rightButton1, rightButton2])
        vc.view.layoutIfNeeded()
        
        guard let rightStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let leftStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }
        
        XCTAssertTrue(rightStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(leftStackView.arrangedSubviews.count == 2)
    }
    
    func testStackViewSize() {
        vc.navigationItem.setLeftStackBarButtonItems(views: [leftButton1, leftButton2])
        vc.navigationItem.setRightStackBarButtonItems(views: [rightButton1, rightButton2])
        
        guard let rightSize = vc.navigationItem.rightBarButtonItems?.last?.customView?.frame.size,
            let leftSize = vc.navigationItem.leftBarButtonItems?.last?.customView?.frame.size else {
                XCTFail("Expected size is not nil")
                return
        }
        
        XCTAssertTrue(rightSize == CGSize(width: 88, height: 44))
        XCTAssertTrue(leftSize == CGSize(width: 88, height: 44))
    }
    
    func testStackViewSpace() {
        vc.navigationItem.setLeftStackBarButtonItems(views: [leftButton1, leftButton2], spacing: 10)
        vc.navigationItem.setRightStackBarButtonItems(views: [rightButton1, rightButton2], spacing: 10)
        
        guard let rightWidth = vc.navigationItem.rightBarButtonItems?.last?.customView?.frame.size.width,
            let leftWidth = vc.navigationItem.leftBarButtonItems?.last?.customView?.frame.size.width else {
                XCTFail("Expected size is not nil")
                return
        }
        
        XCTAssertTrue(rightWidth == 98)
        XCTAssertTrue(leftWidth == 98)
    }
    
    func testStackViewMargin() {
        vc.navigationItem.setLeftStackBarButtonItems(views: [leftButton1, leftButton2], margin: 10)
        vc.navigationItem.setRightStackBarButtonItems(views: [rightButton1, rightButton2], margin: 10)
        
        guard let rightStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let leftStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }
        
        
        XCTAssertTrue(rightStackView.arrangedSubviews.count == 3)
        XCTAssertTrue(rightStackView.frame.width == 98)
        
        XCTAssertTrue(leftStackView.arrangedSubviews.count == 3)
        XCTAssertTrue(leftStackView.frame.width == 98)
    }
    
    func testStackViewReversed() {
        vc.navigationItem.setLeftStackBarButtonItems(views: [leftButton1, leftButton2], reversed: true)
        vc.navigationItem.setRightStackBarButtonItems(views: [rightButton1, rightButton2], reversed: true)
        
        guard let rightStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let leftStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }
        
        
        XCTAssertTrue(rightStackView.arrangedSubviews.reversed() == [rightButton1, rightButton2])
        XCTAssertTrue(leftStackView.arrangedSubviews.reversed() == [leftButton1, leftButton2])
    }
}
