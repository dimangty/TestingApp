// Generated using Sourcery 1.8.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
@testable import TestingTask


// MARK: - ArticleRouterInput

open class ArticleRouterInputMock: ArticleRouterInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }






    fileprivate struct MethodType {
        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult { return .match }
        func intValue() -> Int { return 0 }
        func assertionName() -> String { return "" }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - ArticleViewInput

open class ArticleViewInputMock: ArticleViewInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func setup() {
        addInvocation(.m_setup)
		let perform = methodPerformValue(.m_setup) as? () -> Void
		perform?()
    }

    open func display(title: String?, date: String, content: String?) {
        addInvocation(.m_display__title_titledate_datecontent_content(Parameter<String?>.value(`title`), Parameter<String>.value(`date`), Parameter<String?>.value(`content`)))
		let perform = methodPerformValue(.m_display__title_titledate_datecontent_content(Parameter<String?>.value(`title`), Parameter<String>.value(`date`), Parameter<String?>.value(`content`))) as? (String?, String, String?) -> Void
		perform?(`title`, `date`, `content`)
    }

    open func displayImage(_ image: UIImage?) {
        addInvocation(.m_displayImage__image(Parameter<UIImage?>.value(`image`)))
		let perform = methodPerformValue(.m_displayImage__image(Parameter<UIImage?>.value(`image`))) as? (UIImage?) -> Void
		perform?(`image`)
    }

    open func displayLike(isFavorite: Bool) {
        addInvocation(.m_displayLike__isFavorite_isFavorite(Parameter<Bool>.value(`isFavorite`)))
		let perform = methodPerformValue(.m_displayLike__isFavorite_isFavorite(Parameter<Bool>.value(`isFavorite`))) as? (Bool) -> Void
		perform?(`isFavorite`)
    }


    fileprivate enum MethodType {
        case m_setup
        case m_display__title_titledate_datecontent_content(Parameter<String?>, Parameter<String>, Parameter<String?>)
        case m_displayImage__image(Parameter<UIImage?>)
        case m_displayLike__isFavorite_isFavorite(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setup, .m_setup): return .match

            case (.m_display__title_titledate_datecontent_content(let lhsTitle, let lhsDate, let lhsContent), .m_display__title_titledate_datecontent_content(let rhsTitle, let rhsDate, let rhsContent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDate, rhs: rhsDate, with: matcher), lhsDate, rhsDate, "date"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher), lhsContent, rhsContent, "content"))
				return Matcher.ComparisonResult(results)

            case (.m_displayImage__image(let lhsImage), .m_displayImage__image(let rhsImage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsImage, rhs: rhsImage, with: matcher), lhsImage, rhsImage, "_ image"))
				return Matcher.ComparisonResult(results)

            case (.m_displayLike__isFavorite_isFavorite(let lhsIsfavorite), .m_displayLike__isFavorite_isFavorite(let rhsIsfavorite)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsfavorite, rhs: rhsIsfavorite, with: matcher), lhsIsfavorite, rhsIsfavorite, "isFavorite"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_setup: return 0
            case let .m_display__title_titledate_datecontent_content(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_displayImage__image(p0): return p0.intValue
            case let .m_displayLike__isFavorite_isFavorite(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setup: return ".setup()"
            case .m_display__title_titledate_datecontent_content: return ".display(title:date:content:)"
            case .m_displayImage__image: return ".displayImage(_:)"
            case .m_displayLike__isFavorite_isFavorite: return ".displayLike(isFavorite:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setup() -> Verify { return Verify(method: .m_setup)}
        public static func display(title: Parameter<String?>, date: Parameter<String>, content: Parameter<String?>) -> Verify { return Verify(method: .m_display__title_titledate_datecontent_content(`title`, `date`, `content`))}
        public static func displayImage(_ image: Parameter<UIImage?>) -> Verify { return Verify(method: .m_displayImage__image(`image`))}
        public static func displayLike(isFavorite: Parameter<Bool>) -> Verify { return Verify(method: .m_displayLike__isFavorite_isFavorite(`isFavorite`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setup(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_setup, performs: perform)
        }
        public static func display(title: Parameter<String?>, date: Parameter<String>, content: Parameter<String?>, perform: @escaping (String?, String, String?) -> Void) -> Perform {
            return Perform(method: .m_display__title_titledate_datecontent_content(`title`, `date`, `content`), performs: perform)
        }
        public static func displayImage(_ image: Parameter<UIImage?>, perform: @escaping (UIImage?) -> Void) -> Perform {
            return Perform(method: .m_displayImage__image(`image`), performs: perform)
        }
        public static func displayLike(isFavorite: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_displayLike__isFavorite_isFavorite(`isFavorite`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - AuthServiceProtocol

open class AuthServiceProtocolMock: AuthServiceProtocol, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func login(phone: String, completion: @escaping (Result<Void, Error>) -> Void) {
        addInvocation(.m_login__phone_phonecompletion_completion(Parameter<String>.value(`phone`), Parameter<(Result<Void, Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_login__phone_phonecompletion_completion(Parameter<String>.value(`phone`), Parameter<(Result<Void, Error>) -> Void>.value(`completion`))) as? (String, @escaping (Result<Void, Error>) -> Void) -> Void
		perform?(`phone`, `completion`)
    }

    open func signUp(data: SignUpData, completion: @escaping (Result<Void, Error>) -> Void) {
        addInvocation(.m_signUp__data_datacompletion_completion(Parameter<SignUpData>.value(`data`), Parameter<(Result<Void, Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_signUp__data_datacompletion_completion(Parameter<SignUpData>.value(`data`), Parameter<(Result<Void, Error>) -> Void>.value(`completion`))) as? (SignUpData, @escaping (Result<Void, Error>) -> Void) -> Void
		perform?(`data`, `completion`)
    }


    fileprivate enum MethodType {
        case m_login__phone_phonecompletion_completion(Parameter<String>, Parameter<(Result<Void, Error>) -> Void>)
        case m_signUp__data_datacompletion_completion(Parameter<SignUpData>, Parameter<(Result<Void, Error>) -> Void>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_login__phone_phonecompletion_completion(let lhsPhone, let lhsCompletion), .m_login__phone_phonecompletion_completion(let rhsPhone, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPhone, rhs: rhsPhone, with: matcher), lhsPhone, rhsPhone, "phone"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_signUp__data_datacompletion_completion(let lhsData, let lhsCompletion), .m_signUp__data_datacompletion_completion(let rhsData, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsData, rhs: rhsData, with: matcher), lhsData, rhsData, "data"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_login__phone_phonecompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_signUp__data_datacompletion_completion(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_login__phone_phonecompletion_completion: return ".login(phone:completion:)"
            case .m_signUp__data_datacompletion_completion: return ".signUp(data:completion:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func login(phone: Parameter<String>, completion: Parameter<(Result<Void, Error>) -> Void>) -> Verify { return Verify(method: .m_login__phone_phonecompletion_completion(`phone`, `completion`))}
        public static func signUp(data: Parameter<SignUpData>, completion: Parameter<(Result<Void, Error>) -> Void>) -> Verify { return Verify(method: .m_signUp__data_datacompletion_completion(`data`, `completion`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func login(phone: Parameter<String>, completion: Parameter<(Result<Void, Error>) -> Void>, perform: @escaping (String, @escaping (Result<Void, Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_login__phone_phonecompletion_completion(`phone`, `completion`), performs: perform)
        }
        public static func signUp(data: Parameter<SignUpData>, completion: Parameter<(Result<Void, Error>) -> Void>, perform: @escaping (SignUpData, @escaping (Result<Void, Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_signUp__data_datacompletion_completion(`data`, `completion`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - FavoriteRouterInput

open class FavoriteRouterInputMock: FavoriteRouterInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func openArticle(article: ArticleViewModel) {
        addInvocation(.m_openArticle__article_article(Parameter<ArticleViewModel>.value(`article`)))
		let perform = methodPerformValue(.m_openArticle__article_article(Parameter<ArticleViewModel>.value(`article`))) as? (ArticleViewModel) -> Void
		perform?(`article`)
    }


    fileprivate enum MethodType {
        case m_openArticle__article_article(Parameter<ArticleViewModel>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_openArticle__article_article(let lhsArticle), .m_openArticle__article_article(let rhsArticle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsArticle, rhs: rhsArticle, with: matcher), lhsArticle, rhsArticle, "article"))
				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_openArticle__article_article(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_openArticle__article_article: return ".openArticle(article:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func openArticle(article: Parameter<ArticleViewModel>) -> Verify { return Verify(method: .m_openArticle__article_article(`article`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func openArticle(article: Parameter<ArticleViewModel>, perform: @escaping (ArticleViewModel) -> Void) -> Perform {
            return Perform(method: .m_openArticle__article_article(`article`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - FavoriteViewInput

open class FavoriteViewInputMock: FavoriteViewInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func setup() {
        addInvocation(.m_setup)
		let perform = methodPerformValue(.m_setup) as? () -> Void
		perform?()
    }

    open func reloadData() {
        addInvocation(.m_reloadData)
		let perform = methodPerformValue(.m_reloadData) as? () -> Void
		perform?()
    }

    open func updateFavorite(at indexPath: IndexPath) {
        addInvocation(.m_updateFavorite__at_indexPath(Parameter<IndexPath>.value(`indexPath`)))
		let perform = methodPerformValue(.m_updateFavorite__at_indexPath(Parameter<IndexPath>.value(`indexPath`))) as? (IndexPath) -> Void
		perform?(`indexPath`)
    }

    open func updateSelectedCell() {
        addInvocation(.m_updateSelectedCell)
		let perform = methodPerformValue(.m_updateSelectedCell) as? () -> Void
		perform?()
    }

    open func showEmptyState(_ isEmpty: Bool) {
        addInvocation(.m_showEmptyState__isEmpty(Parameter<Bool>.value(`isEmpty`)))
		let perform = methodPerformValue(.m_showEmptyState__isEmpty(Parameter<Bool>.value(`isEmpty`))) as? (Bool) -> Void
		perform?(`isEmpty`)
    }


    fileprivate enum MethodType {
        case m_setup
        case m_reloadData
        case m_updateFavorite__at_indexPath(Parameter<IndexPath>)
        case m_updateSelectedCell
        case m_showEmptyState__isEmpty(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setup, .m_setup): return .match

            case (.m_reloadData, .m_reloadData): return .match

            case (.m_updateFavorite__at_indexPath(let lhsIndexpath), .m_updateFavorite__at_indexPath(let rhsIndexpath)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIndexpath, rhs: rhsIndexpath, with: matcher), lhsIndexpath, rhsIndexpath, "at indexPath"))
				return Matcher.ComparisonResult(results)

            case (.m_updateSelectedCell, .m_updateSelectedCell): return .match

            case (.m_showEmptyState__isEmpty(let lhsIsempty), .m_showEmptyState__isEmpty(let rhsIsempty)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsempty, rhs: rhsIsempty, with: matcher), lhsIsempty, rhsIsempty, "_ isEmpty"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_setup: return 0
            case .m_reloadData: return 0
            case let .m_updateFavorite__at_indexPath(p0): return p0.intValue
            case .m_updateSelectedCell: return 0
            case let .m_showEmptyState__isEmpty(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setup: return ".setup()"
            case .m_reloadData: return ".reloadData()"
            case .m_updateFavorite__at_indexPath: return ".updateFavorite(at:)"
            case .m_updateSelectedCell: return ".updateSelectedCell()"
            case .m_showEmptyState__isEmpty: return ".showEmptyState(_:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setup() -> Verify { return Verify(method: .m_setup)}
        public static func reloadData() -> Verify { return Verify(method: .m_reloadData)}
        public static func updateFavorite(at indexPath: Parameter<IndexPath>) -> Verify { return Verify(method: .m_updateFavorite__at_indexPath(`indexPath`))}
        public static func updateSelectedCell() -> Verify { return Verify(method: .m_updateSelectedCell)}
        public static func showEmptyState(_ isEmpty: Parameter<Bool>) -> Verify { return Verify(method: .m_showEmptyState__isEmpty(`isEmpty`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setup(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_setup, performs: perform)
        }
        public static func reloadData(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_reloadData, performs: perform)
        }
        public static func updateFavorite(at indexPath: Parameter<IndexPath>, perform: @escaping (IndexPath) -> Void) -> Perform {
            return Perform(method: .m_updateFavorite__at_indexPath(`indexPath`), performs: perform)
        }
        public static func updateSelectedCell(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_updateSelectedCell, performs: perform)
        }
        public static func showEmptyState(_ isEmpty: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_showEmptyState__isEmpty(`isEmpty`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - ICacheService

open class ICacheServiceMock: ICacheService, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func getCachedNews() -> NewsSource? {
        addInvocation(.m_getCachedNews)
		let perform = methodPerformValue(.m_getCachedNews) as? () -> Void
		perform?()
		var __value: NewsSource? = nil
		do {
		    __value = try methodReturnValue(.m_getCachedNews).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func cacheNews(_ newsSource: NewsSource) {
        addInvocation(.m_cacheNews__newsSource(Parameter<NewsSource>.value(`newsSource`)))
		let perform = methodPerformValue(.m_cacheNews__newsSource(Parameter<NewsSource>.value(`newsSource`))) as? (NewsSource) -> Void
		perform?(`newsSource`)
    }

    open func clearCache() {
        addInvocation(.m_clearCache)
		let perform = methodPerformValue(.m_clearCache) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_getCachedNews
        case m_cacheNews__newsSource(Parameter<NewsSource>)
        case m_clearCache

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCachedNews, .m_getCachedNews): return .match

            case (.m_cacheNews__newsSource(let lhsNewssource), .m_cacheNews__newsSource(let rhsNewssource)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNewssource, rhs: rhsNewssource, with: matcher), lhsNewssource, rhsNewssource, "_ newsSource"))
				return Matcher.ComparisonResult(results)

            case (.m_clearCache, .m_clearCache): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_getCachedNews: return 0
            case let .m_cacheNews__newsSource(p0): return p0.intValue
            case .m_clearCache: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCachedNews: return ".getCachedNews()"
            case .m_cacheNews__newsSource: return ".cacheNews(_:)"
            case .m_clearCache: return ".clearCache()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCachedNews(willReturn: NewsSource?...) -> MethodStub {
            return Given(method: .m_getCachedNews, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCachedNews(willProduce: (Stubber<NewsSource?>) -> Void) -> MethodStub {
            let willReturn: [NewsSource?] = []
			let given: Given = { return Given(method: .m_getCachedNews, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (NewsSource?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCachedNews() -> Verify { return Verify(method: .m_getCachedNews)}
        public static func cacheNews(_ newsSource: Parameter<NewsSource>) -> Verify { return Verify(method: .m_cacheNews__newsSource(`newsSource`))}
        public static func clearCache() -> Verify { return Verify(method: .m_clearCache)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCachedNews(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getCachedNews, performs: perform)
        }
        public static func cacheNews(_ newsSource: Parameter<NewsSource>, perform: @escaping (NewsSource) -> Void) -> Perform {
            return Perform(method: .m_cacheNews__newsSource(`newsSource`), performs: perform)
        }
        public static func clearCache(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_clearCache, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - IErrorService

open class IErrorServiceMock: IErrorService, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func setDelegate(_ delegate: ErrorServiceDelegate) {
        addInvocation(.m_setDelegate__delegate(Parameter<ErrorServiceDelegate>.value(`delegate`)))
		let perform = methodPerformValue(.m_setDelegate__delegate(Parameter<ErrorServiceDelegate>.value(`delegate`))) as? (ErrorServiceDelegate) -> Void
		perform?(`delegate`)
    }

    open func show(errorText: String) {
        addInvocation(.m_show__errorText_errorText(Parameter<String>.value(`errorText`)))
		let perform = methodPerformValue(.m_show__errorText_errorText(Parameter<String>.value(`errorText`))) as? (String) -> Void
		perform?(`errorText`)
    }

    open func show(with title: String?, errorText: String, completion: @escaping () -> Void) {
        addInvocation(.m_show__with_titleerrorText_errorTextcompletion_completion(Parameter<String?>.value(`title`), Parameter<String>.value(`errorText`), Parameter<() -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_show__with_titleerrorText_errorTextcompletion_completion(Parameter<String?>.value(`title`), Parameter<String>.value(`errorText`), Parameter<() -> Void>.value(`completion`))) as? (String?, String, @escaping () -> Void) -> Void
		perform?(`title`, `errorText`, `completion`)
    }

    open func show(title: String?, message: String, actionTitle: String?, cancelTitle: String?, actionType: UIAlertAction.Style, completion: @escaping () -> Void) {
        addInvocation(.m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(Parameter<String?>.value(`title`), Parameter<String>.value(`message`), Parameter<String?>.value(`actionTitle`), Parameter<String?>.value(`cancelTitle`), Parameter<UIAlertAction.Style>.value(`actionType`), Parameter<() -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(Parameter<String?>.value(`title`), Parameter<String>.value(`message`), Parameter<String?>.value(`actionTitle`), Parameter<String?>.value(`cancelTitle`), Parameter<UIAlertAction.Style>.value(`actionType`), Parameter<() -> Void>.value(`completion`))) as? (String?, String, String?, String?, UIAlertAction.Style, @escaping () -> Void) -> Void
		perform?(`title`, `message`, `actionTitle`, `cancelTitle`, `actionType`, `completion`)
    }

    open func show(title: String?, message: String, actionTitle: String?, cancelTitle: String?, actionType: UIAlertAction.Style, actionHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        addInvocation(.m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(Parameter<String?>.value(`title`), Parameter<String>.value(`message`), Parameter<String?>.value(`actionTitle`), Parameter<String?>.value(`cancelTitle`), Parameter<UIAlertAction.Style>.value(`actionType`), Parameter<() -> Void>.value(`actionHandler`), Parameter<() -> Void>.value(`cancelHandler`)))
		let perform = methodPerformValue(.m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(Parameter<String?>.value(`title`), Parameter<String>.value(`message`), Parameter<String?>.value(`actionTitle`), Parameter<String?>.value(`cancelTitle`), Parameter<UIAlertAction.Style>.value(`actionType`), Parameter<() -> Void>.value(`actionHandler`), Parameter<() -> Void>.value(`cancelHandler`))) as? (String?, String, String?, String?, UIAlertAction.Style, @escaping () -> Void, @escaping () -> Void) -> Void
		perform?(`title`, `message`, `actionTitle`, `cancelTitle`, `actionType`, `actionHandler`, `cancelHandler`)
    }

    open func show(title: String?, attributedMessage: NSAttributedString, actionTitle: String?, cancelTitle: String?, actionType: UIAlertAction.Style, actionHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        addInvocation(.m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(Parameter<String?>.value(`title`), Parameter<NSAttributedString>.value(`attributedMessage`), Parameter<String?>.value(`actionTitle`), Parameter<String?>.value(`cancelTitle`), Parameter<UIAlertAction.Style>.value(`actionType`), Parameter<(() -> Void)?>.value(`actionHandler`), Parameter<(() -> Void)?>.value(`cancelHandler`)))
		let perform = methodPerformValue(.m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(Parameter<String?>.value(`title`), Parameter<NSAttributedString>.value(`attributedMessage`), Parameter<String?>.value(`actionTitle`), Parameter<String?>.value(`cancelTitle`), Parameter<UIAlertAction.Style>.value(`actionType`), Parameter<(() -> Void)?>.value(`actionHandler`), Parameter<(() -> Void)?>.value(`cancelHandler`))) as? (String?, NSAttributedString, String?, String?, UIAlertAction.Style, (() -> Void)?, (() -> Void)?) -> Void
		perform?(`title`, `attributedMessage`, `actionTitle`, `cancelTitle`, `actionType`, `actionHandler`, `cancelHandler`)
    }


    fileprivate enum MethodType {
        case m_setDelegate__delegate(Parameter<ErrorServiceDelegate>)
        case m_show__errorText_errorText(Parameter<String>)
        case m_show__with_titleerrorText_errorTextcompletion_completion(Parameter<String?>, Parameter<String>, Parameter<() -> Void>)
        case m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(Parameter<String?>, Parameter<String>, Parameter<String?>, Parameter<String?>, Parameter<UIAlertAction.Style>, Parameter<() -> Void>)
        case m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(Parameter<String?>, Parameter<String>, Parameter<String?>, Parameter<String?>, Parameter<UIAlertAction.Style>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(Parameter<String?>, Parameter<NSAttributedString>, Parameter<String?>, Parameter<String?>, Parameter<UIAlertAction.Style>, Parameter<(() -> Void)?>, Parameter<(() -> Void)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setDelegate__delegate(let lhsDelegate), .m_setDelegate__delegate(let rhsDelegate)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDelegate, rhs: rhsDelegate, with: matcher), lhsDelegate, rhsDelegate, "_ delegate"))
				return Matcher.ComparisonResult(results)

            case (.m_show__errorText_errorText(let lhsErrortext), .m_show__errorText_errorText(let rhsErrortext)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsErrortext, rhs: rhsErrortext, with: matcher), lhsErrortext, rhsErrortext, "errorText"))
				return Matcher.ComparisonResult(results)

            case (.m_show__with_titleerrorText_errorTextcompletion_completion(let lhsTitle, let lhsErrortext, let lhsCompletion), .m_show__with_titleerrorText_errorTextcompletion_completion(let rhsTitle, let rhsErrortext, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "with title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsErrortext, rhs: rhsErrortext, with: matcher), lhsErrortext, rhsErrortext, "errorText"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(let lhsTitle, let lhsMessage, let lhsActiontitle, let lhsCanceltitle, let lhsActiontype, let lhsCompletion), .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(let rhsTitle, let rhsMessage, let rhsActiontitle, let rhsCanceltitle, let rhsActiontype, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsMessage, rhs: rhsMessage, with: matcher), lhsMessage, rhsMessage, "message"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActiontitle, rhs: rhsActiontitle, with: matcher), lhsActiontitle, rhsActiontitle, "actionTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCanceltitle, rhs: rhsCanceltitle, with: matcher), lhsCanceltitle, rhsCanceltitle, "cancelTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActiontype, rhs: rhsActiontype, with: matcher), lhsActiontype, rhsActiontype, "actionType"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(let lhsTitle, let lhsMessage, let lhsActiontitle, let lhsCanceltitle, let lhsActiontype, let lhsActionhandler, let lhsCancelhandler), .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(let rhsTitle, let rhsMessage, let rhsActiontitle, let rhsCanceltitle, let rhsActiontype, let rhsActionhandler, let rhsCancelhandler)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsMessage, rhs: rhsMessage, with: matcher), lhsMessage, rhsMessage, "message"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActiontitle, rhs: rhsActiontitle, with: matcher), lhsActiontitle, rhsActiontitle, "actionTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCanceltitle, rhs: rhsCanceltitle, with: matcher), lhsCanceltitle, rhsCanceltitle, "cancelTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActiontype, rhs: rhsActiontype, with: matcher), lhsActiontype, rhsActiontype, "actionType"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActionhandler, rhs: rhsActionhandler, with: matcher), lhsActionhandler, rhsActionhandler, "actionHandler"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCancelhandler, rhs: rhsCancelhandler, with: matcher), lhsCancelhandler, rhsCancelhandler, "cancelHandler"))
				return Matcher.ComparisonResult(results)

            case (.m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(let lhsTitle, let lhsAttributedmessage, let lhsActiontitle, let lhsCanceltitle, let lhsActiontype, let lhsActionhandler, let lhsCancelhandler), .m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(let rhsTitle, let rhsAttributedmessage, let rhsActiontitle, let rhsCanceltitle, let rhsActiontype, let rhsActionhandler, let rhsCancelhandler)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAttributedmessage, rhs: rhsAttributedmessage, with: matcher), lhsAttributedmessage, rhsAttributedmessage, "attributedMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActiontitle, rhs: rhsActiontitle, with: matcher), lhsActiontitle, rhsActiontitle, "actionTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCanceltitle, rhs: rhsCanceltitle, with: matcher), lhsCanceltitle, rhsCanceltitle, "cancelTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActiontype, rhs: rhsActiontype, with: matcher), lhsActiontype, rhsActiontype, "actionType"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsActionhandler, rhs: rhsActionhandler, with: matcher), lhsActionhandler, rhsActionhandler, "actionHandler"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCancelhandler, rhs: rhsCancelhandler, with: matcher), lhsCancelhandler, rhsCancelhandler, "cancelHandler"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setDelegate__delegate(p0): return p0.intValue
            case let .m_show__errorText_errorText(p0): return p0.intValue
            case let .m_show__with_titleerrorText_errorTextcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            case let .m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setDelegate__delegate: return ".setDelegate(_:)"
            case .m_show__errorText_errorText: return ".show(errorText:)"
            case .m_show__with_titleerrorText_errorTextcompletion_completion: return ".show(with:errorText:completion:)"
            case .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion: return ".show(title:message:actionTitle:cancelTitle:actionType:completion:)"
            case .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler: return ".show(title:message:actionTitle:cancelTitle:actionType:actionHandler:cancelHandler:)"
            case .m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler: return ".show(title:attributedMessage:actionTitle:cancelTitle:actionType:actionHandler:cancelHandler:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setDelegate(_ delegate: Parameter<ErrorServiceDelegate>) -> Verify { return Verify(method: .m_setDelegate__delegate(`delegate`))}
        public static func show(errorText: Parameter<String>) -> Verify { return Verify(method: .m_show__errorText_errorText(`errorText`))}
        public static func show(with title: Parameter<String?>, errorText: Parameter<String>, completion: Parameter<() -> Void>) -> Verify { return Verify(method: .m_show__with_titleerrorText_errorTextcompletion_completion(`title`, `errorText`, `completion`))}
        public static func show(title: Parameter<String?>, message: Parameter<String>, actionTitle: Parameter<String?>, cancelTitle: Parameter<String?>, actionType: Parameter<UIAlertAction.Style>, completion: Parameter<() -> Void>) -> Verify { return Verify(method: .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(`title`, `message`, `actionTitle`, `cancelTitle`, `actionType`, `completion`))}
        public static func show(title: Parameter<String?>, message: Parameter<String>, actionTitle: Parameter<String?>, cancelTitle: Parameter<String?>, actionType: Parameter<UIAlertAction.Style>, actionHandler: Parameter<() -> Void>, cancelHandler: Parameter<() -> Void>) -> Verify { return Verify(method: .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(`title`, `message`, `actionTitle`, `cancelTitle`, `actionType`, `actionHandler`, `cancelHandler`))}
        public static func show(title: Parameter<String?>, attributedMessage: Parameter<NSAttributedString>, actionTitle: Parameter<String?>, cancelTitle: Parameter<String?>, actionType: Parameter<UIAlertAction.Style>, actionHandler: Parameter<(() -> Void)?>, cancelHandler: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(`title`, `attributedMessage`, `actionTitle`, `cancelTitle`, `actionType`, `actionHandler`, `cancelHandler`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setDelegate(_ delegate: Parameter<ErrorServiceDelegate>, perform: @escaping (ErrorServiceDelegate) -> Void) -> Perform {
            return Perform(method: .m_setDelegate__delegate(`delegate`), performs: perform)
        }
        public static func show(errorText: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_show__errorText_errorText(`errorText`), performs: perform)
        }
        public static func show(with title: Parameter<String?>, errorText: Parameter<String>, completion: Parameter<() -> Void>, perform: @escaping (String?, String, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_show__with_titleerrorText_errorTextcompletion_completion(`title`, `errorText`, `completion`), performs: perform)
        }
        public static func show(title: Parameter<String?>, message: Parameter<String>, actionTitle: Parameter<String?>, cancelTitle: Parameter<String?>, actionType: Parameter<UIAlertAction.Style>, completion: Parameter<() -> Void>, perform: @escaping (String?, String, String?, String?, UIAlertAction.Style, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypecompletion_completion(`title`, `message`, `actionTitle`, `cancelTitle`, `actionType`, `completion`), performs: perform)
        }
        public static func show(title: Parameter<String?>, message: Parameter<String>, actionTitle: Parameter<String?>, cancelTitle: Parameter<String?>, actionType: Parameter<UIAlertAction.Style>, actionHandler: Parameter<() -> Void>, cancelHandler: Parameter<() -> Void>, perform: @escaping (String?, String, String?, String?, UIAlertAction.Style, @escaping () -> Void, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_show__title_titlemessage_messageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(`title`, `message`, `actionTitle`, `cancelTitle`, `actionType`, `actionHandler`, `cancelHandler`), performs: perform)
        }
        public static func show(title: Parameter<String?>, attributedMessage: Parameter<NSAttributedString>, actionTitle: Parameter<String?>, cancelTitle: Parameter<String?>, actionType: Parameter<UIAlertAction.Style>, actionHandler: Parameter<(() -> Void)?>, cancelHandler: Parameter<(() -> Void)?>, perform: @escaping (String?, NSAttributedString, String?, String?, UIAlertAction.Style, (() -> Void)?, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_show__title_titleattributedMessage_attributedMessageactionTitle_actionTitlecancelTitle_cancelTitleactionType_actionTypeactionHandler_actionHandlercancelHandler_cancelHandler(`title`, `attributedMessage`, `actionTitle`, `cancelTitle`, `actionType`, `actionHandler`, `cancelHandler`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - INewsService

open class INewsServiceMock: INewsService, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func performNewsRequest(completion: @escaping (Result<NewsSource, Error>) -> Void) {
        addInvocation(.m_performNewsRequest__completion_completion(Parameter<(Result<NewsSource, Error>) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_performNewsRequest__completion_completion(Parameter<(Result<NewsSource, Error>) -> Void>.value(`completion`))) as? (@escaping (Result<NewsSource, Error>) -> Void) -> Void
		perform?(`completion`)
    }


    fileprivate enum MethodType {
        case m_performNewsRequest__completion_completion(Parameter<(Result<NewsSource, Error>) -> Void>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_performNewsRequest__completion_completion(let lhsCompletion), .m_performNewsRequest__completion_completion(let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_performNewsRequest__completion_completion(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_performNewsRequest__completion_completion: return ".performNewsRequest(completion:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func performNewsRequest(completion: Parameter<(Result<NewsSource, Error>) -> Void>) -> Verify { return Verify(method: .m_performNewsRequest__completion_completion(`completion`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func performNewsRequest(completion: Parameter<(Result<NewsSource, Error>) -> Void>, perform: @escaping (@escaping (Result<NewsSource, Error>) -> Void) -> Void) -> Perform {
            return Perform(method: .m_performNewsRequest__completion_completion(`completion`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - IStorageService

open class IStorageServiceMock: IStorageService, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }

    public var articles: [ArticleEntity] {
		get {	invocations.append(.p_articles_get); return __p_articles ?? givenGetterValue(.p_articles_get, "IStorageServiceMock - stub value for articles was not defined") }
	}
	private var __p_articles: ([ArticleEntity])?





    open func isArticleInFavorites(title: String) -> Bool {
        addInvocation(.m_isArticleInFavorites__title_title(Parameter<String>.value(`title`)))
		let perform = methodPerformValue(.m_isArticleInFavorites__title_title(Parameter<String>.value(`title`))) as? (String) -> Void
		perform?(`title`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isArticleInFavorites__title_title(Parameter<String>.value(`title`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isArticleInFavorites(title: String). Use given")
			Failure("Stub return value not specified for isArticleInFavorites(title: String). Use given")
		}
		return __value
    }

    open func isEmailRegistered(_ email: String) -> Bool {
        addInvocation(.m_isEmailRegistered__email(Parameter<String>.value(`email`)))
		let perform = methodPerformValue(.m_isEmailRegistered__email(Parameter<String>.value(`email`))) as? (String) -> Void
		perform?(`email`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isEmailRegistered__email(Parameter<String>.value(`email`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isEmailRegistered(_ email: String). Use given")
			Failure("Stub return value not specified for isEmailRegistered(_ email: String). Use given")
		}
		return __value
    }

    open func addToFavorites(title: String, contents: String, publishedAt: Date, urlToImage: String?) {
        addInvocation(.m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(Parameter<String>.value(`title`), Parameter<String>.value(`contents`), Parameter<Date>.value(`publishedAt`), Parameter<String?>.value(`urlToImage`)))
		let perform = methodPerformValue(.m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(Parameter<String>.value(`title`), Parameter<String>.value(`contents`), Parameter<Date>.value(`publishedAt`), Parameter<String?>.value(`urlToImage`))) as? (String, String, Date, String?) -> Void
		perform?(`title`, `contents`, `publishedAt`, `urlToImage`)
    }

    open func removeFromFavorites(title: String) {
        addInvocation(.m_removeFromFavorites__title_title(Parameter<String>.value(`title`)))
		let perform = methodPerformValue(.m_removeFromFavorites__title_title(Parameter<String>.value(`title`))) as? (String) -> Void
		perform?(`title`)
    }

    open func addObserver(_ observer: any NewsAppStorageObserver) {
        addInvocation(.m_addObserver__observer(Parameter<any NewsAppStorageObserver>.value(`observer`)))
		let perform = methodPerformValue(.m_addObserver__observer(Parameter<any NewsAppStorageObserver>.value(`observer`))) as? (any NewsAppStorageObserver) -> Void
		perform?(`observer`)
    }

    open func removeObserver(_ observer: any NewsAppStorageObserver) {
        addInvocation(.m_removeObserver__observer(Parameter<any NewsAppStorageObserver>.value(`observer`)))
		let perform = methodPerformValue(.m_removeObserver__observer(Parameter<any NewsAppStorageObserver>.value(`observer`))) as? (any NewsAppStorageObserver) -> Void
		perform?(`observer`)
    }

    open func addUser(userName: String, email: String, password: String) -> UserEntity {
        addInvocation(.m_addUser__userName_userNameemail_emailpassword_password(Parameter<String>.value(`userName`), Parameter<String>.value(`email`), Parameter<String>.value(`password`)))
		let perform = methodPerformValue(.m_addUser__userName_userNameemail_emailpassword_password(Parameter<String>.value(`userName`), Parameter<String>.value(`email`), Parameter<String>.value(`password`))) as? (String, String, String) -> Void
		perform?(`userName`, `email`, `password`)
		var __value: UserEntity
		do {
		    __value = try methodReturnValue(.m_addUser__userName_userNameemail_emailpassword_password(Parameter<String>.value(`userName`), Parameter<String>.value(`email`), Parameter<String>.value(`password`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for addUser(userName: String, email: String, password: String). Use given")
			Failure("Stub return value not specified for addUser(userName: String, email: String, password: String). Use given")
		}
		return __value
    }

    open func getUserByEmailAndPassword(email: String, password: String) -> UserEntity? {
        addInvocation(.m_getUserByEmailAndPassword__email_emailpassword_password(Parameter<String>.value(`email`), Parameter<String>.value(`password`)))
		let perform = methodPerformValue(.m_getUserByEmailAndPassword__email_emailpassword_password(Parameter<String>.value(`email`), Parameter<String>.value(`password`))) as? (String, String) -> Void
		perform?(`email`, `password`)
		var __value: UserEntity? = nil
		do {
		    __value = try methodReturnValue(.m_getUserByEmailAndPassword__email_emailpassword_password(Parameter<String>.value(`email`), Parameter<String>.value(`password`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_isArticleInFavorites__title_title(Parameter<String>)
        case m_isEmailRegistered__email(Parameter<String>)
        case m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(Parameter<String>, Parameter<String>, Parameter<Date>, Parameter<String?>)
        case m_removeFromFavorites__title_title(Parameter<String>)
        case m_addObserver__observer(Parameter<any NewsAppStorageObserver>)
        case m_removeObserver__observer(Parameter<any NewsAppStorageObserver>)
        case m_addUser__userName_userNameemail_emailpassword_password(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_getUserByEmailAndPassword__email_emailpassword_password(Parameter<String>, Parameter<String>)
        case p_articles_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_isArticleInFavorites__title_title(let lhsTitle), .m_isArticleInFavorites__title_title(let rhsTitle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				return Matcher.ComparisonResult(results)

            case (.m_isEmailRegistered__email(let lhsEmail), .m_isEmailRegistered__email(let rhsEmail)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEmail, rhs: rhsEmail, with: matcher), lhsEmail, rhsEmail, "_ email"))
				return Matcher.ComparisonResult(results)

            case (.m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(let lhsTitle, let lhsContents, let lhsPublishedat, let lhsUrltoimage), .m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(let rhsTitle, let rhsContents, let rhsPublishedat, let rhsUrltoimage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsContents, rhs: rhsContents, with: matcher), lhsContents, rhsContents, "contents"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPublishedat, rhs: rhsPublishedat, with: matcher), lhsPublishedat, rhsPublishedat, "publishedAt"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrltoimage, rhs: rhsUrltoimage, with: matcher), lhsUrltoimage, rhsUrltoimage, "urlToImage"))
				return Matcher.ComparisonResult(results)

            case (.m_removeFromFavorites__title_title(let lhsTitle), .m_removeFromFavorites__title_title(let rhsTitle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				return Matcher.ComparisonResult(results)

            case (.m_addObserver__observer(let lhsObserver), .m_addObserver__observer(let rhsObserver)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsObserver, rhs: rhsObserver, with: matcher), lhsObserver, rhsObserver, "_ observer"))
				return Matcher.ComparisonResult(results)

            case (.m_removeObserver__observer(let lhsObserver), .m_removeObserver__observer(let rhsObserver)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsObserver, rhs: rhsObserver, with: matcher), lhsObserver, rhsObserver, "_ observer"))
				return Matcher.ComparisonResult(results)

            case (.m_addUser__userName_userNameemail_emailpassword_password(let lhsUsername, let lhsEmail, let lhsPassword), .m_addUser__userName_userNameemail_emailpassword_password(let rhsUsername, let rhsEmail, let rhsPassword)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "userName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEmail, rhs: rhsEmail, with: matcher), lhsEmail, rhsEmail, "email"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPassword, rhs: rhsPassword, with: matcher), lhsPassword, rhsPassword, "password"))
				return Matcher.ComparisonResult(results)

            case (.m_getUserByEmailAndPassword__email_emailpassword_password(let lhsEmail, let lhsPassword), .m_getUserByEmailAndPassword__email_emailpassword_password(let rhsEmail, let rhsPassword)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEmail, rhs: rhsEmail, with: matcher), lhsEmail, rhsEmail, "email"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPassword, rhs: rhsPassword, with: matcher), lhsPassword, rhsPassword, "password"))
				return Matcher.ComparisonResult(results)
            case (.p_articles_get,.p_articles_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_isArticleInFavorites__title_title(p0): return p0.intValue
            case let .m_isEmailRegistered__email(p0): return p0.intValue
            case let .m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_removeFromFavorites__title_title(p0): return p0.intValue
            case let .m_addObserver__observer(p0): return p0.intValue
            case let .m_removeObserver__observer(p0): return p0.intValue
            case let .m_addUser__userName_userNameemail_emailpassword_password(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_getUserByEmailAndPassword__email_emailpassword_password(p0, p1): return p0.intValue + p1.intValue
            case .p_articles_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_isArticleInFavorites__title_title: return ".isArticleInFavorites(title:)"
            case .m_isEmailRegistered__email: return ".isEmailRegistered(_:)"
            case .m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage: return ".addToFavorites(title:contents:publishedAt:urlToImage:)"
            case .m_removeFromFavorites__title_title: return ".removeFromFavorites(title:)"
            case .m_addObserver__observer: return ".addObserver(_:)"
            case .m_removeObserver__observer: return ".removeObserver(_:)"
            case .m_addUser__userName_userNameemail_emailpassword_password: return ".addUser(userName:email:password:)"
            case .m_getUserByEmailAndPassword__email_emailpassword_password: return ".getUserByEmailAndPassword(email:password:)"
            case .p_articles_get: return "[get] .articles"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func articles(getter defaultValue: [ArticleEntity]...) -> PropertyStub {
            return Given(method: .p_articles_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func isArticleInFavorites(title: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isArticleInFavorites__title_title(`title`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isEmailRegistered(_ email: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isEmailRegistered__email(`email`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func addUser(userName: Parameter<String>, email: Parameter<String>, password: Parameter<String>, willReturn: UserEntity...) -> MethodStub {
            return Given(method: .m_addUser__userName_userNameemail_emailpassword_password(`userName`, `email`, `password`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getUserByEmailAndPassword(email: Parameter<String>, password: Parameter<String>, willReturn: UserEntity?...) -> MethodStub {
            return Given(method: .m_getUserByEmailAndPassword__email_emailpassword_password(`email`, `password`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isArticleInFavorites(title: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isArticleInFavorites__title_title(`title`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func isEmailRegistered(_ email: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isEmailRegistered__email(`email`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func addUser(userName: Parameter<String>, email: Parameter<String>, password: Parameter<String>, willProduce: (Stubber<UserEntity>) -> Void) -> MethodStub {
            let willReturn: [UserEntity] = []
			let given: Given = { return Given(method: .m_addUser__userName_userNameemail_emailpassword_password(`userName`, `email`, `password`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UserEntity).self)
			willProduce(stubber)
			return given
        }
        public static func getUserByEmailAndPassword(email: Parameter<String>, password: Parameter<String>, willProduce: (Stubber<UserEntity?>) -> Void) -> MethodStub {
            let willReturn: [UserEntity?] = []
			let given: Given = { return Given(method: .m_getUserByEmailAndPassword__email_emailpassword_password(`email`, `password`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UserEntity?).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func isArticleInFavorites(title: Parameter<String>) -> Verify { return Verify(method: .m_isArticleInFavorites__title_title(`title`))}
        public static func isEmailRegistered(_ email: Parameter<String>) -> Verify { return Verify(method: .m_isEmailRegistered__email(`email`))}
        public static func addToFavorites(title: Parameter<String>, contents: Parameter<String>, publishedAt: Parameter<Date>, urlToImage: Parameter<String?>) -> Verify { return Verify(method: .m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(`title`, `contents`, `publishedAt`, `urlToImage`))}
        public static func removeFromFavorites(title: Parameter<String>) -> Verify { return Verify(method: .m_removeFromFavorites__title_title(`title`))}
        public static func addObserver(_ observer: Parameter<any NewsAppStorageObserver>) -> Verify { return Verify(method: .m_addObserver__observer(`observer`))}
        public static func removeObserver(_ observer: Parameter<any NewsAppStorageObserver>) -> Verify { return Verify(method: .m_removeObserver__observer(`observer`))}
        public static func addUser(userName: Parameter<String>, email: Parameter<String>, password: Parameter<String>) -> Verify { return Verify(method: .m_addUser__userName_userNameemail_emailpassword_password(`userName`, `email`, `password`))}
        public static func getUserByEmailAndPassword(email: Parameter<String>, password: Parameter<String>) -> Verify { return Verify(method: .m_getUserByEmailAndPassword__email_emailpassword_password(`email`, `password`))}
        public static var articles: Verify { return Verify(method: .p_articles_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func isArticleInFavorites(title: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isArticleInFavorites__title_title(`title`), performs: perform)
        }
        public static func isEmailRegistered(_ email: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isEmailRegistered__email(`email`), performs: perform)
        }
        public static func addToFavorites(title: Parameter<String>, contents: Parameter<String>, publishedAt: Parameter<Date>, urlToImage: Parameter<String?>, perform: @escaping (String, String, Date, String?) -> Void) -> Perform {
            return Perform(method: .m_addToFavorites__title_titlecontents_contentspublishedAt_publishedAturlToImage_urlToImage(`title`, `contents`, `publishedAt`, `urlToImage`), performs: perform)
        }
        public static func removeFromFavorites(title: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_removeFromFavorites__title_title(`title`), performs: perform)
        }
        public static func addObserver(_ observer: Parameter<any NewsAppStorageObserver>, perform: @escaping (any NewsAppStorageObserver) -> Void) -> Perform {
            return Perform(method: .m_addObserver__observer(`observer`), performs: perform)
        }
        public static func removeObserver(_ observer: Parameter<any NewsAppStorageObserver>, perform: @escaping (any NewsAppStorageObserver) -> Void) -> Perform {
            return Perform(method: .m_removeObserver__observer(`observer`), performs: perform)
        }
        public static func addUser(userName: Parameter<String>, email: Parameter<String>, password: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_addUser__userName_userNameemail_emailpassword_password(`userName`, `email`, `password`), performs: perform)
        }
        public static func getUserByEmailAndPassword(email: Parameter<String>, password: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_getUserByEmailAndPassword__email_emailpassword_password(`email`, `password`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - LoginScreenRouterInput

open class LoginScreenRouterInputMock: LoginScreenRouterInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func openMainScreen() {
        addInvocation(.m_openMainScreen)
		let perform = methodPerformValue(.m_openMainScreen) as? () -> Void
		perform?()
    }

    open func openSignUpScreen() {
        addInvocation(.m_openSignUpScreen)
		let perform = methodPerformValue(.m_openSignUpScreen) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_openMainScreen
        case m_openSignUpScreen

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_openMainScreen, .m_openMainScreen): return .match

            case (.m_openSignUpScreen, .m_openSignUpScreen): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_openMainScreen: return 0
            case .m_openSignUpScreen: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_openMainScreen: return ".openMainScreen()"
            case .m_openSignUpScreen: return ".openSignUpScreen()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func openMainScreen() -> Verify { return Verify(method: .m_openMainScreen)}
        public static func openSignUpScreen() -> Verify { return Verify(method: .m_openSignUpScreen)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func openMainScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_openMainScreen, performs: perform)
        }
        public static func openSignUpScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_openSignUpScreen, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - LoginScreenViewInput

open class LoginScreenViewInputMock: LoginScreenViewInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func setup() {
        addInvocation(.m_setup)
		let perform = methodPerformValue(.m_setup) as? () -> Void
		perform?()
    }

    open func updateConfirmButton(enabled: Bool) {
        addInvocation(.m_updateConfirmButton__enabled_enabled(Parameter<Bool>.value(`enabled`)))
		let perform = methodPerformValue(.m_updateConfirmButton__enabled_enabled(Parameter<Bool>.value(`enabled`))) as? (Bool) -> Void
		perform?(`enabled`)
    }


    fileprivate enum MethodType {
        case m_setup
        case m_updateConfirmButton__enabled_enabled(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setup, .m_setup): return .match

            case (.m_updateConfirmButton__enabled_enabled(let lhsEnabled), .m_updateConfirmButton__enabled_enabled(let rhsEnabled)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher), lhsEnabled, rhsEnabled, "enabled"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_setup: return 0
            case let .m_updateConfirmButton__enabled_enabled(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setup: return ".setup()"
            case .m_updateConfirmButton__enabled_enabled: return ".updateConfirmButton(enabled:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setup() -> Verify { return Verify(method: .m_setup)}
        public static func updateConfirmButton(enabled: Parameter<Bool>) -> Verify { return Verify(method: .m_updateConfirmButton__enabled_enabled(`enabled`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setup(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_setup, performs: perform)
        }
        public static func updateConfirmButton(enabled: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_updateConfirmButton__enabled_enabled(`enabled`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - NewsRouterInput

open class NewsRouterInputMock: NewsRouterInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func openArticle(article: ArticleViewModel) {
        addInvocation(.m_openArticle__article_article(Parameter<ArticleViewModel>.value(`article`)))
		let perform = methodPerformValue(.m_openArticle__article_article(Parameter<ArticleViewModel>.value(`article`))) as? (ArticleViewModel) -> Void
		perform?(`article`)
    }


    fileprivate enum MethodType {
        case m_openArticle__article_article(Parameter<ArticleViewModel>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_openArticle__article_article(let lhsArticle), .m_openArticle__article_article(let rhsArticle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsArticle, rhs: rhsArticle, with: matcher), lhsArticle, rhsArticle, "article"))
				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_openArticle__article_article(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_openArticle__article_article: return ".openArticle(article:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func openArticle(article: Parameter<ArticleViewModel>) -> Verify { return Verify(method: .m_openArticle__article_article(`article`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func openArticle(article: Parameter<ArticleViewModel>, perform: @escaping (ArticleViewModel) -> Void) -> Perform {
            return Perform(method: .m_openArticle__article_article(`article`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - NewsViewInput

open class NewsViewInputMock: NewsViewInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func setup() {
        addInvocation(.m_setup)
		let perform = methodPerformValue(.m_setup) as? () -> Void
		perform?()
    }

    open func showLoading(_ isLoading: Bool) {
        addInvocation(.m_showLoading__isLoading(Parameter<Bool>.value(`isLoading`)))
		let perform = methodPerformValue(.m_showLoading__isLoading(Parameter<Bool>.value(`isLoading`))) as? (Bool) -> Void
		perform?(`isLoading`)
    }

    open func reloadData() {
        addInvocation(.m_reloadData)
		let perform = methodPerformValue(.m_reloadData) as? () -> Void
		perform?()
    }

    open func updateFavorite(at indexPath: IndexPath) {
        addInvocation(.m_updateFavorite__at_indexPath(Parameter<IndexPath>.value(`indexPath`)))
		let perform = methodPerformValue(.m_updateFavorite__at_indexPath(Parameter<IndexPath>.value(`indexPath`))) as? (IndexPath) -> Void
		perform?(`indexPath`)
    }

    open func updateSelectedCell() {
        addInvocation(.m_updateSelectedCell)
		let perform = methodPerformValue(.m_updateSelectedCell) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_setup
        case m_showLoading__isLoading(Parameter<Bool>)
        case m_reloadData
        case m_updateFavorite__at_indexPath(Parameter<IndexPath>)
        case m_updateSelectedCell

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setup, .m_setup): return .match

            case (.m_showLoading__isLoading(let lhsIsloading), .m_showLoading__isLoading(let rhsIsloading)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsloading, rhs: rhsIsloading, with: matcher), lhsIsloading, rhsIsloading, "_ isLoading"))
				return Matcher.ComparisonResult(results)

            case (.m_reloadData, .m_reloadData): return .match

            case (.m_updateFavorite__at_indexPath(let lhsIndexpath), .m_updateFavorite__at_indexPath(let rhsIndexpath)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIndexpath, rhs: rhsIndexpath, with: matcher), lhsIndexpath, rhsIndexpath, "at indexPath"))
				return Matcher.ComparisonResult(results)

            case (.m_updateSelectedCell, .m_updateSelectedCell): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_setup: return 0
            case let .m_showLoading__isLoading(p0): return p0.intValue
            case .m_reloadData: return 0
            case let .m_updateFavorite__at_indexPath(p0): return p0.intValue
            case .m_updateSelectedCell: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setup: return ".setup()"
            case .m_showLoading__isLoading: return ".showLoading(_:)"
            case .m_reloadData: return ".reloadData()"
            case .m_updateFavorite__at_indexPath: return ".updateFavorite(at:)"
            case .m_updateSelectedCell: return ".updateSelectedCell()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setup() -> Verify { return Verify(method: .m_setup)}
        public static func showLoading(_ isLoading: Parameter<Bool>) -> Verify { return Verify(method: .m_showLoading__isLoading(`isLoading`))}
        public static func reloadData() -> Verify { return Verify(method: .m_reloadData)}
        public static func updateFavorite(at indexPath: Parameter<IndexPath>) -> Verify { return Verify(method: .m_updateFavorite__at_indexPath(`indexPath`))}
        public static func updateSelectedCell() -> Verify { return Verify(method: .m_updateSelectedCell)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setup(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_setup, performs: perform)
        }
        public static func showLoading(_ isLoading: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_showLoading__isLoading(`isLoading`), performs: perform)
        }
        public static func reloadData(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_reloadData, performs: perform)
        }
        public static func updateFavorite(at indexPath: Parameter<IndexPath>, perform: @escaping (IndexPath) -> Void) -> Perform {
            return Perform(method: .m_updateFavorite__at_indexPath(`indexPath`), performs: perform)
        }
        public static func updateSelectedCell(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_updateSelectedCell, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - SignUpScreenRouterInput

open class SignUpScreenRouterInputMock: SignUpScreenRouterInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func close() {
        addInvocation(.m_close)
		let perform = methodPerformValue(.m_close) as? () -> Void
		perform?()
    }

    open func openMainScreen() {
        addInvocation(.m_openMainScreen)
		let perform = methodPerformValue(.m_openMainScreen) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_close
        case m_openMainScreen

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_close, .m_close): return .match

            case (.m_openMainScreen, .m_openMainScreen): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_close: return 0
            case .m_openMainScreen: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_close: return ".close()"
            case .m_openMainScreen: return ".openMainScreen()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func close() -> Verify { return Verify(method: .m_close)}
        public static func openMainScreen() -> Verify { return Verify(method: .m_openMainScreen)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func close(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_close, performs: perform)
        }
        public static func openMainScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_openMainScreen, performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

// MARK: - SignUpScreenViewInput

open class SignUpScreenViewInputMock: SignUpScreenViewInput, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func setup() {
        addInvocation(.m_setup)
		let perform = methodPerformValue(.m_setup) as? () -> Void
		perform?()
    }

    open func updateCreateButton(enabled: Bool) {
        addInvocation(.m_updateCreateButton__enabled_enabled(Parameter<Bool>.value(`enabled`)))
		let perform = methodPerformValue(.m_updateCreateButton__enabled_enabled(Parameter<Bool>.value(`enabled`))) as? (Bool) -> Void
		perform?(`enabled`)
    }


    fileprivate enum MethodType {
        case m_setup
        case m_updateCreateButton__enabled_enabled(Parameter<Bool>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setup, .m_setup): return .match

            case (.m_updateCreateButton__enabled_enabled(let lhsEnabled), .m_updateCreateButton__enabled_enabled(let rhsEnabled)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnabled, rhs: rhsEnabled, with: matcher), lhsEnabled, rhsEnabled, "enabled"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_setup: return 0
            case let .m_updateCreateButton__enabled_enabled(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setup: return ".setup()"
            case .m_updateCreateButton__enabled_enabled: return ".updateCreateButton(enabled:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func setup() -> Verify { return Verify(method: .m_setup)}
        public static func updateCreateButton(enabled: Parameter<Bool>) -> Verify { return Verify(method: .m_updateCreateButton__enabled_enabled(`enabled`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setup(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_setup, performs: perform)
        }
        public static func updateCreateButton(enabled: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_updateCreateButton__enabled_enabled(`enabled`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

