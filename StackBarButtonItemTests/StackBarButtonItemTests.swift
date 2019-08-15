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
        vc.navigationItem.left.setStackBarButtonItems(views: [leftButton1, leftButton2])
        vc.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2])
        vc.view.layoutIfNeeded()

        guard let rightBaseStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let rightChildStackView = rightBaseStackView.arrangedSubviews.first as? UIStackView,
            let leftBaseStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView,
            let leftChildStackView = leftBaseStackView.arrangedSubviews.last as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }

        // baseStackView
        XCTAssertTrue(rightBaseStackView.arrangedSubviews.count == 1)
        XCTAssertTrue(leftBaseStackView.arrangedSubviews.count == 1)

        // childStackView
        XCTAssertTrue(rightChildStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(leftChildStackView.arrangedSubviews.count == 2)
    }

    func testStackViewSize() {
        vc.navigationItem.left.setStackBarButtonItems(views: [leftButton1, leftButton2])
        vc.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2])

        guard let rightBaseStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let leftBaseStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }

        let rightSize = rightBaseStackView.frame.size
        let leftSize = leftBaseStackView.frame.size
        XCTAssertTrue(rightSize == CGSize(width: 88, height: 44))
        XCTAssertTrue(leftSize == CGSize(width: 88, height: 44))
    }

    func testStackViewSpace() {
        vc.navigationItem.left.setStackBarButtonItems(views: [leftButton1, leftButton2], spacing: 10)
        vc.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2], spacing: 10)

        guard let rightBaseStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let rightChildStackView = rightBaseStackView.arrangedSubviews.first as? UIStackView,
            let leftBaseStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView,
            let leftChildStackView = leftBaseStackView.arrangedSubviews.last as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }

        let rightWidth = rightChildStackView.frame.width
        let leftWidth = leftChildStackView.frame.width

        XCTAssertTrue(rightWidth == 98)
        XCTAssertTrue(leftWidth == 98)
        XCTAssertTrue(rightChildStackView.spacing == 10)
        XCTAssertTrue(leftChildStackView.spacing == 10)
    }

    func testStackViewMargin() {
        vc.navigationItem.left.setStackBarButtonItems(views: [leftButton1, leftButton2], margin: 10)
        vc.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2], margin: 10)

        guard let rightBaseStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let rightChildStackView = rightBaseStackView.arrangedSubviews.first as? UIStackView,
            let leftBaseStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView,
            let leftChildStackView = leftBaseStackView.arrangedSubviews.last as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }

        XCTAssertTrue(rightBaseStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(rightChildStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(rightBaseStackView.frame.width == 98)
        XCTAssertTrue(rightChildStackView.frame.width == 88)

        XCTAssertTrue(leftBaseStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(leftChildStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(leftBaseStackView.frame.width == 98)
        XCTAssertTrue(leftChildStackView.frame.width == 88)
    }

    func testStackViewMarginAndSapcing() {
        vc.navigationItem.left.setStackBarButtonItems(views: [leftButton1, leftButton2], spacing: 20, margin: 10)
        vc.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2], spacing: 20, margin: 10)

        guard let rightBaseStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let rightChildStackView = rightBaseStackView.arrangedSubviews.first as? UIStackView,
            let leftBaseStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView,
            let leftChildStackView = leftBaseStackView.arrangedSubviews.last as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }

        XCTAssertTrue(rightBaseStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(rightChildStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(rightBaseStackView.frame.width == 118)
        XCTAssertTrue(rightChildStackView.frame.width == 108)
        XCTAssertTrue(rightChildStackView.spacing == 20)

        XCTAssertTrue(leftBaseStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(leftChildStackView.arrangedSubviews.count == 2)
        XCTAssertTrue(leftBaseStackView.frame.width == 118)
        XCTAssertTrue(leftChildStackView.frame.width == 108)
        XCTAssertTrue(leftChildStackView.spacing == 20)

    }

    func testStackViewReversed() {
        vc.navigationItem.left.setStackBarButtonItems(views: [leftButton1, leftButton2], reversed: true)
        vc.navigationItem.right.setStackBarButtonItems(views: [rightButton1, rightButton2], reversed: true)

        guard let rightBaseStackView = vc.navigationItem.rightBarButtonItems?.last?.customView as? UIStackView,
            let rightChildStackView = rightBaseStackView.arrangedSubviews.first as? UIStackView,
            let leftBaseStackView = vc.navigationItem.leftBarButtonItems?.last?.customView as? UIStackView,
            let leftChildStackView = leftBaseStackView.arrangedSubviews.last as? UIStackView else {
                XCTFail("Expected stackView is not nil")
                return
        }

        XCTAssertTrue(rightChildStackView.arrangedSubviews.reversed() == [rightButton1, rightButton2])
        XCTAssertTrue(leftChildStackView.arrangedSubviews.reversed() == [leftButton1, leftButton2])
    }

    func testStackViewEmpty() {
        vc.navigationItem.left.setStackBarButtonItems(views: [])
        vc.navigationItem.right.setStackBarButtonItems(views: [])

        guard let rightBarButtonItems = vc.navigationItem.rightBarButtonItems,
            let leftBarButtonItems = vc.navigationItem.leftBarButtonItems else {
                XCTFail("Expected barButtonItems is not nil")
                return
        }

        XCTAssertTrue(rightBarButtonItems.isEmpty)
        XCTAssertTrue(leftBarButtonItems.isEmpty)
    }
}
