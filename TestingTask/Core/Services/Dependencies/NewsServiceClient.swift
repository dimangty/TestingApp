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
                guard let service = Configurator.shared.serviceLocator.getService(type: INewsService.self) else {
                    continuation.resume(returning: .failure(NSError(domain: "NewsServiceClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "News service not available"])))
                    return
                }
                service.performNewsRequest { result in
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
