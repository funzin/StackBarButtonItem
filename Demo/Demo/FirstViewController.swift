import UIKit
import StackBarButtonItem

class FirstViewController: UIViewController {
    
    private var rightButton1: UIButton! {
        didSet {
            rightButton1.setTitle("right1", for: .normal)
            rightButton1.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            rightButton1.setTitleColor(.white, for: .normal)
            rightButton1.backgroundColor = .blue
            rightButton1.addTarget(self, action: #selector(self.pushToSecondVC), for: .touchUpInside)
        }
    }
    
    private var rightButton2: UIButton! {
        didSet {
            rightButton2.setTitle("right2", for: .normal)
            rightButton2.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            rightButton2.setTitleColor(.white, for: .normal)
            rightButton2.backgroundColor = .red
        }
    }
    
    private var leftButton: UIButton! {
        didSet {
            leftButton.setTitle("left", for: .normal)
            leftButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            leftButton.setTitleColor(.white, for: .normal)
            leftButton.backgroundColor = .purple
            leftButton.addTarget(self, action: #selector(self.pushToSecondVC), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationHeight = self.navigationController!.navigationBar.frame.height
        
        RightButton: do {
            rightButton1 = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: navigationHeight))
            rightButton2 = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: navigationHeight))
            NSLayoutConstraint.activate([
                rightButton1.widthAnchor.constraint(equalToConstant: 44),
                rightButton1.heightAnchor.constraint(equalToConstant: 44),
                rightButton2.widthAnchor.constraint(equalToConstant: 44),
                rightButton2.heightAnchor.constraint(equalToConstant: 44),
                ])
            
            self.navigationItem.setRightStackBarButtonItems(views: [rightButton1, rightButton2])
        }
        
        LeftButton: do {
            leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: navigationHeight))
            NSLayoutConstraint.activate([
                leftButton.widthAnchor.constraint(equalToConstant: 44),
                leftButton.heightAnchor.constraint(equalToConstant: 44)
                ])
            
            self.navigationItem.setLeftStackBarButtonItems(views: [leftButton])
        }
    }
    
    @objc func pushToSecondVC() {
        performSegue(withIdentifier: "second", sender: nil)
    }
}

