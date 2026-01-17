import Foundation

protocol FavoriteViewOutput: AnyObject {
    func viewLoaded()
    func viewWillAppear()
    func numberOfRows() -> Int
    func article(at indexPath: IndexPath) -> ArticleViewModel
    func didSelectRow(at indexPath: IndexPath)
    func didTapFavorite(at indexPath: IndexPath)
}
