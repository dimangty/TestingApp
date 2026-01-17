
import Foundation

enum ApiErrors : String, Error {
    case dataIsNil = "Data is nil!"
    case jsonParseError = "JSON parse error"
}

final class NewsService : INewsService {

    static let shared = NewsService()

    private let cacheService: ICacheService

    private init(cacheService: ICacheService = CacheService.shared) {
        self.cacheService = cacheService
    }

    private var everythingUrl = URLComponents(string: "https://newsapi.org/v2/everything?")
    private let search = URLQueryItem(name: "q", value: "russia")
    private let sortBy = URLQueryItem(name: "sortBy", value: "publishedAt")
    private let language = URLQueryItem(name: "language", value: "ru")
    private let apiKey = URLQueryItem(name: "apiKey", value: "34f4c8a4cfe647f5acd1e7d709464b34")
    
    func performNewsRequest(completion: @escaping (Result<NewsSource, Error>) -> Void) {

        // Check cache first
        if let cachedNews = cacheService.getCachedNews() {
            completion(.success(cachedNews))
            return
        }

        // If no cache, perform network request
        let request = getNewsServiceRequest()

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ApiErrors.dataIsNil))
                return
            }

            do
            {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let newsSource = try decoder.decode(NewsSource.self, from: data)

                // Cache the successful response
                self?.cacheService.cacheNews(newsSource)

                completion(.success(newsSource))
            }
            catch {
                print(error)
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    private func getNewsServiceRequest() -> URLRequest {
        everythingUrl?.queryItems = [
            search,
            language,
            sortBy,
            apiKey
        ]
        
        guard let url = everythingUrl?.url else {
            fatalError("Error creating newsapi.org url from components")
        }
        
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
    }
}
