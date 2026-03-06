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
#if DEBUG
        if ProcessInfo.processInfo.arguments.contains("UITESTS") {
            configureForUITests()
        }
#endif
    }
    
    private func registerServices() {
       serviceLocator.addService(service: ApplicationCoordinator())
       serviceLocator.addService(service: Obfuscator())
       serviceLocator.addService(service: CurrateService())
       serviceLocator.addService(service: ErrorService())
        serviceLocator.addService(service: ErrorService() as IErrorService)
        
       serviceLocator.addService(service: ProgressService())
        serviceLocator.addService(service: ProgressService() as IProgressService)
       serviceLocator.addService(service: ValidationService())
       serviceLocator.addService(service: AuthService() as AuthServiceProtocol)
       
       let casheService = CacheService.shared
       serviceLocator.addService(service: casheService)
       serviceLocator.addService(service: NewsService.shared)
       serviceLocator.addService(service: StorageService.shared)
    }

#if DEBUG
    private func configureForUITests() {
        let sampleArticles = [
            Article(author: "Test Author",
                    title: "Test Article 1",
                    description: "Stubbed article for UI tests",
                    url: URL(string: "https://example.com/1"),
                    urlToImage: nil,
                    publishedAt: Date(timeIntervalSince1970: 0)),
            Article(author: "Test Author",
                    title: "Test Article 2",
                    description: "Stubbed article for UI tests",
                    url: URL(string: "https://example.com/2"),
                    urlToImage: nil,
                    publishedAt: Date(timeIntervalSince1970: 60))
        ]
        let stubbedNews = NewsSource(status: "ok",
                                     totalResults: sampleArticles.count,
                                     articles: sampleArticles)
        CacheService.shared.cacheNews(stubbedNews)
    }
#endif
}
