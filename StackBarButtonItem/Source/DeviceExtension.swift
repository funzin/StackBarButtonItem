import Foundation
import UIKit

extension UIDevice {
    var isPhone: Bool {
        return self.userInterfaceIdiom == .phone
    }
    
    var isPad: Bool {
        return self.userInterfaceIdiom == .pad
    }
    
    var isPlus: Bool {
        if isPhone {
            let height = UIScreen.main.nativeBounds.height
            if height == 1920 || height == 2208 {
                return true
            }
        }
        return false
    }
}
