
import Foundation

final class CacheService: ICacheService {

    static let shared = CacheService()

    private var cachedNewsSource: NewsSource?
    private var cacheTimestamp: Date?
    private let cacheExpirationInterval: TimeInterval = 5 * 60 // 5 minutes

    private init() {}

    func getCachedNews() -> NewsSource? {
        guard let cachedNewsSource = cachedNewsSource,
              let cacheTimestamp = cacheTimestamp else {
            return nil
        }

        let now = Date()
        let timeElapsed = now.timeIntervalSince(cacheTimestamp)

        if timeElapsed < cacheExpirationInterval {
            return cachedNewsSource
        } else {
            clearCache()
            return nil
        }
    }

    func cacheNews(_ newsSource: NewsSource) {
        cachedNewsSource = newsSource
        cacheTimestamp = Date()
    }

    func clearCache() {
        cachedNewsSource = nil
        cacheTimestamp = nil
    }
}
