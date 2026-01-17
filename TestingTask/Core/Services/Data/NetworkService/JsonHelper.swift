//
//  JsonHelper.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
class JsonHelper {
    static let shared = JsonHelper()
    
    func decodeData<T:Codable>(response: HTTPURLResponse, data: Data, _ type: T.Type)->Result<T,Error> {
        let code = response.statusCode
        let string = String(data: data, encoding: .utf8) ?? "null"
        pp(string)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        if code >= 200 && code < 400 {
            do {
            let result = try jsonDecoder.decode(T.self, from: data)
                return Result.success(result)
            }
            catch {
                return Result.failure(error)
            }
        } else {
            return Result.failure(ErrorResponse(type: .tech))
        }
    }
}
