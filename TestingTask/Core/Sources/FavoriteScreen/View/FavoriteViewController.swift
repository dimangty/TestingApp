import UIKit

final class FavoriteViewController: UIViewController, ViperModuleTransitionHandler {
    var presenter: FavoriteViewOutput?

    private let tableView = UITableView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.title = "Favorites"
        presenter?.viewWillAppear()
    }
}

extension FavoriteViewController: FavoriteViewInput {
    func setup() {
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyLabel.text = "No favorites yet"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ArticleTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: ArticleTableViewCell.identifier)

        view.addSubview(tableView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24)
        ])
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

    func showEmptyState(_ isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 256
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(at: indexPath)
    }
}

extension FavoriteViewController: UITableViewDataSource {
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
