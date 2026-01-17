//
//  CacheItemModel.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
struct CacheItemModel {
    var rateTitle: String
    var rateValue: String
    var date: Date
    
    init(title: String, value: String) {
        self.rateTitle = title
        self.rateValue = value
        self.date = Date()
    }
}
