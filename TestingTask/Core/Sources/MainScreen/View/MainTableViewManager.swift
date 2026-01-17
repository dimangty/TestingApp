//
//  MainTableViewManager.swift
//  TestingTask
//
//  Created by DBykov on 19.07.2022.
//

import UIKit
class MainTableViewManager: NSObject {
    private weak var presenter: MainScreenViewOutput?
    private weak var tableView: UITableView?
    private var list: [CurrencyItemModel] = []
    
    init(tableView: UITableView, presenter: MainScreenViewOutput?) {
        super.init()
        
        self.presenter = presenter
        self.tableView = tableView
        
        let cellName = CurrencyCell.cellName
        tableView.register(UINib(nibName: cellName, bundle: nil),
                           forCellReuseIdentifier: cellName)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateCurrencyList(list: [CurrencyItemModel]) {
        self.list = list
        self.tableView?.isScrollEnabled = list.count != 0
        self.tableView?.reloadData()
    }
}

extension MainTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        list[indexPath.row].checked.toggle()
        presenter?.currencyTapped(currency: list[indexPath.row])
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
    }
}

extension MainTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.cellName) as? CurrencyCell else {
            return UITableViewCell()
        }
        
        let item = list[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
}
