//
//  AppDelegate.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //INIT DI
        Configurator.shared.setup()
        
        //INIT UI
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainScreenRouter().createModule()
        window?.makeKeyAndVisible()
        return true
    }



}

