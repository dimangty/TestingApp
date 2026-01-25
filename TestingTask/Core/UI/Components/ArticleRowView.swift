//
//  ArticleRowView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void

    @State private var image: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .cornerRadius(8)
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let title = article.title {
                        Text(title)
                            .font(.headline)
                            .lineLimit(2)
                    }

                    Text(article.publishedAt.toString(format: "d MMMM"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    onFavoriteTapped()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        guard let urlToImage = article.urlToImage else { return }

        DispatchQueue.global().async {
            guard let dataFromUrl = try? Data(contentsOf: urlToImage),
                  let imageFromWeb = UIImage(data: dataFromUrl) else { return }

            DispatchQueue.main.async {
                self.image = imageFromWeb
            }
        }
    }
}
