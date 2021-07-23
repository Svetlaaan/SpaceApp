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
        let service = NASANetworkService()
        let coreDataStack = Container.shared.coreDataStack
        coreDataStack.load()

        //		window?.rootViewController = UINavigationController(rootViewController: ViewController(networkService: service))
        window?.rootViewController = UINavigationController(rootViewController: StartViewController())
        window?.makeKeyAndVisible()
        return true
    }

}
