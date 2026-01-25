//
//  StorageServiceClient.swift
//  TestingTask
//
//  TCA Dependency for StorageService
//

import ComposableArchitecture
import Foundation

struct StorageServiceClient {
    var isArticleInFavorites: @Sendable (String) async -> Bool
    var addToFavorites: @Sendable (String, String, Date, String?) async -> Void
    var removeFromFavorites: @Sendable (String) async -> Void
    var getFavorites: @Sendable () async -> [ArticleEntity]
}

extension StorageServiceClient: DependencyKey {
    static let liveValue = StorageServiceClient(
        isArticleInFavorites: { title in
            let service = Configurator.shared.serviceLocator.getService(type: IStorageService.self)
            return service?.isArticleInFavorites(title: title) ?? false
        },
        addToFavorites: { title, contents, publishedAt, urlToImage in
            let service = Configurator.shared.serviceLocator.getService(type: IStorageService.self)
            service?.addToFavorites(title: title, contents: contents, publishedAt: publishedAt, urlToImage: urlToImage)
        },
        removeFromFavorites: { title in
            let service = Configurator.shared.serviceLocator.getService(type: IStorageService.self)
            service?.removeFromFavorites(title: title)
        },
        getFavorites: {
            let service = Configurator.shared.serviceLocator.getService(type: IStorageService.self)
            return service?.articles ?? []
        }
    )
}

extension DependencyValues {
    var storageService: StorageServiceClient {
        get { self[StorageServiceClient.self] }
        set { self[StorageServiceClient.self] = newValue }
    }
}
