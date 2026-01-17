//
//  NetworkService.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation


enum Method: String {
    case get = "GET"
    case post = "POST"
    
    var value: String {
        return self.rawValue
    }
}

class NetworkService {
    private var configuration = NetworkConfiguration()
    private var obfuscator = Obfuscator()
    
    func request<T:Codable>(path: String, method: Method, parameters: [String:String] = [:],
                    completion: @escaping(Result<T,Error>)->Void) {
        let apiPath = "\(configuration.getBaseUrl())\(path)"
        guard var url = URL(string: apiPath) else {
            DispatchQueue.main.async {
                completion(Result.failure(ErrorResponse(type: .other)))
            }
            return
        }
        
        if method == .get{
            guard var components = URLComponents(string: apiPath) else {
                DispatchQueue.main.async {
                    completion(Result.failure(ErrorResponse(type: .other)))
                }
                return
            }
            
            for parameter in parameters {
                components.queryItems?.append(URLQueryItem(name: parameter.key, value: parameter.value))
            }
            
           
            let keys = ["key":obfuscator.reveal(key: obfuscator.currateAPIkey)]
            for key in keys {
                components.queryItems?.append(URLQueryItem(name: key.key, value: key.value))
            }
            
            
            
            if let componentsURL = components.url {
                url = componentsURL
            } else {
                DispatchQueue.main.async {
                    completion(Result.failure(ErrorResponse(type: .other)))
                }
                return
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        let headers = configuration.getHeaders()
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        pp("Api r------------------------------")
        pp("Api request \(request.debugDescription)")
        pp("Api r------------------------------")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                let content = JsonHelper.shared.decodeData(response: response, data: data, T.self)
                DispatchQueue.main.async {
                  completion(content)
                }
            }
            else  {
                DispatchQueue.main.async {
                completion(Result.failure(ErrorResponse(type: .network)))
            }
            }
        }
        task.resume()
        
    }
}
