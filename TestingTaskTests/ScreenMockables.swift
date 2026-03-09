import Foundation
import UIKit
@testable import TestingTask

protocol AutoMockable {}

//sourcery: AutoMockable
protocol LoginScreenViewInputMockable: LoginScreenViewInput, AutoMockable {}

//sourcery: AutoMockable
protocol LoginScreenRouterInputMockable: LoginScreenRouterInput, AutoMockable {}

//sourcery: AutoMockable
protocol AuthServiceProtocolMockable: AuthServiceProtocol, AutoMockable {}

//sourcery: AutoMockable
protocol SignUpScreenViewInputMockable: SignUpScreenViewInput, AutoMockable {}

//sourcery: AutoMockable
protocol SignUpScreenRouterInputMockable: SignUpScreenRouterInput, AutoMockable {}

//sourcery: AutoMockable
protocol NewsViewInputMockable: NewsViewInput, AutoMockable {}

//sourcery: AutoMockable
protocol NewsRouterInputMockable: NewsRouterInput, AutoMockable {}

//sourcery: AutoMockable
protocol FavoriteViewInputMockable: FavoriteViewInput, AutoMockable {}

//sourcery: AutoMockable
protocol FavoriteRouterInputMockable: FavoriteRouterInput, AutoMockable {}

//sourcery: AutoMockable
protocol ArticleViewInputMockable: ArticleViewInput, AutoMockable {}

//sourcery: AutoMockable
protocol ArticleRouterInputMockable: ArticleRouterInput, AutoMockable {}
