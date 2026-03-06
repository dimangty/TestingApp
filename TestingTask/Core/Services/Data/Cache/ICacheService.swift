
import Foundation

// sourcery: AutoMockable
protocol ICacheService {
    func getCachedNews() -> NewsSource?
    func cacheNews(_ newsSource: NewsSource)
    func clearCache()
}
