//
//  AppDelegate.swift
//  TestAnimation
//
//  Created by Кизим Илья on 31.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let mainRouter = MainRouter()
        mainRouter.navigationController = navigationController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        mainRouter.start()
        return true
    }
}


