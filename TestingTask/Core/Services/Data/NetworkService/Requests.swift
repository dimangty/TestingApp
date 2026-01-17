//
//  Requests.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
enum Requests {
    case currencyList
    case rates(pairs: String)
    
    var value: String {
        switch self {
        case .currencyList:
            return "?get=currency_list"
        case .rates(let pairs):
            return "?get=rates&pairs=\(pairs)"
        }
    }
}
