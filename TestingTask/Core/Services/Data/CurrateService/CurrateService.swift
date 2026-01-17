//
//  CurrateService.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import Foundation

class CurrateService {
    static let shared = CurrateService()
    private let networkService: NetworkService
    
    init() {
        self.networkService = NetworkService()
    }
    
    func getCurrencyList(completion: @escaping(Result<CurrencyListDTO,Error>)->Void) {
        networkService.request(path: Requests.currencyList.value, method: .get) { (result: Result<CurrencyListDTO,Error>) in
            completion(result)
        }
    }
    
    
    func getRates(pairs: String,
                  completion: @escaping(Result<CurrencyRatesDTO,Error>)->Void) {
        networkService.request(path: Requests.rates(pairs: pairs).value, method: .get) { (result: Result<CurrencyRatesDTO,Error>) in
            completion(result)
        }
    }
    
    
}
