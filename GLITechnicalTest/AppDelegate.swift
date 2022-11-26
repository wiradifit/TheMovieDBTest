//
//  AppDelegate.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let vc = UINavigationController(rootViewController: MovieDashboardViewController())
        vc.navigationItem.title = "Discover Indonesia's Popular Movies"
        window = UIWindow()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    
        return true
    }
}
