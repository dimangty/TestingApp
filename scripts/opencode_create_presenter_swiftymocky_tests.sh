#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
PRESENTER_NAME="${2:-}"
FRAMEWORK_RAW="${3:-xctest}"
OUT_FILE="${4:-}"

if [[ -z "$PRESENTER_NAME" ]]; then
  echo "Usage: bash scripts/opencode_create_presenter_swiftymocky_tests.sh <root_dir> <PresenterName> [xctest|swifttesting] [output_file]"
  exit 1
fi

ROOT_DIR="${ROOT_DIR%/}"
ROOT_DIR="$(cd "$ROOT_DIR" && pwd)"
FRAMEWORK="$(echo "$FRAMEWORK_RAW" | tr '[:upper:]' '[:lower:]')"

case "$FRAMEWORK" in
  xctest|unit|unittest)
    FRAMEWORK="xctest"
    FRAMEWORK_DESC="XCTest"
    IMPORT_RULES=$'import XCTest\nimport SwiftyMocky\n@testable import TestingTask'
    FRAMEWORK_STRUCTURE_RULE="Use XCTest style: final class <Name>Tests: XCTestCase with methods named func test...(). Do not use @Suite or @Test."
    DEFAULT_OUT_FILE="$ROOT_DIR/TestingTaskTests/${PRESENTER_NAME}Tests.swift"
    ;;
  swifttesting|swift-testing|testing)
    FRAMEWORK="swifttesting"
    FRAMEWORK_DESC="Swift Testing"
    IMPORT_RULES=$'import Foundation\nimport Testing\nimport SwiftyMocky\n@testable import TestingTask'
    FRAMEWORK_STRUCTURE_RULE="Use Swift Testing style: @Suite + @Test + #expect. Do not use XCTestCase."
    DEFAULT_OUT_FILE="$ROOT_DIR/TestingTaskTests/${PRESENTER_NAME}SwiftTestingTests.swift"
    ;;
  *)
    echo "ERROR: Unknown framework '$FRAMEWORK_RAW'. Use xctest or swifttesting."
    exit 1
    ;;
esac

if [[ -z "$OUT_FILE" ]]; then
  OUT_FILE="$DEFAULT_OUT_FILE"
elif [[ "$OUT_FILE" != /* ]]; then
  OUT_FILE="$ROOT_DIR/$OUT_FILE"
fi

SOURCE_FILE="$(find "$ROOT_DIR/TestingTask/Core/Sources" -type f -name "${PRESENTER_NAME}.swift" | head -n 1)"
if [[ -z "$SOURCE_FILE" ]]; then
  echo "ERROR: Presenter source not found for ${PRESENTER_NAME}"
  exit 1
fi

MOCKABLES_FILE="$ROOT_DIR/TestingTaskTests/ScreenMockables.swift"
GENERATED_MOCKS_FILE="$ROOT_DIR/TestingTaskTests/Support/Generated/Mock.generated.swift"
if [[ ! -f "$MOCKABLES_FILE" ]]; then
  echo "ERROR: Missing mockables file: $MOCKABLES_FILE"
  exit 1
fi
if [[ ! -f "$GENERATED_MOCKS_FILE" ]]; then
  echo "ERROR: Missing generated mocks file: $GENERATED_MOCKS_FILE"
  exit 1
fi

collect_presenter_methods() {
  grep -E '[[:space:]]func[[:space:]]+[A-Za-z_][A-Za-z0-9_]*[[:space:]]*\(' "$SOURCE_FILE" \
    | grep -Ev '^[[:space:]]*private[[:space:]]+.*func[[:space:]]+' \
    | sed -E 's/.*func[[:space:]]+([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*\(.*/\1/' \
    | grep -Ev '^init$' \
    | sort -u \
    || true
}

build_presenter_prompt_notes() {
  case "$PRESENTER_NAME" in
    LoginScreenPresenter)
      cat <<'EOF'
- Use only these generated SwiftyMocky mocks: LoginScreenViewInputMockableMock, LoginScreenRouterInputMockableMock, AuthServiceProtocolMockableMock.
- There is no ProgressServiceMock or ErrorServiceMock in this repository. Define local spy subclasses instead and assert on counters or captured messages.
- Inject services only with direct assignment:
  presenter.authService = authServiceMock
  presenter.progressService = progressServiceSpy
  presenter.errorService = errorServiceSpy
- Stub auth completion with Perform(authServiceMock, .login(phone: .any, completion: .any, perform: { _, completion in ... })).
- Never access private presenter state such as presenter.phone, presenter.isPhoneValid, or presenter.updateConfirmState().
- confirmTapped() returns early for invalid phone and must not show progress, call authService, or route in that branch.
EOF
      ;;
    SignUpScreenPresenter)
      cat <<'EOF'
- Use only these generated SwiftyMocky mocks: SignUpScreenViewInputMockableMock, SignUpScreenRouterInputMockableMock, AuthServiceProtocolMockableMock.
- There is no ValidationServiceMock, ProgressServiceMock, or ErrorServiceMock in this repository. Define local spy subclasses instead.
- Inject services only with direct assignment:
  presenter.authService = authServiceMock
  presenter.validationService = validationServiceSpy
  presenter.progressService = progressServiceSpy
  presenter.errorService = errorServiceSpy
- ValidationServiceSpy should override isValid(field:value:). ProgressServiceSpy should override show()/hide(). ErrorServiceSpy should override show(errorText:).
- Use Perform(authServiceMock, .signUp(data: .any, completion: .any, perform: { _, completion in ... })) for async auth results.
- Never access private presenter state such as presenter.fields or presenter.updateCreateState().
- createAccountTapped() currently does not guard against invalid data before calling authService; tests must reflect the real implementation.
EOF
      ;;
    NewsPresenter)
      cat <<'EOF'
- Use only these generated SwiftyMocky mocks: NewsViewInputMockableMock and NewsRouterInputMockableMock.
- Do not invent NewsServiceMock, StorageServiceMock, IStorageServiceMock, ErrorServiceMock, TestConfigurator, registerService, or setupForTesting helpers.
- newsService, storage, and errorService are private @Injected concrete services. Do not invent injection helpers such as presenter.injected { ... }.
- If a dependency cannot be replaced through the current public API, write only real tests for behavior reachable without replacing those private services.
- Good candidates are setup, loading indicator start, empty-state row count, search reload with no loaded articles, viewWillAppear, and didRemoveFromFavorites when the title is absent.
EOF
      ;;
    FavoritePresenter)
      cat <<'EOF'
- Use only these generated SwiftyMocky mocks: FavoriteViewInputMockableMock and FavoriteRouterInputMockableMock.
- Do not invent StorageServiceMock, IStorageServiceMock, TestConfigurator, or injection helpers.
- storage is a private @Injected concrete service. If you cannot replace it through an existing seam, only test behavior reachable with the current public API.
- Good candidates are setup, empty row count before storage-driven reloads, navigation calls that depend only on prepared state, and observer no-op/empty-state behavior when state is under direct presenter control.
EOF
      ;;
    ArticlePresenter)
      cat <<'EOF'
- Use only these generated SwiftyMocky mocks: ArticleViewInputMockableMock and ArticleRouterInputMockableMock.
- There is no StorageServiceMock or IStorageServiceMock in this repository. Define a local StorageSpy that conforms to IStorageService.
- Build ArticleViewModel with ArticleViewModel(article:storage:). Use an article whose urlToImage is nil so viewLoaded stays deterministic and does not depend on networking.
- Assert view.display(...), view.displayLike(...), and favorite toggling through StorageSpy side effects.
EOF
      ;;
    *)
      cat <<'EOF'
- Reuse only mock types that are explicitly present in ScreenMockables.swift and Mock.generated.swift.
- Do not invent container helpers, injection wrappers, or mock classes that are not present in the provided project context.
EOF
      ;;
  esac
}

append_prompt_attachment_file() {
  local path="$1"

  if [[ -f "$path" ]]; then
    PROMPT_ATTACHMENT_FILES+=("$path")
  fi
}

collect_prompt_attachment_files() {
  PROMPT_ATTACHMENT_FILES=("$SOURCE_FILE" "$MOCKABLES_FILE")

  case "$PRESENTER_NAME" in
    LoginScreenPresenter)
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/LoginScreen/View/LoginScreenViewInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/LoginScreen/Router/LoginScreenRouterInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Data/AuthService/AuthService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Application/Configuration/Injected.swift"
      ;;
    SignUpScreenPresenter)
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/SignUpScreen/View/SignUpScreenViewInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/SignUpScreen/Router/SignUpScreenRouterInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Data/AuthService/AuthService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Presentation/ValidationService/ValidationService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/POSO/SignUpData.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/POSO/SignUpField.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Application/Configuration/Injected.swift"
      ;;
    NewsPresenter)
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/NewsScreen/View/NewsViewInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/NewsScreen/Router/NewsRouterInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Data/NewsService/INewsService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Data/Storage/IStorageService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/POSO/ArticleViewModel.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/DTO/News/Article.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Application/Configuration/Injected.swift"
      ;;
    FavoritePresenter)
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/FavoriteScreen/View/FavoriteViewInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/FavoriteScreen/Router/FavoriteRouterInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Data/Storage/IStorageService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/POSO/ArticleViewModel.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/DTO/News/Article.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Application/Configuration/Injected.swift"
      ;;
    ArticlePresenter)
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/ArticleScreen/View/ArticleViewInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Sources/ArticleScreen/Router/ArticleRouterInput.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/POSO/ArticleViewModel.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Services/Data/Storage/IStorageService.swift"
      append_prompt_attachment_file "$ROOT_DIR/TestingTask/Core/Models/DTO/News/Article.swift"
      ;;
  esac
}

generate_local_fallback_tests() {
  if [[ "$PRESENTER_NAME" == "LoginScreenPresenter" && "$FRAMEWORK" == "xctest" ]]; then
    cat >"$OUT_FILE" <<'SWIFT'
import XCTest
import SwiftyMocky
@testable import TestingTask

final class LoginScreenPresenterTests: XCTestCase {
    func test_viewLoaded_setsUpView_andDisablesConfirmButton_whenPhoneIsEmpty() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .updateConfirmButton(enabled: false))
    }

    func test_confirmTapped_doesNotAuthenticate_whenPhoneIsInvalid() {
        // Given
        let context = makeContext()

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.view, .once, .updateConfirmButton(enabled: false))
        Verify(context.authService, .never, .login(phone: .any, completion: .any))
        Verify(context.router, .never, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 0)
        XCTAssertEqual(context.progressService.hideCallCount, 0)
        XCTAssertTrue(context.errorService.messages.isEmpty)
    }

    func test_confirmTapped_authenticatesAndRoutesToMain_onSuccess() {
        // Given
        let context = makeContext()
        Perform(context.authService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))
        context.presenter.phoneChanged("1234567")

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .once, .login(phone: "1234567", completion: .any))
        Verify(context.router, .once, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertTrue(context.errorService.messages.isEmpty)
    }

    func test_confirmTapped_showsError_onFailure() {
        // Given
        let context = makeContext()
        Perform(context.authService, .login(phone: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidPhone))
        }))
        context.presenter.phoneChanged("1234567")

        // When
        context.presenter.confirmTapped()

        // Then
        Verify(context.authService, .once, .login(phone: "1234567", completion: .any))
        Verify(context.router, .never, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertEqual(context.errorService.messages, ["Invalid phone number"])
    }

    func test_signUpTapped_opensSignUpScreen() {
        // Given
        let context = makeContext()

        // When
        context.presenter.signUpTapped()

        // Then
        Verify(context.router, .once, .openSignUpScreen())
    }
}

private extension LoginScreenPresenterTests {
    typealias Context = (
        presenter: LoginScreenPresenter,
        view: LoginScreenViewInputMockableMock,
        router: LoginScreenRouterInputMockableMock,
        authService: AuthServiceProtocolMockableMock,
        progressService: ProgressServiceSpy,
        errorService: ErrorServiceSpy
    )

    func makeContext() -> Context {
        let view = LoginScreenViewInputMockableMock()
        let router = LoginScreenRouterInputMockableMock()
        let authService = AuthServiceProtocolMockableMock()
        let progressService = ProgressServiceSpy()
        let errorService = ErrorServiceSpy()
        let presenter = LoginScreenPresenter(view: view, router: router)

        presenter.authService = authService
        presenter.progressService = progressService
        presenter.errorService = errorService

        return (presenter, view, router, authService, progressService, errorService)
    }
}

private final class ProgressServiceSpy: ProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0

    override func show() {
        showCallCount += 1
    }

    override func hide() {
        hideCallCount += 1
    }
}

private final class ErrorServiceSpy: ErrorService {
    private(set) var messages: [String] = []

    override func show(errorText: String) {
        messages.append(errorText)
    }
}
SWIFT
    return
  fi

  if [[ "$PRESENTER_NAME" == "SignUpScreenPresenter" && "$FRAMEWORK" == "xctest" ]]; then
    cat >"$OUT_FILE" <<'SWIFT'
import XCTest
import SwiftyMocky
@testable import TestingTask

final class SignUpScreenPresenterTests: XCTestCase {
    func test_viewLoaded_setsUpView_andDisablesCreateButton_whenFieldsAreEmpty() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .updateCreateButton(enabled: false))
    }

    func test_fieldChanged_enablesCreateButton_whenAllFieldsBecomeValid() {
        // Given
        let context = makeContext()

        // When
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // Then
        Verify(context.view, .moreOrEqual(to: 1), .updateCreateButton(enabled: true))
    }

    func test_createAccountTapped_routesToMain_onSuccess() {
        // Given
        let context = makeContext()
        var capturedData: SignUpData?
        Perform(context.authService, .signUp(data: .any, completion: .any, perform: { data, completion in
            capturedData = data
            completion(.success(()))
        }))
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // When
        context.presenter.createAccountTapped()

        // Then
        Verify(context.authService, .once, .signUp(data: .any, completion: .any))
        Verify(context.router, .once, .openMainScreen())
        XCTAssertEqual(capturedData?.fields[.email], validFields[.email])
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertTrue(context.errorService.messages.isEmpty)
    }

    func test_createAccountTapped_showsError_onFailure() {
        // Given
        let context = makeContext()
        Perform(context.authService, .signUp(data: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidData))
        }))
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // When
        context.presenter.createAccountTapped()

        // Then
        Verify(context.authService, .once, .signUp(data: .any, completion: .any))
        Verify(context.router, .never, .openMainScreen())
        XCTAssertEqual(context.progressService.showCallCount, 1)
        XCTAssertEqual(context.progressService.hideCallCount, 1)
        XCTAssertEqual(context.errorService.messages, ["Sign up failed"])
    }

    func test_backTapped_closesScreen() {
        // Given
        let context = makeContext()

        // When
        context.presenter.backTapped()

        // Then
        Verify(context.router, .once, .close())
    }
}

private extension SignUpScreenPresenterTests {
    typealias Context = (
        presenter: SignUpScreenPresenter,
        view: SignUpScreenViewInputMockableMock,
        router: SignUpScreenRouterInputMockableMock,
        authService: AuthServiceProtocolMockableMock,
        validationService: ValidationServiceSpy,
        progressService: ProgressServiceSpy,
        errorService: ErrorServiceSpy
    )

    var validFields: [SignUpField: String] {
        [
            .firstName: "John",
            .lastName: "Appleseed",
            .gender: "male",
            .birthDate: "01-01-1990",
            .country: "USA",
            .city: "NYC",
            .email: "john@example.com",
            .phone: "1234567890"
        ]
    }

    func makeContext() -> Context {
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let authService = AuthServiceProtocolMockableMock()
        let validationService = ValidationServiceSpy()
        let progressService = ProgressServiceSpy()
        let errorService = ErrorServiceSpy()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        presenter.authService = authService
        presenter.validationService = validationService
        presenter.progressService = progressService
        presenter.errorService = errorService

        return (presenter, view, router, authService, validationService, progressService, errorService)
    }
}

private final class ValidationServiceSpy: ValidationService {
    override func isValid(field: SignUpField, value: String) -> Bool {
        switch field {
        case .email:
            return value.contains("@") && value.contains(".")
        case .phone:
            let digits = value.filter(\.isNumber)
            return digits.count >= 7 && digits.count <= 15 && digits.count == value.count
        default:
            return !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
}

private final class ProgressServiceSpy: ProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0

    override func show() {
        showCallCount += 1
    }

    override func hide() {
        hideCallCount += 1
    }
}

private final class ErrorServiceSpy: ErrorService {
    private(set) var messages: [String] = []

    override func show(errorText: String) {
        messages.append(errorText)
    }
}
SWIFT
    return
  fi

  if [[ "$PRESENTER_NAME" == "NewsPresenter" && "$FRAMEWORK" == "xctest" ]]; then
    cat >"$OUT_FILE" <<'SWIFT'
import XCTest
import SwiftyMocky
@testable import TestingTask

final class NewsPresenterTests: XCTestCase {
    func test_viewLoaded_setsUpView_andStartsLoading() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .showLoading(.value(true)))
    }

    func test_viewWillAppear_updatesSelectedCell() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewWillAppear()

        // Then
        Verify(context.view, .once, .updateSelectedCell())
    }

    func test_numberOfRows_isZeroInitially() {
        // Given
        let context = makeContext()

        // When
        let rows = context.presenter.numberOfRows()

        // Then
        XCTAssertEqual(rows, 0)
    }

    func test_didUpdateSearch_reloadsData_whenNoArticlesLoaded() {
        // Given
        let context = makeContext()

        // When
        context.presenter.didUpdateSearch(text: "swift")

        // Then
        Verify(context.view, .once, .reloadData())
        XCTAssertEqual(context.presenter.numberOfRows(), 0)
    }

    func test_didRemoveFromFavorites_doesNothing_whenArticleIsAbsent() {
        // Given
        let context = makeContext()

        // When
        context.presenter.didRemoveFromFavorites(title: "missing")

        // Then
        Verify(context.view, .never, .updateFavorite(at: .any))
    }
}

private extension NewsPresenterTests {
    typealias Context = (
        presenter: NewsPresenter,
        view: NewsViewInputMockableMock,
        router: NewsRouterInputMockableMock
    )

    func makeContext() -> Context {
        let view = NewsViewInputMockableMock()
        let router = NewsRouterInputMockableMock()
        let presenter = NewsPresenter(view: view, router: router)
        return (presenter, view, router)
    }
}
SWIFT
    return
  fi

  if [[ "$PRESENTER_NAME" == "SignUpScreenPresenter" && "$FRAMEWORK" == "swifttesting" ]]; then
    cat >"$OUT_FILE" <<'SWIFT'
import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("SignUpScreenPresenter SwiftTesting")
struct SignUpScreenPresenterSwiftTestingTests {
    @Test("viewLoaded sets up screen and disables create button")
    func viewLoaded_setsUpScreen_andDisablesCreateButton() {
        // Given
        let context = makeContext()

        // When
        context.presenter.viewLoaded()

        // Then
        Verify(context.view, .once, .setup())
        Verify(context.view, .once, .updateCreateButton(enabled: .value(false)))
    }

    @Test("fieldChanged keeps create disabled while data is incomplete")
    func fieldChanged_keepsCreateDisabled_whenDataIsIncomplete() {
        // Given
        let context = makeContext()

        // When
        context.presenter.fieldChanged(.email, value: "user@example.com")

        // Then
        Verify(context.view, .once, .updateCreateButton(enabled: .value(false)))
    }

    @Test("fieldChanged enables create when all fields are valid")
    func fieldChanged_enablesCreate_whenAllFieldsAreValid() {
        // Given
        let context = makeContext()

        // When
        for (field, value) in validFields {
            context.presenter.fieldChanged(field, value: value)
        }

        // Then
        Verify(context.view, .moreOrEqual(to: 1), .updateCreateButton(enabled: .value(true)))
    }

    @Test("createAccountTapped opens main screen on success")
    func createAccountTapped_opensMainScreen_onSuccess() {
        // Given
        let context = makeContext()
        Perform(context.authService, .signUp(data: .any, completion: .any, perform: { _, completion in
            completion(.success(()))
        }))

        // When
        context.presenter.createAccountTapped()

        // Then
        Verify(context.authService, .once, .signUp(data: .any, completion: .any))
        Verify(context.router, .once, .openMainScreen())
        #expect(context.progressService.showCallCount == 1)
        #expect(context.progressService.hideCallCount == 1)
        #expect(context.errorService.messages.isEmpty)
    }

    @Test("createAccountTapped shows error on failure")
    func createAccountTapped_showsError_onFailure() {
        // Given
        let context = makeContext()
        Perform(context.authService, .signUp(data: .any, completion: .any, perform: { _, completion in
            completion(.failure(AuthError.invalidData))
        }))

        // When
        context.presenter.createAccountTapped()

        // Then
        Verify(context.authService, .once, .signUp(data: .any, completion: .any))
        Verify(context.router, .never, .openMainScreen())
        #expect(context.progressService.showCallCount == 1)
        #expect(context.progressService.hideCallCount == 1)
        #expect(context.errorService.messages == ["Sign up failed"])
    }

    @Test("backTapped closes sign up screen")
    func backTapped_closesScreen() {
        // Given
        let context = makeContext()

        // When
        context.presenter.backTapped()

        // Then
        Verify(context.router, .once, .close())
    }
}

private extension SignUpScreenPresenterSwiftTestingTests {
    typealias Context = (
        presenter: SignUpScreenPresenter,
        view: SignUpScreenViewInputMockableMock,
        router: SignUpScreenRouterInputMockableMock,
        authService: AuthServiceProtocolMockableMock,
        validationService: ValidationServiceSpy,
        progressService: ProgressServiceSpy,
        errorService: ErrorServiceSpy
    )

    var validFields: [SignUpField: String] {
        [
            .firstName: "John",
            .lastName: "Appleseed",
            .gender: "male",
            .birthDate: "01-01-1990",
            .country: "USA",
            .city: "NYC",
            .email: "john@example.com",
            .phone: "1234567890"
        ]
    }

    func makeContext() -> Context {
        let view = SignUpScreenViewInputMockableMock()
        let router = SignUpScreenRouterInputMockableMock()
        let authService = AuthServiceProtocolMockableMock()
        let validationService = ValidationServiceSpy()
        let progressService = ProgressServiceSpy()
        let errorService = ErrorServiceSpy()
        let presenter = SignUpScreenPresenter(view: view, router: router)

        presenter.authService = authService
        presenter.validationService = validationService
        presenter.progressService = progressService
        presenter.errorService = errorService

        return (presenter, view, router, authService, validationService, progressService, errorService)
    }
}

private final class ValidationServiceSpy: ValidationService {
    override func isValid(field: SignUpField, value: String) -> Bool {
        !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

private final class ProgressServiceSpy: ProgressService {
    private(set) var showCallCount = 0
    private(set) var hideCallCount = 0

    override func show() {
        showCallCount += 1
    }

    override func hide() {
        hideCallCount += 1
    }
}

private final class ErrorServiceSpy: ErrorService {
    private(set) var messages: [String] = []

    override func show(errorText: String) {
        messages.append(errorText)
    }
}
SWIFT
    return
  fi

  local methods=()
  while IFS= read -r method; do
    [[ -n "$method" ]] && methods+=("$method")
  done < <(collect_presenter_methods)

  if [[ ${#methods[@]} -eq 0 ]]; then
    methods=("viewLoaded")
  fi

  if [[ "$FRAMEWORK" == "xctest" ]]; then
    {
      cat <<EOF
import XCTest
import SwiftyMocky
@testable import TestingTask

final class ${PRESENTER_NAME}Tests: XCTestCase {
    func test_presenterType_isAvailable() {
        XCTAssertEqual(String(describing: ${PRESENTER_NAME}.self), "${PRESENTER_NAME}")
    }

EOF
      for method in "${methods[@]}"; do
        local sanitized_method
        sanitized_method="$(echo "$method" | sed 's/[^A-Za-z0-9_]/_/g')"
        cat <<EOF
    func test_${sanitized_method}_smoke() {
        XCTAssertFalse("${method}".isEmpty)
    }

EOF
      done
      cat <<EOF
}
EOF
    } >"$OUT_FILE"
  else
    {
      cat <<EOF
import Foundation
import Testing
import SwiftyMocky
@testable import TestingTask

@Suite("${PRESENTER_NAME} SwiftTesting")
struct ${PRESENTER_NAME}SwiftTestingTests {
    @Test("Presenter type is available")
    func presenterType_isAvailable() {
        #expect(String(describing: ${PRESENTER_NAME}.self) == "${PRESENTER_NAME}")
    }

EOF
      for method in "${methods[@]}"; do
        local sanitized_method
        sanitized_method="$(echo "$method" | sed 's/[^A-Za-z0-9_]/_/g')"
        cat <<EOF
    @Test("Smoke: ${method}")
    func ${sanitized_method}_smoke() {
        #expect(!"${method}".isEmpty)
    }

EOF
      done
      cat <<EOF
}
EOF
    } >"$OUT_FILE"
  fi
}

mkdir -p "$(dirname "$OUT_FILE")"

OPENCODE_BIN="${OPENCODE_CLI:-/Applications/OpenCode.app/Contents/MacOS/opencode-cli}"
if [[ ! -x "$OPENCODE_BIN" ]]; then
  OPENCODE_BIN="$(command -v opencode-cli || true)"
fi
if [[ -z "$OPENCODE_BIN" || ! -x "$OPENCODE_BIN" ]]; then
  echo "ERROR: opencode-cli not found. Set OPENCODE_CLI or install OpenCode CLI."
  exit 1
fi

OPENCODE_MODEL="${OPENCODE_MODEL:-ollama/qwen3-coder:30b}"
OPENCODE_VARIANT="${OPENCODE_VARIANT:-minimal}"

AVAILABLE_GENERATED_MOCKS="$(
  rg -o '[A-Za-z_][A-Za-z0-9_]*MockableMock' "$GENERATED_MOCKS_FILE" \
    | sort -u \
    | tr '\n' ' '
)"

PROMPT_FILE="$(mktemp "${TMPDIR:-/tmp}/opencode-presenter-prompt.XXXXXX")"
RUN_LOG_FILE="$(mktemp "${TMPDIR:-/tmp}/opencode-presenter-run.XXXXXX")"
JSON_OUTPUT_FILE="$(mktemp "${TMPDIR:-/tmp}/opencode-presenter-json.XXXXXX")"
TEXT_OUTPUT_FILE="$(mktemp "${TMPDIR:-/tmp}/opencode-presenter-text.XXXXXX")"
trap 'rm -f "$PROMPT_FILE" "$RUN_LOG_FILE" "$JSON_OUTPUT_FILE" "$TEXT_OUTPUT_FILE"' EXIT

MAX_ATTEMPTS="${OPENCODE_MAX_ATTEMPTS:-3}"
LAST_ERROR=""
SUCCESS=0
PROJECT_PROMPT_NOTES="$(build_presenter_prompt_notes)"
collect_prompt_attachment_files
ATTACHED_FILES_LIST="$(
  for path in "${PROMPT_ATTACHMENT_FILES[@]}"; do
    printf -- '- %s\n' "${path#$ROOT_DIR/}"
  done
)"

for ((attempt = 1; attempt <= MAX_ATTEMPTS; attempt++)); do
  RETRY_NOTE=""
  if [[ "$attempt" -gt 1 ]]; then
    RETRY_NOTE="Previous output was invalid: ${LAST_ERROR}. Fix this and return only a valid swift code block."
  fi

  cat >"$PROMPT_FILE" <<EOF
Generate only the Swift source code for one test file.
No analysis text. No explanation.

Target presenter: ${PRESENTER_NAME}
Target framework: ${FRAMEWORK_DESC}
Exact output file path: ${OUT_FILE}

Strict requirements:
1. Preferred flow: use the write tool exactly once to write the complete Swift file to ${OUT_FILE}, then reply only with: DONE: ${OUT_FILE}
2. If you do not use the write tool, return only one Markdown code block with language tag swift.
3. Never call any tool other than write.
4. If you use the write tool, filePath must be exactly ${OUT_FILE}. Never write anywhere else.
5. The code must be a complete test file.
6. Do not include TODO, FIXME, fatalError, or XCTFail("TODO").
7. Do not invent APIs that do not exist in the provided source.
8. Reuse SwiftyMocky mocks when possible.
9. Add real behavior checks (lifecycle + success path + failure/invalid path + routing if applicable).
10. Keep tests deterministic.
11. Use exact imports:
${IMPORT_RULES}
12. ${FRAMEWORK_STRUCTURE_RULE}
13. Never include prose before or after the final DONE line or code block.
14. Do not output smoke placeholders such as XCTAssertTrue(true), #expect(true), or assertions that only check constant literals.
15. Use Given/When/Then comments for readability when helpful.

Project-specific testing rules:
${PROJECT_PROMPT_NOTES}

Available generated mock class names:
${AVAILABLE_GENERATED_MOCKS}

Attached project files:
${ATTACHED_FILES_LIST}

${RETRY_NOTE}
EOF

  CMD=("$OPENCODE_BIN" run --dir "$ROOT_DIR" -m "$OPENCODE_MODEL" --format json)
  if [[ -n "$OPENCODE_VARIANT" ]]; then
    CMD+=(--variant "$OPENCODE_VARIANT")
  fi
  for attachment in "${PROMPT_ATTACHMENT_FILES[@]}"; do
    CMD+=("--file=${attachment}")
  done
  CMD+=(-- "$(cat "$PROMPT_FILE")")

  if ! XDG_DATA_HOME="${XDG_DATA_HOME:-/tmp}" \
    XDG_STATE_HOME="${XDG_STATE_HOME:-/tmp}" \
    XDG_CACHE_HOME="${XDG_CACHE_HOME:-/tmp}" \
    "${CMD[@]}" >"$JSON_OUTPUT_FILE" 2>"$RUN_LOG_FILE"; then
    LAST_ERROR="opencode-cli failed: $(sed -n '1,5p' "$RUN_LOG_FILE" | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')"
    continue
  fi

  if ! jq -e . "$JSON_OUTPUT_FILE" >/dev/null 2>&1; then
    LAST_ERROR="opencode-cli returned non-JSON output: $(sed -n '1,5p' "$RUN_LOG_FILE" | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')"
    continue
  fi

  MODEL_ERROR_TEXT="$(jq -r 'select(.type=="error") | (.error.data.message // .error.message // .error.name // empty)' "$JSON_OUTPUT_FILE" | head -n 1)"
  if [[ -n "$MODEL_ERROR_TEXT" ]]; then
    LAST_ERROR="opencode-cli error: ${MODEL_ERROR_TEXT}"
    continue
  fi

  WRITE_ERROR_TEXT="$(jq -r 'select(.type=="tool_use" and .part.tool=="write" and (.part.state.status=="error" or .part.state.status=="failed")) | (.part.state.input.filePath // "unknown-path") + ": " + (.part.state.error // "write failed")' "$JSON_OUTPUT_FILE" | head -n 1)"
  WRONG_WRITE_PATH="$(jq -r --arg out "$OUT_FILE" 'select(.type=="tool_use" and .part.tool=="write" and .part.state.input.filePath != null and .part.state.input.filePath != $out) | .part.state.input.filePath' "$JSON_OUTPUT_FILE" | head -n 1)"
  SUCCESSFUL_WRITE_PATH="$(jq -r --arg out "$OUT_FILE" 'select(.type=="tool_use" and .part.tool=="write" and .part.state.status=="completed" and .part.state.input.filePath == $out) | .part.state.input.filePath' "$JSON_OUTPUT_FILE" | head -n 1)"

  if [[ -n "$WRONG_WRITE_PATH" ]]; then
    LAST_ERROR="model attempted to write to unexpected path: ${WRONG_WRITE_PATH}"
    continue
  fi

  GENERATED_VIA_WRITE=0
  if [[ "$SUCCESSFUL_WRITE_PATH" == "$OUT_FILE" && -s "$OUT_FILE" ]]; then
    GENERATED_VIA_WRITE=1
  fi

  if [[ "$GENERATED_VIA_WRITE" -ne 1 ]]; then
    jq -r 'select(.type=="text" and .part.text != null) | .part.text' "$JSON_OUTPUT_FILE" >"$TEXT_OUTPUT_FILE"
    if [[ ! -s "$TEXT_OUTPUT_FILE" ]]; then
      if [[ -n "$WRITE_ERROR_TEXT" ]]; then
        LAST_ERROR="write tool failed: ${WRITE_ERROR_TEXT}"
      else
        LAST_ERROR="empty model response"
      fi
      continue
    fi

    if rg -n '^```swift' "$TEXT_OUTPUT_FILE" >/dev/null 2>&1; then
      awk '
        BEGIN { in_code = 0 }
        /^```swift[[:space:]]*$/ {
          if (in_code == 0) {
            in_code = 1
            next
          }
        }
        /^```[[:space:]]*$/ {
          if (in_code == 1) {
            in_code = 0
            exit
          }
        }
        in_code == 1 { print }
      ' "$TEXT_OUTPUT_FILE" >"$OUT_FILE"
    elif rg -n '^```' "$TEXT_OUTPUT_FILE" >/dev/null 2>&1; then
      awk '
        BEGIN { in_code = 0 }
        /^```/ {
          if (in_code == 0) {
            in_code = 1
            next
          }
          in_code = 0
          exit
        }
        in_code == 1 { print }
      ' "$TEXT_OUTPUT_FILE" >"$OUT_FILE"
    else
      cp "$TEXT_OUTPUT_FILE" "$OUT_FILE"
    fi
  fi

  if [[ ! -s "$OUT_FILE" ]]; then
    LAST_ERROR="generated file is empty"
    continue
  fi

  if rg -n '<function=|</function>|<tool_call>|</tool_call>|<parameter=' "$OUT_FILE" >/dev/null 2>&1; then
    LAST_ERROR="model returned tool-call markup instead of pure Swift"
    continue
  fi

  FIRST_SIGNIFICANT_LINE="$(awk '
    /^[[:space:]]*$/ { next }
    /^[[:space:]]*\/\// { next }
    { print; exit }
  ' "$OUT_FILE")"
  if [[ "$FIRST_SIGNIFICANT_LINE" != import* ]]; then
    LAST_ERROR="generated file does not have Swift imports before declarations"
    continue
  fi

  if rg -n -i 'TODO|FIXME|fatalError\(|XCTFail\("TODO"|#expect\(Bool\(false\)|XCTAssertTrue\(true\)|#expect\(true\)' "$OUT_FILE" >/dev/null 2>&1; then
    LAST_ERROR="generated tests contain placeholders"
    continue
  fi

  if rg -n '@testable import XCTestTask|TestConfigurator\b|setupForTesting\b|registerService\b|presenter\.injected\b|\.stubbed[A-Z]|ProgressServiceMock\b|ErrorServiceMock\b|ValidationServiceMock\b|NewsServiceMock\b|IStorageServiceMock\b|StorageServiceMock\b|LoginScreenViewInputMock\b|LoginScreenRouterInputMock\b|SignUpScreenViewInputMock\b|SignUpScreenRouterInputMock\b|NewsViewInputMock\b|NewsRouterInputMock\b|FavoriteViewInputMock\b|FavoriteRouterInputMock\b|ArticleViewInputMock\b|ArticleRouterInputMock\b|AuthServiceProtocolMock\b|ValidationServiceMockableMock|ProgressServiceMockableMock|ErrorServiceMockableMock|NewsServiceMockableMock|StorageServiceMockableMock|injectedNewsService|injectedStorage|injectedErrorService|didUpdateSearchText|\bstub\(|\bgiven\(|called\[|verify\(call:|\bWait\(|test_presenterType_isAvailable|presenterType_isAvailable|\bpresenter\.(phone|fields|isPhoneValid|updateConfirmState|updateCreateState|loadArticles|applyFilter|articles|allArticles|searchText)\b|XCTAssertFalse\("[^"]+"\.isEmpty\)|#expect\(!"[^"]+"\.[^)]*\)' "$OUT_FILE" >/dev/null 2>&1; then
    LAST_ERROR="output uses invented mocks, invalid helpers, private presenter members, or smoke-only assertions"
    continue
  fi

  case "$FRAMEWORK" in
    xctest)
      if ! rg -n 'import XCTest' "$OUT_FILE" >/dev/null 2>&1 || ! rg -n 'XCTestCase' "$OUT_FILE" >/dev/null 2>&1 || ! rg -n 'func test' "$OUT_FILE" >/dev/null 2>&1; then
        LAST_ERROR="output is not valid XCTest structure"
        continue
      fi
      if rg -n 'func[[:space:]]+test[[:space:]]+[A-Za-z_]' "$OUT_FILE" >/dev/null 2>&1 || rg -n '@Suite|@Test|#expect\(' "$OUT_FILE" >/dev/null 2>&1; then
        LAST_ERROR="output contains invalid XCTest method syntax or mixed frameworks"
        continue
      fi
      ;;
    swifttesting)
      if ! rg -n 'import Testing' "$OUT_FILE" >/dev/null 2>&1 || ! rg -n '@Suite' "$OUT_FILE" >/dev/null 2>&1 || ! rg -n '@Test' "$OUT_FILE" >/dev/null 2>&1 || ! rg -n '#expect\(' "$OUT_FILE" >/dev/null 2>&1; then
        LAST_ERROR="output is not valid Swift Testing structure"
        continue
      fi
      if rg -n 'XCTestCase|XCTestExpectation|wait\(' "$OUT_FILE" >/dev/null 2>&1; then
        LAST_ERROR="output mixes XCTest APIs into Swift Testing file"
        continue
      fi
      ;;
  esac

  SUCCESS=1
  break
done

if [[ "$SUCCESS" -ne 1 ]]; then
  generate_local_fallback_tests
  echo "WARNING: opencode-cli failed to produce valid ${FRAMEWORK_DESC} tests after ${MAX_ATTEMPTS} attempts. Fallback tests were generated. Last error: ${LAST_ERROR}" >&2
fi

echo "DONE: $OUT_FILE"
