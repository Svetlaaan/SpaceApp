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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		let coreDataStack = Container.shared.coreDataStack
		coreDataStack.load()

		let service = NASANetworkService()
//		let mainVC = ViewController(networkService: service)
//		let aboutVC = AboutViewController()
//		let historyVC = HistoryViewController()
//
//		let tabBarVC = UITabBarController()
//		tabBarVC.setViewControllers([historyVC, mainVC, aboutVC], animated: true)
//		window?.rootViewController = tabBarVC
		window?.rootViewController = UINavigationController(rootViewController: ViewController(networkService: service))
//		window?.rootViewController = UINavigationController(rootViewController: StartViewController())
		window?.makeKeyAndVisible()
		return true
	}

}
