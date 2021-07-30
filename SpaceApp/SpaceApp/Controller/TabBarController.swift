//
//  TabBarController.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 24.07.2021.
//

import UIKit

class TabBarController: UITabBarController {

    let networkService: NASANetworkServiceProtocol

    // MARK: - Init
    init(networkService: NASANetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .darkGray
        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let mainVC = UINavigationController(rootViewController: MainViewController(networkService: networkService))
        let mainVCBarItem = UITabBarItem(title: "Main",
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

        self.viewControllers = [mainVC, historyVC, settingsVC]
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NSLog("Selected \(viewController.title ?? "New") screen")
        }
}
