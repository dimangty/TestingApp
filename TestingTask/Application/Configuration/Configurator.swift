//
//  Configurator.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
class Configurator {
    static let shared = Configurator()
    let serviceLocator = ServiceLocator()

    func setup() {
        registerServices()
    }
    
   private func registerServices() {
       // serviceLocator.addService(service: ApplicationCoordinator()) // Removed - UIKit only
       serviceLocator.addService(service: Obfuscator())
       serviceLocator.addService(service: CurrateService())
       // serviceLocator.addService(service: ErrorService()) // Removed - UIKit only
       // serviceLocator.addService(service: ProgressService()) // Removed - UIKit only
       serviceLocator.addService(service: ValidationService() as ValidationServiceProtocol)
       serviceLocator.addService(service: AuthService() as AuthServiceProtocol)
       
       let casheService = CacheService.shared
       serviceLocator.addService(service: casheService)
       serviceLocator.addService(service: NewsService.shared as INewsService)
       serviceLocator.addService(service: StorageService.shared as IStorageService)
    }
}
