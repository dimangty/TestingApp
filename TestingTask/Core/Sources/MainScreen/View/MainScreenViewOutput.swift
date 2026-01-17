//
//  MainScreenViewOutput.swift
//  TestingTask
//
//  Created by DBykov on 19/07/2022.
// 
//

protocol MainScreenViewOutput: AnyObject {
    func viewLoaded()
    func currencyTapped(currency: CurrencyItemModel) //Событие нажатия на ячейку
    func convertButtonTapped() //Событие нажатия на кнопку конвертировать
    func refreshButtonTapped() //Событие нажатия на кнопку обновить
}
