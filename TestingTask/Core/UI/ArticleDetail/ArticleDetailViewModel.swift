//
//  ArticleDetailViewModel.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import Foundation
import SwiftUI

@MainActor
class ArticleDetailViewModel: ObservableObject {
    @Published var image: UIImage?

    let article: ArticleViewModel

    init(article: ArticleViewModel) {
        self.article = article
        loadImage()
    }

    func loadImage() {
        article.loadImage { [weak self] image in
            self?.image = image
        }
    }

    func toggleFavorite() {
        article.addOrRemoveFromFavorites()
        objectWillChange.send()
    }
}
