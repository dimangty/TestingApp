//
//  MainScreenViewController.swift
//  TestingTask
//
//  Created by DBykov on 19/07/2022.
//
//

import UIKit

class MainScreenViewController: UIViewController, ViperModuleTransitionHandler {
    var presenter: MainScreenViewOutput?
    var tableViewManager: MainTableViewManager?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var convertButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    @IBAction func convertButtonTapped(_ sender: Any) {
        presenter?.convertButtonTapped()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        presenter?.refreshButtonTapped()
    }
}

extension MainScreenViewController: MainScreenViewInput {
    func setup() {
        tableViewManager = MainTableViewManager(tableView: tableView,
                                                presenter: presenter)
    }
    
    func update(currencyList: [CurrencyItemModel]) {
        tableViewManager?.updateCurrencyList(list: currencyList)
    }
    
    func showHideConvertButton(show: Bool) {
        convertButton.isHidden = !show
    }
    
    func showHideRefreshButton(show: Bool) {
        refreshButton.isHidden = !show
    }
    
    func showRates(rates: String) {
        resultTextView.text = rates
    }
}
