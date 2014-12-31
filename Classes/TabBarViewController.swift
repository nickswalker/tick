import UIKit
import Foundation

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private var tockManager: TockManager?

    override func viewDidLoad(){

    }

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print(viewController)
    }

}

