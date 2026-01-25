//
//  NewsServiceClient.swift
//  TestingTask
//
//  TCA Dependency for NewsService
//

import ComposableArchitecture
import Foundation

struct NewsServiceClient {
    var fetchNews: @Sendable () async -> Result<NewsSource, Error>
}

extension NewsServiceClient: DependencyKey {
    static let liveValue = NewsServiceClient(
        fetchNews: {
            await withCheckedContinuation { continuation in
                let service = Configurator.shared.serviceLocator.getService(type: INewsService.self)
                service?.performNewsRequest { result in
                    continuation.resume(returning: result)
                }
            }
        }
    )
}

extension DependencyValues {
    var newsService: NewsServiceClient {
        get { self[NewsServiceClient.self] }
        set { self[NewsServiceClient.self] = newValue }
    }
}
