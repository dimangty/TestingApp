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
       serviceLocator.addService(service: ApplicationCoordinator())
       serviceLocator.addService(service: Obfuscator())
       serviceLocator.addService(service: CurrateService())
       serviceLocator.addService(service: ErrorService())
       serviceLocator.addService(service: ProgressService())
       serviceLocator.addService(service: ValidationService())
       serviceLocator.addService(service: AuthService() as AuthServiceProtocol)
       
       let casheService = CacheService.shared
       serviceLocator.addService(service: casheService)
       serviceLocator.addService(service: NewsService.shared)
       serviceLocator.addService(service: StorageService.shared)
    }
}
