//
//  Injected.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
@propertyWrapper
struct Injected<Service> {
    private var service: Service?
    private weak var serviceLocator = Configurator.shared.serviceLocator
    

    public var wrappedValue: Service? {
        mutating get {
            if service == nil {
                service = serviceLocator?.getService(type: Service.self)
            }
            return service
        }
        mutating set {
            service = newValue
        }
    }
    
    public var projectedValue: Injected<Service> {
        mutating set {self = newValue}
        get {return self}
    }
}
