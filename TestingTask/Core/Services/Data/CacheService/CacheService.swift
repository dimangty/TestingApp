//
//  CacheService.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation
class CacheService {
    var lifeTime: Double = 500
    var cache: [CacheItemModel] = []
    init(lifeTime: Double) {
        self.lifeTime = lifeTime
    }
    
    func appendItem(title: String, value: String) {
        //Проверка наличия данных для текущего ключа
        if let index = cache.firstIndex(where: {$0.rateTitle == title}) {
            cache.remove(at: index)
        }
        
        cache.append(CacheItemModel(title: title, value: value))
    }
    
    func getRate(for Title: String) -> String? {
        //Поиск данных в кеше
        if let index = cache.firstIndex(where: {$0.rateTitle == Title}) {
            let cacheItem = cache[index]
            //Проверка времени жизни данных
            if Date().timeIntervalSince(cacheItem.date) > lifeTime {
                return nil
            }
            
            return cacheItem.rateValue
        } else {
            
            return nil
        }
     }
    
    
}
