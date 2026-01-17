import UIKit

final class ArticleTableViewCell: UITableViewCell {
    static let identifier = "ArticleTableViewCell"

    @IBOutlet private weak var panel: UIView!
    @IBOutlet private weak var articleImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var articleHeaderLabel: UILabel!
    @IBOutlet private weak var articleContentLabel: UILabel!

    var onFavoriteTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction private func heartButtonTapped(_ sender: UIButton) {
        onFavoriteTapped?()
    }

    func update(by article: ArticleViewModel) {
        articleImage.image = nil
        article.loadImage { [weak self] image in
            self?.articleImage.image = image
        }

        dateLabel.text = article.publishedAt
        articleHeaderLabel.text = article.title
        articleContentLabel.text = article.contents

        displayLikeStatus(articleViewModel: article)
    }

    private func displayLikeStatus(articleViewModel: ArticleViewModel) {
        if articleViewModel.isFavorite {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartButton.tintColor = UIColor(red: 1, green: 0.392, blue: 0.51, alpha: 1)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.tintColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        }
    }
}
