import Foundation

protocol FavoriteViewInput: AnyObject {
    func setup()
    func reloadData()
    func updateFavorite(at indexPath: IndexPath)
    func updateSelectedCell()
    func showEmptyState(_ isEmpty: Bool)
}
