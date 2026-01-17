//
//  AppDelegate.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    @Injected private var coordinator: ApplicationCoordinator?

    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //INIT DI
        Configurator.shared.setup()
        
        //INIT UI
        self.window = UIWindow(frame: UIScreen.main.bounds)
        coordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }



}
