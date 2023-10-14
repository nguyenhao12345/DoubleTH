//
//  AppDelegate.swift
//  Project1
//
//  Created by NguyenHao on 11/10/2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeViewController.instance()
        window?.makeKeyAndVisible()

        return true
    }
}

