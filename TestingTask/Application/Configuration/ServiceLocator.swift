//
//  ServiceLocator.swift
//  TestingTask
//
//  Created by Dima Bykov on 19.07.2022.
//

import Foundation

class ServiceLocator : NSObject {
    private var containerServices = [String: Any]()
    
    func addService<T>(service: T) {
        let key = "\(T.self)"
        if containerServices[key] == nil {
            containerServices[key] = service
        }
    }

    // Explicit replacement is used by unit tests to inject deterministic doubles.
    func setService<T>(service: T) {
        let key = "\(T.self)"
        containerServices[key] = service
    }
    
    func getService<T>(type: T.Type)->T? {
        let key = "\(T.self)"
        return containerServices[key] as? T
    }

    func removeAllServices() {
        containerServices.removeAll()
    }
}
