//
//  ErrorResponse.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
enum ErrorType {
   case auth, network, tech, other
}

class ErrorResponse : Error {
    var message: String = ""
    var type = ErrorType.other

    
    init(message: String) {
        self.message = message
    }
    
    init(type: ErrorType) {
        self.type = type
    }
    
    func getType() -> String {
        switch type {
        case .auth:
            return "Type error"
        case .network:
            return "Network error"
        case .tech:
            return "Tech error"
        case .other:
            return "Other error"
        }
    }
    
}
