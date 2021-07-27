//
//  AppDelegate.swift
//  SpaceApp
//
//  Created by Svetlana Fomina on 20.07.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let service = NASANetworkService()
        let coreDataStack = Container.shared.coreDataStack
        coreDataStack.load()

//        UIApplication.shared.windows.forEach { window in
//            window.overrideUserInterfaceStyle = .dark
//        }

        // UINavigationController

// window?.rootViewController = UINavigationController(rootViewController: MainViewController(networkService: service))
        //        window?.rootViewController = UINavigationController(rootViewController: StartViewController())

        // UITabBarController

        let tabBarVC = TabBarController()
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        return true
    }

}
