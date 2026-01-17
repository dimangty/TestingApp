//
//  NetworkConfiguration.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
class NetworkConfiguration {

    private let apiUrl = "https://currate.ru/api/"
    private let apiKey = ""

    func getHeaders() -> [String: String] {
        return [:]
    }

    func getBaseUrl() -> String {
        return apiUrl
    }
    
    func getKey() -> [String:String] {
        return ["key":apiKey]
    }

}
