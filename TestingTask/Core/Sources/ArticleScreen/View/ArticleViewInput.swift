import UIKit

protocol ArticleViewInput: AnyObject {
    func setup()
    func display(title: String?, date: String, content: String?)
    func displayImage(_ image: UIImage?)
    func displayLike(isFavorite: Bool)
}
