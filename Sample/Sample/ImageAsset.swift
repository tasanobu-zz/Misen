// Generated with Misen by tasanobu - https://github.com/tasanobu/Misen

import UIKit

// MARK: - UIImage extension
extension UIImage {
    convenience init!(assetName: ImageAsset) {
        self.init(named: assetName.rawValue)
    }
}

// MARK: - ImageAsset
enum ImageAsset: String {
    case Camera_Icon = "Camera_Icon"
    case Camera = "Camera"
    case Contact_Icon = "Contact_Icon"
    case Contact = "Contact"
    case Home = "Home"

    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}
