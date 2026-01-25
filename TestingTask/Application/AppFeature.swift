//
//  AppFeature.swift
//  TestingTask
//
//  Main TCA Feature for App Navigation
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var login = LoginFeature.State()
    }

    enum Action {
        case path(StackActionOf<Path>)
        case login(LoginFeature.Action)
    }

    @Reducer(state: .equatable)
    enum Path {
        case signUp(SignUpFeature)
        case main(MainTabFeature)
        case articleDetail(ArticleDetailFeature)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.login) {
            LoginFeature()
        }

        Reduce { state, action in
            switch action {
            case .login(.loginResponse(.success)):
                state.path.append(.main(MainTabFeature.State()))
                return .none

            case .login(.signUpButtonTapped):
                state.path.append(.signUp(SignUpFeature.State()))
                return .none

            case .path(.element(id: _, action: .signUp(.signUpResponse(.success)))):
                state.path.append(.main(MainTabFeature.State()))
                return .none

            case .path(.element(id: _, action: .signUp(.backButtonTapped))):
                state.path.removeLast()
                return .none

            case .login, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

@Reducer
struct MainTabFeature {
    @ObservableState
    struct State: Equatable {
        var news = NewsFeature.State()
        var favorites = FavoriteFeature.State()
    }

    enum Action {
        case news(NewsFeature.Action)
        case favorites(FavoriteFeature.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.news, action: \.news) {
            NewsFeature()
        }

        Scope(state: \.favorites, action: \.favorites) {
            FavoriteFeature()
        }

        Reduce { state, action in
            switch action {
            case .news, .favorites:
                return .none
            }
        }
    }
}
