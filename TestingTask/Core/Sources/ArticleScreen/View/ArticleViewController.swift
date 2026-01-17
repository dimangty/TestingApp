import UIKit

final class ArticleViewController: UIViewController, ViperModuleTransitionHandler {
    var presenter: ArticleViewOutput?

    @IBOutlet private weak var articleImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var articleHeaderLabel: UILabel!
    @IBOutlet private weak var articleContentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewLoaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
        presenter?.viewWillAppear()
    }

    @IBAction private func heartButtonTapped(_ sender: UIButton) {
        presenter?.heartTapped()
    }
}

extension ArticleViewController: ArticleViewInput {
    func setup() {
    }

    func display(title: String?, date: String, content: String?) {
        articleHeaderLabel.text = title
        dateLabel.text = date
        articleContentLabel.text = content
    }

    func displayImage(_ image: UIImage?) {
        articleImage.image = image
    }

    func displayLike(isFavorite: Bool) {
        if isFavorite {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
