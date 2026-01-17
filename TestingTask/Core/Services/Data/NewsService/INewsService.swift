
import Foundation

protocol INewsService {
    
    func performNewsRequest(completion: @escaping (Result<NewsSource, Error>) -> Void)
    
}
