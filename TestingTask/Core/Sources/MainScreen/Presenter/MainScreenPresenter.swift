//
//  MainScreenPresenter.swift
//  TestingTask
//
//  Created by DBykov on 19/07/2022.
//  
//

class MainScreenPresenter {
    private weak var view: MainScreenViewInput?
    private let router: MainScreenRouterInput

    @Injected var errorService: ErrorService?
    @Injected var currateService: CurrateService?
    @Injected var progressService: ProgressService?
    @Injected var cacheService: CacheService?
    
    var selectedList: [CurrencyItemModel] = []
    
    init(view: MainScreenViewInput, router: MainScreenRouterInput) {
        self.view = view
        self.router = router
    }
}

extension MainScreenPresenter: MainScreenViewOutput {
    
    
    func viewLoaded() {
        self.view?.setup()
        loadList()
    }
    
    func convertButtonTapped() {
        
        var requestItems: [String] = []
        var cache: [String: String] = [:]
        
        for item in selectedList {
            if let rate = cacheService?.getRate(for: item.title) {
                cache[item.title] = rate
            } else {
                requestItems.append(item.title)
            }
        }
        
        if requestItems.isEmpty {
            var result: [String] = []
            for item in selectedList {
                result.append("\(item.title) : \(cache[item.title] ?? "")")
            }
            let rates = result.joined(separator: "\n")
            self.view?.showRates(rates: rates)
            return
        }
        
        
        let pairs = requestItems.joined(separator: ",")
        self.progressService?.show()
        
        currateService?.getRates(pairs: pairs,
                                 completion: { result in
            self.progressService?.hide()
            switch result {
            case .success(let data):
                if cache.isEmpty {
                    let rates = data.data.map {$0.key+" : " + $0.value}.joined(separator: "\n")
                    for item in data.data {
                        self.cacheService?.appendItem(title: item.key, value: item.value)
                    }
                    self.view?.showRates(rates: rates)
                } else {//Merge Results
                    var mergeResult:[String] = []
                    for item in self.selectedList {
                        if let rate = cache[item.title] {
                            mergeResult.append("\(item.title + " : " + rate)")
                        } else {
                            if let rate = data.data[item.title] {
                                mergeResult.append("\(item.title + " : " + rate)")
                            }
                            
                            for item in data.data {
                                self.cacheService?.appendItem(title: item.key, value: item.value)
                            }
                        }
                    }
                    
                    let rates = mergeResult.joined(separator: "\n")
                    self.view?.showRates(rates: rates)
                    
                }
            
                break
              
            case .failure(let error):
                if let error = error as? ErrorResponse {
                    print(error.message)
                    self.errorService?.show(errorText: error.message)
                } else {
                    print(error.localizedDescription)
                    self.errorService?.show(errorText: error.localizedDescription)
                }
            }
        })
    }
    
    func refreshButtonTapped() {
        loadList()
    }
    
    
    
    func currencyTapped(currency: CurrencyItemModel) {
        if let index = selectedList.firstIndex(where: {$0.title == currency.title}) {   //Currency Added
            selectedList.remove(at: index)
        } else {
            selectedList.append(currency)
        }
        
        
        
        self.view?.showHideConvertButton(show: !selectedList.isEmpty)
        
    }
    
    private func loadList() {
        progressService?.show()
        currateService?.getCurrencyList(completion: { result in
            self.progressService?.hide()
            switch result {
            case .success(let data):
                if data.data.count == 0 {
                    self.errorService?.show(errorText: data.message)
                    self.view?.showHideRefreshButton(show: true)
                } else {
                    let currencyList = data.data.map {CurrencyItemModel(title: $0, checked: false)}
                    self.view?.update(currencyList: currencyList)
                    self.view?.showHideRefreshButton(show: false)
                }
              
                break
              
            case .failure(let error):
                if let error = error as? ErrorResponse {
                    print(error.message)
                    if error.message.isEmpty {
                        self.errorService?.show(errorText: error.getType())
                    } else {
                        self.errorService?.show(errorText: error.message)
                    }
                    
                    self.view?.showHideRefreshButton(show: true)
                } else {
                    print(error.localizedDescription)
                    self.errorService?.show(errorText: error.localizedDescription)
                    self.view?.showHideRefreshButton(show: true)
                }
            }
        })
    }
    
    
    
    
    
}
