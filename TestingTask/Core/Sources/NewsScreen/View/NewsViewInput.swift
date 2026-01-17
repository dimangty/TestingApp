import Foundation

protocol NewsViewInput: AnyObject {
    func setup()
    func showLoading(_ isLoading: Bool)
    func reloadData()
    func updateFavorite(at indexPath: IndexPath)
    func updateSelectedCell()
}
