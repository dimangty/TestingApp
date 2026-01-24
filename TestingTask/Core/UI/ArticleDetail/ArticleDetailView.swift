//
//  ArticleDetailView.swift
//  TestingTask
//
//  Migrated to SwiftUI
//

import SwiftUI

struct ArticleDetailView: View {
    @StateObject private var viewModel: ArticleDetailViewModel

    init(article: ArticleViewModel) {
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(article: article))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                }

                HStack {
                    Text(viewModel.article.publishedAt)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button(action: {
                        viewModel.toggleFavorite()
                    }) {
                        Image(systemName: viewModel.article.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                if let title = viewModel.article.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                }

                if let contents = viewModel.article.contents {
                    Text(contents)
                        .font(.body)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
