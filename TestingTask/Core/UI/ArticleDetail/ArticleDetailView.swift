//
//  ArticleDetailView.swift
//  TestingTask
//
//  Migrated to SwiftUI with TCA
//

import SwiftUI
import ComposableArchitecture

struct ArticleDetailView: View {
    let store: StoreOf<ArticleDetailFeature>
    @State private var image: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                }

                HStack {
                    Text(store.article.publishedAt.toString(format: "d MMMM"))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button(action: {
                        store.send(.toggleFavorite)
                    }) {
                        Image(systemName: store.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)

                if let title = store.article.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                }

                if let description = store.article.description {
                    Text(description)
                        .font(.body)
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
            loadImage()
        }
    }

    private func loadImage() {
        guard let urlToImage = store.article.urlToImage else { return }

        DispatchQueue.global().async {
            guard let dataFromUrl = try? Data(contentsOf: urlToImage),
                  let imageFromWeb = UIImage(data: dataFromUrl) else { return }

            DispatchQueue.main.async {
                self.image = imageFromWeb
            }
        }
    }
}
