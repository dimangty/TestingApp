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
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: max(0, proxy.size.width - 32))
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 12) {
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

                        if let title = store.article.title {
                            Text(title)
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        if let description = store.article.description {
                            Text(description)
                                .font(.body)
                        }
                    }
                }
                .frame(width: max(0, proxy.size.width - 32), alignment: .leading)
                .padding(.horizontal, 16)
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
