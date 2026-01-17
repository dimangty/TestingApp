import Foundation

protocol NewsViewOutput: AnyObject {
    func viewLoaded()
    func viewWillAppear()
    func numberOfRows() -> Int
    func article(at indexPath: IndexPath) -> ArticleViewModel
    func didSelectRow(at indexPath: IndexPath)
    func didTapFavorite(at indexPath: IndexPath)
    func didUpdateSearch(text: String)
}
