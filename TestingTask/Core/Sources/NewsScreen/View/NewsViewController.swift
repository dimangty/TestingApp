import UIKit

final class NewsViewController: UIViewController, ViperModuleTransitionHandler {
    var presenter: NewsViewOutput?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.title = "News"
      
        presenter?.viewWillAppear()
    }
}

extension NewsViewController: NewsViewInput {
    func setup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ArticleTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ArticleTableViewCell.identifier)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by title"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func showLoading(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func reloadData() {
        tableView.reloadData()
    }

    func updateFavorite(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell else { return }
        let article = presenter?.article(at: indexPath)
        if let article = article {
            cell.update(by: article)
        }
    }

    func updateSelectedCell() {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        updateFavorite(at: selectedIndexPath)
    }
}

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        cell.selectionStyle = .none
        if let article = presenter?.article(at: indexPath) {
            cell.update(by: article)
        }
        cell.onFavoriteTapped = { [weak self, weak tableView, weak cell] in
            guard let self = self, let tableView = tableView, let cell = cell else { return }
            if let currentIndexPath = tableView.indexPath(for: cell) {
                self.presenter?.didTapFavorite(at: currentIndexPath)
            }
        }
        return cell
    }
}

extension NewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.didUpdateSearch(text: searchController.searchBar.text ?? "")
    }
}
