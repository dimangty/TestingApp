//
//  CurrencyItemModel.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
class CurrencyItemModel {
    var cellId: String
    var title: String
    var checked: Bool
    
    init(title: String, checked: Bool) {
        cellId = "CurrencyCell"
        self.title = title
        self.checked = checked
    }
}
