//
//  TabBarController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 24.07.2021.
//

import UIKit

class TabBarController: UITabBarController {

    let service = NASANetworkService()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .darkGray
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let mainVC = UINavigationController(rootViewController: MainViewController(networkService: service))
        let mainVCBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         selectedImage: UIImage(systemName: "house.fill"))
        mainVC.tabBarItem = mainVCBarItem

        let historyVC = UINavigationController(rootViewController: HistoryViewController())
        let historyVCBarItem = UITabBarItem(title: "History",
                                            image: UIImage(systemName: "clock"),
                                            selectedImage: UIImage(systemName: "clock.fill"))
        historyVC.tabBarItem = historyVCBarItem

        let settingsVC = UINavigationController(rootViewController: SettingsController())
        let settingsVCBarItem = UITabBarItem(title: "Settings",
                                             image: UIImage(systemName: "gearshape"),
                                             selectedImage: UIImage(systemName: "gearshape.fill"))
        settingsVC.tabBarItem = settingsVCBarItem

        let startVC = StartViewController()
        let startVCBarItem = UITabBarItem(title: "Today", image: UIImage(systemName: "house"),
                                          selectedImage: UIImage(systemName: "house.fill"))
        startVC.tabBarItem = startVCBarItem

        self.viewControllers = [mainVC, historyVC, settingsVC]
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NSLog("Selected \(viewController.title ?? "New") screen")
        }
}
