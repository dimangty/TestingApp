//
//  MainScreenViewInput.swift
//  TestingTask
//
//  Created by DBykov on 19/07/2022.
//  
//

protocol MainScreenViewInput: AnyObject {
    func setup()
    func update(currencyList: [CurrencyItemModel])
    func showHideConvertButton(show: Bool)
    func showHideRefreshButton(show: Bool)
    func showRates(rates: String)
}
