// Generated support for SwiftMocky in screen tests
// Keep this file in sync by running: /tmp/SwiftyMocky/bin/swiftymocky generate

import Foundation
import UIKit
@testable import TestingTask

//sourcery: AutoMockable
protocol LoginScreenViewInputMockable: LoginScreenViewInput {}

//sourcery: AutoMockable
protocol LoginScreenRouterInputMockable: LoginScreenRouterInput {}

//sourcery: AutoMockable
protocol AuthServiceProtocolMockable: AuthServiceProtocol {}

//sourcery: AutoMockable
protocol SignUpScreenViewInputMockable: SignUpScreenViewInput {}

//sourcery: AutoMockable
protocol SignUpScreenRouterInputMockable: SignUpScreenRouterInput {}

//sourcery: AutoMockable
protocol NewsViewInputMockable: NewsViewInput {}

//sourcery: AutoMockable
protocol NewsRouterInputMockable: NewsRouterInput {}

//sourcery: AutoMockable
protocol FavoriteViewInputMockable: FavoriteViewInput {}

//sourcery: AutoMockable
protocol FavoriteRouterInputMockable: FavoriteRouterInput {}

//sourcery: AutoMockable
protocol ArticleViewInputMockable: ArticleViewInput {}

//sourcery: AutoMockable
protocol ArticleRouterInputMockable: ArticleRouterInput {}


// MARK: - Runtime Count.swift

import Foundation

/// Count enum. Use it for all Verify features, when checking how many times something happened.
///
/// There are three ways of using it:
///   1. Explicit literal - you can pass 0, 1, 2 ... to verify exact number
///   2. Using predefined .custom, to specify custom matching rule.
///   3. Using one of predefined rules, for example:
///       - .atLeastOnce
///       - .exactly(1)
///       - .from(2, to: 4)
///       - .less(than: 2)
///       - .lessOrEqual(to: 1)
///       - .more(than: 2)
///       - .moreOrEqual(to: 3)
///       - .never
public enum Count: ExpressibleByIntegerLiteral {
    /// Count matching closure
    public typealias CustomMatchingClosure = ( _ value: Int ) -> Bool
    /// [Internal] Count is represented by integer literals, with type Int
    public typealias IntegerLiteralType = Int

    /// Called at least once
    case atLeastOnce
    /// Called exactly once
    case once
    /// Custom count resolving closure
    case custom(CustomMatchingClosure)
    /// Called exactly n times
    case exactly(Int)
    /// Called in a...b range
    case from(Int, to: Int)
    /// Called less than n times
    case less(than: Int)
    /// Called less than ot equal to n times
    case lessOrEqual(to: Int)
    /// Called more than n times
    case more(than: Int)
    /// Called more than ot equal to n times
    case moreOrEqual(to: Int)
    /// Never called
    case never

    /// Creates new count instance, matching specific count
    ///
    /// - Parameter value: Exact count value
    public init(integerLiteral value: IntegerLiteralType) {
        self = .exactly(value)
    }
}

// MARK: - CustomStringConvertible

extension Count: CustomStringConvertible {
    /// Human readable description
    public var description: String {
        switch self {
        case .atLeastOnce:
            return "at least 1"
        case .once:
            return "once"
        case .custom:
            return "custom"
        case .exactly(let value):
            return "exactly \(value)"
        case .from(let lowerBound, let upperBound):
            return "from \(lowerBound) to \(upperBound)"
        case .less(let value):
            return "less than \(value)"
        case .lessOrEqual(let value):
            return "less than or equal to \(value)"
        case .more(let value):
            return "more than \(value)"
        case .moreOrEqual(let value):
            return "more than or equal to \(value)"
        case .never:
            return "none"
        }
    }
}

// MARK: - Countable

extension Count: Countable {

    /// Returns whether given count matches countable case.
    ///
    /// - Parameter count: Given count
    /// - Returns: true, if it is within boundaries, false otherwise
    public func matches(_ count: Int) -> Bool {
        switch self {
        case .atLeastOnce:
            return count >= 1
        case .once:
            return count == 1
        case .custom(let matchingRule):
            return matchingRule(count)
        case .exactly(let value):
            return count == value
        case .from(let lowerBound, to: let upperBound):
            return count >= lowerBound && count <= upperBound
        case .less(let value):
            return count < value
        case .lessOrEqual(let value):
            return count <= value
        case .more(let value):
            return count > value
        case .moreOrEqual(let value):
            return count >= value
        case .never:
            return count == 0
        }
    }
}

// MARK: - Runtime Countable.swift

import Foundation

/// Allows matching count, verifying whether given count is right or not
public protocol Countable {
    /// Returns whether given count matches countable case.
    ///
    /// - Parameter count: Given count
    /// - Returns: true, if it is within boundaries, false otherwise
    func matches(_ count: Int) -> Bool
}

extension UInt: Countable {
    /// Returns whether given count matches countable case.
    ///
    /// - Parameter count: Given count
    /// - Returns: true, if it is within boundaries, false otherwise
    public func matches(_ count: Int) -> Bool {
        return Int(self) == count
    }
}

extension Int: Countable {
    /// Returns whether given count matches countable case.
    ///
    /// - Parameter count: Given count
    /// - Returns: true, if it is within boundaries, false otherwise
    public func matches(_ count: Int) -> Bool {
        return self == count
    }
}

// MARK: - Runtime GenericAttribute.swift

import Foundation

/// [Internal] Used as generic constraint for generic method stubs.
public protocol TypeErasedValue {
    /// [internal] Returned value
    var value: Any { get }
    /// [internal] Used to describe attribute generocity (0 is general, 1 is specific)
    var intValue: Int { get }
    /// [internal] Used to compare with other generic attributes values
    var compare: (Any,Any,Matcher) -> Bool { get }
    /// [internal] Used for formatting messages.
    var shortDescription: String { get }
}

/// [Internal] Used to wrap generic parameters, for sake of generic method stubs.
public struct GenericAttribute: TypeErasedValue {
    /// [internal] Returned value
    public let value: Any
    /// [internal] Used to describe attribute generocity (0 is general, 1 is specific)
    public var intValue: Int
    /// [internal] Used to compare with other generic attributes
    public let compare: (Any,Any,Matcher) -> Bool
    /// [internal] Used for formatting messages.
    public let shortDescription: String

    /// [internal] Creates new GenericAttribute instance, with specified return value and compare closure
    ///
    /// - Parameters:
    ///   - value: Returned value
    ///   - compare: Used to compare with other generic attributes values
    public init(
        value: Any,
        intValue: Int,
        shortDescription: String,
        compare: @escaping (Any,Any,Matcher) -> Bool
    ) {
        self.value = value
        self.intValue = intValue
        self.shortDescription = shortDescription
        self.compare = compare
    }
}

/// [Internal] Used to wrap availability constrained attributes, since enum cases used ubternally to
/// represent method/variable/subscript invocation/stub cannot have availability clauses.
public struct TypeErasedAttribute: TypeErasedValue {
    /// [internal] Returned value
    public let value: Any
    /// [internal] Used to describe attribute generocity (0 is general, 1 is specific)
    public var intValue: Int
    /// [internal] Used to compare with other attribute
    public let compare: (Any,Any,Matcher) -> Bool
    /// [internal] Used for formatting messages.
    public let shortDescription: String

    /// [internal] Creates new TypeErasedAttribute instance, with specified return value and compare closure
    ///
    /// - Parameters:
    ///   - value: Returned value
    ///   - compare: Used to compare with other attribute
    public init(
        value: Any,
        intValue: Int,
        shortDescription: String,
        compare: @escaping (Any,Any,Matcher) -> Bool
    ) {
        self.value = value
        self.intValue = intValue
        self.shortDescription = shortDescription
        self.compare = compare
    }
}

// MARK: - Runtime Matcher.swift

import Foundation

/// Matcher is container class, responsible for storing and resolving comparators for given types.
public class Matcher {
    /// Shared **Matcher** instance
    public static var `default` = Matcher()
    /// [Internal] Matchers storage
    private var matchers: [(Mirror,Any)] = []
    /// [Internal] file where comparison faiure should be recorded
    private var file: StaticString?
    /// [Internal] line where comparison faiure should be recorded
    private var line: UInt?
    /// [Internal] matcher fatal error handler
    public static var fatalErrorHandler: (String, StaticString, UInt) -> Void = { _,_,_ in}

    /// Create new clean matcher instance.
    public init() {
        registerBasicTypes()
        register(GenericAttribute.self) { [unowned self] (a, b) -> Bool in
            return a.compare(a.value,b.value,self)
        }
    }

    /// Creante new matcher instance, copying existing comparator from another instance.
    ///
    /// - Parameter matcher: other matcher instance
    public init(matcher: Matcher) {
        self.matchers = matcher.matchers
    }

    /// Registers array comparators for all basic types, their optional versions
    /// and arrays containing elements of that type. For all of them, no manual
    /// registering of comparator is needed.
    ///
    /// We defined basic types as:
    ///
    /// - Bool
    /// - String
    /// - Float
    /// - Double
    /// - Character
    /// - Int
    /// - Int8
    /// - Int16
    /// - Int32
    /// - Int64
    /// - UInt
    /// - UInt8
    /// - UInt16
    /// - UInt32
    /// - UInt64
    ///
    /// Called automatically in every Matcher init.
    ///
    internal func registerBasicTypes() {
#if swift(>=4.1)
        register([Bool].self)
        register([String].self)
        register([Float].self)
        register([Double].self)
        register([Character].self)
        register([Int].self)
        register([Int8].self)
        register([Int16].self)
        register([Int32].self)
        register([Int64].self)
        register([UInt].self)
        register([UInt8].self)
        register([UInt16].self)
        register([UInt32].self)
        register([UInt64].self)
        register([Data].self)
        register([Bool?].self)
        register([String?].self)
        register([Float?].self)
        register([Double?].self)
        register([Character?].self)
        register([Int?].self)
        register([Int8?].self)
        register([Int16?].self)
        register([Int32?].self)
        register([Int64?].self)
        register([UInt?].self)
        register([UInt8?].self)
        register([UInt16?].self)
        register([UInt32?].self)
        register([UInt64?].self)
        register([Data?].self)

        // Types
        register(Bool.self)
        register(String.self)
        register(Float.self)
        register(Double.self)
        register(Character.self)
        register(Int.self)
        register(Int8.self)
        register(Int16.self)
        register(Int32.self)
        register(Int64.self)
        register(UInt.self)
        register(UInt8.self)
        register(UInt16.self)
        register(UInt32.self)
        register(UInt64.self)
        register(Data.self)
        register(Bool?.self)
        register(String?.self)
        register(Float?.self)
        register(Double?.self)
        register(Character?.self)
        register(Int?.self)
        register(Int8?.self)
        register(Int16?.self)
        register(Int32?.self)
        register(Int64?.self)
        register(UInt?.self)
        register(UInt8?.self)
        register(UInt16?.self)
        register(UInt32?.self)
        register(UInt64?.self)
        register(Data?.self)
#else
        register([Bool].self) { (a: Bool, b: Bool) in return a == b }
        register([String].self) { (a: String, b: String) in return a == b }
        register([Float].self)  { (a: Float, b: Float) in return a == b }
        register([Double].self)  { (a: Double, b: Double) in return a == b }
        register([Character].self) { (a: Character, b: Character) in return a == b }
        register([Int].self) { (a: Int, b: Int) in return a == b }
        register([Int8].self) { (a: Int8, b: Int8) in return a == b }
        register([Int16].self) { (a: Int16, b: Int16) in return a == b }
        register([Int32].self)  { (a: Int32, b: Int32) in return a == b }
        register([Int64].self) { (a: Int64, b: Int64) in return a == b }
        register([UInt].self) { (a: UInt, b: UInt) in return a == b }
        register([UInt8].self) { (a: UInt8, b: UInt8) in return a == b }
        register([UInt16].self) { (a: UInt16, b: UInt16) in return a == b }
        register([UInt32].self) { (a: UInt32, b: UInt32) in return a == b }
        register([UInt64].self) { (a: UInt64, b: UInt64) in return a == b }
        register([Data].self) { (a: Data, b: Data) in return a == b }
        register([Bool?].self) { (a: Bool?, b: Bool?) in return a == b }
        register([String?].self) { (a: String?, b: String?) in return a == b }
        register([Float?].self) { (a: Float?, b: Float?) in return a == b }
        register([Double?].self) { (a: Double?, b: Double?) in return a == b }
        register([Character?].self) { (a: Character?, b: Character?) in return a == b }
        register([Int?].self) { (a: Int?, b: Int?) in return a == b }
        register([Int8?].self) { (a: Int8?, b: Int8?) in return a == b }
        register([Int16?].self) { (a: Int16?, b: Int16?) in return a == b }
        register([Int32?].self) { (a: Int32?, b: Int32?) in return a == b }
        register([Int64?].self) { (a: Int64?, b: Int64?) in return a == b }
        register([UInt?].self) { (a: UInt?, b: UInt?) in return a == b }
        register([UInt8?].self) { (a: UInt8?, b: UInt8?) in return a == b }
        register([UInt16?].self) { (a: UInt16?, b: UInt16?) in return a == b }
        register([UInt32?].self) { (a: UInt32?, b: UInt32?) in return a == b }
        register([UInt64?].self) { (a: UInt64?, b: UInt64?) in return a == b }
        register([Data?].self) { (a: Data?, b: Data?) in return a == b }
#endif

        // Types
        register(Any.Type.self) { _, _ in return true }
        register(Bool.Type.self)
        register(String.Type.self)
        register(Float.Type.self)
        register(Double.Type.self)
        register(Character.Type.self)
        register(Int.Type.self)
        register(Int8.Type.self)
        register(Int16.Type.self)
        register(Int32.Type.self)
        register(Int64.Type.self)
        register(UInt.Type.self)
        register(UInt8.Type.self)
        register(UInt16.Type.self)
        register(UInt32.Type.self)
        register(UInt64.Type.self)
        register(Data.Type.self)
        register(Any?.Type.self) { _, _ in return true }
        register(Bool?.Type.self)
        register(String?.Type.self)
        register(Float?.Type.self)
        register(Double?.Type.self)
        register(Character?.Type.self)
        register(Int?.Type.self)
        register(Int8?.Type.self)
        register(Int16?.Type.self)
        register(Int32?.Type.self)
        register(Int64?.Type.self)
        register(UInt?.Type.self)
        register(UInt8?.Type.self)
        register(UInt16?.Type.self)
        register(UInt32?.Type.self)
        register(UInt64?.Type.self)
        register(Data?.Type.self)
    }

    public func set(file: StaticString?, line: UInt?) {
        self.file = file
        self.line = line
    }

    public func setupCorrentFileAndLine(file: StaticString = #file, line: UInt = #line) {
        self.set(file: file, line: line)
    }

    public func clearFileAndLine() {
        self.set(file: nil, line: nil)
    }

    public func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return }
        Matcher.fatalErrorHandler(message, file, line)
    }

    /// Registers comparator for given type **T**.
    ///
    /// Comparator is a closure of `(T,T) -> Bool`.
    ///
    /// When several comparators for same type  are registered to common
    /// **Matcher** instance - it will resolve the most receont one.
    ///
    /// - Parameters:
    ///   - valueType: compared type
    ///   - match: comparator closure
    public func register<T>(_ valueType: T.Type, match: @escaping (T,T) -> Bool) {
        let mirror = Mirror(reflecting: valueType)
        matchers.append((mirror, match as Any))
    }

    /// Registers comparator for type, like comparing Int.self to Int.self. These types of comparators always returns true. Register like: `Matcher.default.register(CustomType.Type.self)`
    ///
    /// - Parameter valueType: Type.Type.self
    public func register<T>(_ valueType: T.Type.Type) {
        self.register(valueType, match: { _, _ in return true })
    }

    /// Register default comparatot for Equatable types. Required for generic mocks to work.
    ///
    /// - Parameter valueType: Equatable type
    public func register<T>(_ valueType: T.Type) where T: Equatable {
        let mirror = Mirror(reflecting: valueType)
        matchers.append((mirror, comparator(for: T.self) as Any))
    }

    /// Returns comparator closure for given type (if any).
    ///
    /// Comparator is a closure of `(T,T) -> Bool`.
    ///
    /// When several comparators for same type  are registered to common
    /// **Matcher** instance - it will resolve the most receont one.
    ///
    /// - Parameter valueType: compared type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? {
        let mirror = Mirror(reflecting: valueType)
        let comparator = matchers.reversed().first { (current, _) -> Bool in
            return current.subjectType == mirror.subjectType
        }?.1

        return comparator as? (T,T) -> Bool
    }

    /// Default Sequence comparator, compares count, and then depending on sequence type:
    /// - for Arrays, elements will be compared element by element (verifying order as well)
    /// - other Sequences would be treated as unordered, so every element has to have matching element
    ///
    /// - Parameter valueType: Sequence type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Sequence {
        let mirror = Mirror(reflecting: valueType)
        let comparator = matchers.reversed().first { (current, _) -> Bool in
            return current.subjectType == mirror.subjectType
        }?.1

        if let compare = comparator as? (T,T) -> Bool {
            return compare
        } else if let compare = self.comparator(for: T.Element.self) {
            return { (l: T, r: T) -> Bool in
                let lhs = l.map { $0 }
                let rhs = r.map { $0 }
                guard lhs.count == rhs.count else { return false }

                if valueType is [T.Element].Type {
                    // Compare as ordered sequence:
                    for i in 0..<lhs.count {
                        guard compare(lhs[i],rhs[i]) else { return false }
                    }

                    return true
                } else {
                    // Compare as unordered sequence:
                    var lbuff = lhs
                    var rbuff = rhs

                    while !lbuff.isEmpty {
                        let rIndex = rbuff.firstIndex { compare(lbuff[0],$0) }
                        if let rIndex = rIndex {
                            // There is a match, remove both matching elements.
                            rbuff.remove(at: rIndex)
                            lbuff.remove(at: 0)
                        } else {
                            // There is no matching element - stop execution.
                            return false
                        }
                    }

                    return lbuff.isEmpty && rbuff.isEmpty
                }
            }
        } else {
            return nil
        }
    }

    /// Default Equatable comparator, compares if elements are equal.
    ///
    /// - Parameter valueType: Equatable type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Equatable {
        return { $0 == $1 }
    }

    /// Default Equatable Sequence comparator, compares count, and then for every element equal element.
    ///
    /// - Parameter valueType: Equatable Sequence type
    /// - Returns: comparator closure
    public func comparator<T>(for valueType: T.Type) -> ((T,T) -> Bool)? where T: Equatable, T: Sequence {
        return { $0 == $1 }
    }
}

// MARK: - Runtime Mock+Assertions.swift

import Foundation

// MARK: - At least once instance member called

/// Verify that given method was called on mock object **at least once**.
///
/// - Parameters:
///   - object: Mock instance
///   - method: Method signature with wrapped parameters (`Parameter`)
///   - file: for XCTest print purposes
///   - line: for XCTest print purposes
public func Verify<T: Mock>(_ object: T, _ method: T.Verify, file: StaticString = #file, line: UInt = #line) {
    object.verify(method, count: .moreOrEqual(to: 1), file: file, line: line)
}

// MARK: - At least once static member called

/// Verify that given static method was called on mock type **at least once**.
///
/// - Parameters:
///   - object: Mock type
///   - method: Method signature with wrapped parameters (`Parameter`)
///   - file: for XCTest print purposes
///   - line: for XCTest print purposes
public func Verify<T: StaticMock>(_ type: T.Type, _ method: T.StaticVerify, file: StaticString = #file, line: UInt = #line) {
    T.verify(method, count: .moreOrEqual(to: 1), file: file, line: line)
}

// MARK: - Instance member called with explicit count

/// Verify that given method was called on mock object **exact number of times**.
///
/// - Parameters:
///   - object: Mock instance
///   - count: Number of invocations
///   - method: Method signature with wrapped parameters (`Parameter`)
///   - file: for XCTest print purposes
///   - line: for XCTest print purposes
public func Verify<T: Mock>(_ object: T, _ count: Count, _ method: T.Verify, file: StaticString = #file, line: UInt = #line) {
    object.verify(method, count: count, file: file, line: line)
}

// MARK: - Static member called with explicit count

/// Verify that given static method was called on mock type **exact number of times**.
///
/// - Parameters:
///   - object: Mock type
///   - count: Number of invocations
///   - method: Static method signature with wrapped parameters (`Parameter`)
///   - file: for XCTest print purposes
///   - line: for XCTest print purposes
public func Verify<T: StaticMock>(_ type: T.Type, _ count: Count, _ method: T.StaticVerify, file: StaticString = #file, line: UInt = #line) {
    T.verify(method, count: count, file: file, line: line)
}

// MARK: - Given

/// Setup return value for method stubs in mock instance. When this method will be called on mock, it
/// will check for first matching given, with following rules:
/// 1. First check most specific givens (with explicit parameters - .value), then for wildcard parameters (.any)
/// 2. More recent givens have higher priority than older ones
/// 3. When two given's have same level of explicity, like:
///     ```
///     Given(mock, .do(with: .value(1), and: .any)
///     Given(mock, .do(with: .any, and: .value(1))
///     ```
///     Method stub will return the one depending on mock sequencingPolicy. By default it means most recent one.
///
/// - Parameters:
///   - object: Mock instance
///   - method: Method signature with wrapped parameters (Parameter<ValueType>) and return value
///   - policy: Stubbing policy - uses mock policy by default (which defaults to .wrap)
public func Given<T: Mock>(_ object: T, _ method: T.Given, _ policy: StubbingPolicy = .default) {
    object.given(policy.apply(to: method))
}

/// Setup return value for static method stubs on mock type. When this static method will be called, it
/// will check for first matching given, with following rules:
/// 1. First check most specific givens (with explicit parameters - .value), then for wildcard parameters (.any)
/// 2. More recent givens have higher priority than older ones
/// 3. When two given's have same level of explicity, like:
///     ```
///     Given(T.self, .do(with: .value(1), and: .any)
///     Given(T.self, .do(with: .any, and: .value(1))
///     ```
///     Method stub will return the one depending on mock sequencingPolicy. By default it means most recent one.
///
/// - Parameters:
///   - object: Mock type
///   - method: Static method signature with wrapped parameters (Parameter<ValueType>) and return value
///   - policy: Stubbing policy - uses mock policy by default (which defaults to .wrap)
public func Given<T: StaticMock>(_ type: T.Type, _ method: T.StaticGiven, _ policy: StubbingPolicy = .default) {
    type.given(policy.apply(to: method))
}

// MARK: - Perform

/// Setup perform closure for method stubs in mock instance. When this method will be called on mock, it
/// will check for first matching closure and execute it with parameters passed. Have in mind following rules:
/// 1. First check most specific performs (with explicit parameters - .value), then for wildcard parameters (.any)
/// 2. More recent performs have higher priority than older ones
/// 3. When two performs have same level of explicity, like:
///     ```
///     Perform(mock, .do(with: .value(1), and: .any, perform: { ... }))
///     Perform(mock, .do(with: .any, and: .value(1), perform: { ... }))
///     ```
///     Method stub will return the one depending on mock sequencingPolicy. By default it means most recent one.
///
/// - Parameters:
///   - object: Mock instance
///   - method: Method signature with wrapped parameters (Parameter<ValueType>) and perform closure
public func Perform<T: Mock>(_ object: T, _ method: T.Perform) {
    object.perform(method)
}

/// Setup perform closure for static method stubs for mock type. When this method will be called on mock type, it
/// will check for first matching closure and execute it with parameters passed. Have in mind following rules:
/// 1. First check most specific performs (with explicit parameters - .value), then for wildcard parameters (.any)
/// 2. More recent performs have higher priority than older ones
/// 3. When two performs have same level of explicity, like:
///     ```
///     Perform(T.self, .do(with: .value(1), and: .any, perform: { ... }))
///     Perform(T.self, .do(with: .any, and: .value(1), perform: { ... }))
///     ```
///     Method stub will return the one depending on mock sequencingPolicy. By default it means most recent one.
///
/// - Parameters:
///   - object: Mock type
///   - method: Static method signature with wrapped parameters (Parameter<ValueType>) and perform closure
public func Perform<T: StaticMock>(_ object: T.Type, _ method: T.StaticPerform) {
    T.perform(method)
}

// MARK: - Helpers

/// [Internal] Fails flow with given message
///
/// - Parameter message: Failure message
/// - Returns: Never
public func Failure(_ message: String) -> Swift.Never {
    let errorMessage = "[FATAL] \(message)"
    FatalErrorUtil.fatalError(errorMessage)
}

/// [Internal] Used for handling fatal errors inside library.
public struct FatalErrorUtil {
    /// [Internal] Handler
    private static var handler: (String) -> Never = {
        print($0)
        exit(0)
    }
    /// [Internal] Default handler
    private static var defalutHandler: (String) -> Never = {
        print($0)
        exit(0)
    }

    /// [Internal] Override handling error handler
    ///
    /// - Parameter new: New handler
    public static func set(_ new: @escaping (String) -> Never) {
        handler = new
    }

    /// [Internal] Restores default handler
    public static func restore() {
        handler = defalutHandler
    }

    /// [Internal] Perform fatal error handler
    ///
    /// - Parameter message: Message
    public static func fatalError(_ message: String) -> Never {
        handler(message)
    }
}

public extension Optional {
    /// Returns unwrapped value, or fails.
    ///
    /// - Parameter message: Failure message
    /// - Returns: Unwrapped value
    func orFail(_ message: String = "unwrapping nil") -> Wrapped {
        return self ?? { Failure(message) }()
    }
}

private extension StubbingPolicy {
    /// [Internal] Apply stubbing policy
    ///
    /// - Parameter method: Method
    /// - Returns: With new policy
    func apply<T>(to method: T) -> T {
        return ((method as? WithStubbingPolicy)?.with(self) as? T) ?? method
    }
}

// MARK: - Runtime Mock.swift

import Foundation

public enum MockScope {
    case invocation
    case given
    case perform
}

/// Every generated mock implementation adopts **Mock** protocol.
/// It defines base Mock structure and features.
public protocol Mock: AnyObject {
    /// Stubbed method and property type
    associatedtype Given
    /// Verification type
    associatedtype Verify
    /// Perform type
    associatedtype Perform

    /// Registers return value for stubbed method, for specified attributes set.
    ///
    /// When this method will be called on mock, it will check for first matching given, with following rules:
    /// 1. First check most specific givens (with explicit parameters - .value), then for wildcard parameters (.any)
    /// 2. More recent givens have higher priority than older ones
    /// 3. When two given's have same level of explicity, like:
    ///     ```
    ///     Given(mock, .do(with: .value(1), and: .any)
    ///     Given(mock, .do(with: .any, and: .value(1))
    ///     ```
    ///     Method stub will return most recent one.
    ///
    ///
    /// - Parameter method: signature, with attributes (any or explicit value). Type `.` for all available
    func given(_ method: Given)

    /// Registers perform closure, which will be executed upon calling stubbed method, for specified attribtes.
    ///
    /// When this method will be called on mock, it
    /// will check for first matching closure and execute it with parameters passed. Have in mind following rules:
    /// 1. First check most specific performs (with explicit parameters - .value), then for wildcard parameters (.any)
    /// 2. More recent performs have higher priority than older ones
    /// 3. When two performs have same level of explicity, like:
    ///     ```
    ///     Perform(mock, .do(with: .value(1), and: .any, perform: { ... }))
    ///     Perform(mock, .do(with: .any, and: .value(1), perform: { ... }))
    ///     ```
    ///     Method stub will return most recent one.
    ///
    /// - Parameter method: signature, with attributes (any or explicit value). Type `.` for all available
    func perform(_ method: Perform)

    /// Verifies, that given method stub was called exact number of times.
    ///
    /// - Parameters:
    ///   - method: Method signature with wrapped parameters (Parameter<ValueType>)
    ///   - count: Number of invocations
    ///   - file: for XCTest print purposes
    ///   - line: for XCTest print purposes
    func verify(_ method: Verify, count: Count, file: StaticString, line: UInt)

    /// Clear mock internals. You can specify what to clear (invocations aka verify, givens or performs)
    /// or leave it empty to clear all mock internals.
    ///
    /// Example:
    /// ```swift
    /// mock.resetMock(.invocation)         // clear invocations, Verify will have all the count on 0
    /// mock.resetMock(.given, .perform)    // clear only mock setup, invocations stays
    /// mock.resetMock()                    // clear all
    /// ```
    func resetMock(_ scopes: MockScope...)
}

/// Every mock, that stubs static methods, should adopt **StaticMock** protocol.
/// It defines base StaticMock structure and features.
public protocol StaticMock: AnyObject {
    /// Stubbed method and property type
    associatedtype StaticGiven
    /// Verification type
    associatedtype StaticVerify
    /// Perform type
    associatedtype StaticPerform

    /// Registers return value for stubbed method, for specified attributes set.
    ///
    /// When this method will be called on mock, it will check for first matching given, with following rules:
    /// 1. First check most specific givens (with explicit parameters - .value), then for wildcard parameters (.any)
    /// 2. More recent givens have higher priority than older ones
    /// 3. When two given's have same level of explicity, like:
    ///     ```
    ///     Given(mock, .do(with: .value(1), and: .any)
    ///     Given(mock, .do(with: .any, and: .value(1))
    ///     ```
    ///     Method stub will return most recent one.
    ///
    ///
    /// - Parameter method: signature, with attributes (any or explicit value). Type `.` for all available
    static func given(_ method: StaticGiven)

    /// Registers perform closure, which will be executed upon calling stubbed method, for specified attribtes.
    ///
    /// When this method will be called on mock, it
    /// will check for first matching closure and execute it with parameters passed. Have in mind following rules:
    /// 1. First check most specific performs (with explicit parameters - .value), then for wildcard parameters (.any)
    /// 2. More recent performs have higher priority than older ones
    /// 3. When two performs have same level of explicity, like:
    ///     ```
    ///     Perform(mock, .do(with: .value(1), and: .any, perform: { ... }))
    ///     Perform(mock, .do(with: .any, and: .value(1), perform: { ... }))
    ///     ```
    ///     Method stub will return most recent one.
    ///
    /// - Parameter method: signature, with attributes (any or explicit value). Type `.` for all available
    static func perform(_ method: StaticPerform)

    /// Verifies, that given method stub was called exact number of times.
    ///
    /// - Parameters:
    ///   - method: Method signature with wrapped parameters (Parameter<ValueType>)
    ///   - count: Number of invocations
    ///   - file: for XCTest print purposes
    ///   - line: for XCTest print purposes
    static func verify(_ method: StaticVerify, count: Count, file: StaticString, line: UInt)

    /// Clear mock internals. You can specify what to clear (invocations aka verify, givens or performs)
    /// or leave it empty to clear all mock internals.
    ///
    /// Example:
    /// ```swift
    /// mock.resetMock(.invocation)         // clear invocations, Verify will have all the count on 0
    /// mock.resetMock(.given, .perform)    // clear only mock setup, invocations stays
    /// mock.resetMock()                    // clear all
    /// ```
    static func resetMock(_ scopes: MockScope...)
}

// MARK: - Runtime Parameter+Compare.swift

import Foundation

//// MARK: - Equality

public extension Parameter {

    /// Returns whether given two parameters are matching each other, with following rules:
    ///
    /// 1. if parameter is .any - it is equal to any other parameter
    /// 2. if both are .value - then compare wrapped ValueType instances.
    /// 3. if they are not Equatable (or not a Sequences of Equatable), use provided matcher instance
    ///
    /// - Parameters:
    ///   - lhs: First parameter
    ///   - rhs: Second parameter
    ///   - matcher: Matcher instance
    /// - Returns: true, if first is matching second
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case (.value(let left), .value(let right)):
            guard let compare = matcher.comparator(for: ValueType.self) else {
                noComparatorFailure(in: matcher)
            }
            return compare(left,right)
        default: return false
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func wrapAsGeneric() -> Parameter<GenericAttribute> {
        // TODO: - Simplify in same way as type erased attribute.
        switch self {
        case ._:
            return .value(GenericAttribute(
                value: Mirror(reflecting: ValueType.self),
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? Mirror else { return false }
                    if let rv = r as? Mirror {
                        return lv.subjectType == rv.subjectType
                    } else if let _ = r as? ValueType {
                        return true // .any comparing .value or .matching
                    } else {
                        return false
                    }
                }
            ))
        case let .value(value):
            return .value(GenericAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ValueType  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.value(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? ((ValueType) -> Bool) {
                        return rv(lv)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        case let .matching(match):
            return .value(GenericAttribute(
                value: match,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ((ValueType) -> Bool)  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.matching(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func typeErasedAttribute() -> Parameter<TypeErasedAttribute> {
        // A side note - compare is different to `wrapAsGeneric`, as the actual type will always match. There will be no
        // unrelated types.
        switch self {
        case ._:
            return .any
        case let .value(value):
            return .value(TypeErasedAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (lattr, rattr, m) -> Bool in
                    guard let lvalue = lattr as? ValueType else { return false }
                    guard let rvalue = rattr as? ValueType else { return false }
                    return Parameter<ValueType>.compare(lhs: .value(lvalue), rhs: .value(rvalue), with: m)
                }
            ))
        case let .matching(match):
            return .matching { rattr -> Bool in
                guard let rvalue = rattr as? ValueType else { return false }
                return match(rvalue)
            }
        }
    }

    /// [Internal] Fatal error raised when no comparator or default comparator found for `ValueType`.
    static func noComparatorFailure(in matcher: Matcher) -> Swift.Never {
        let message = "No registered comparators for \(String(describing: ValueType.self))"
        print("[FATAL] \(message)")
        matcher.onFatalFailure(message)
        Failure(message)
    }
}

public extension Parameter where ValueType: TypeErasedValue {
    /// [Internal] Compare two parameters
    ///
    /// - Parameters:
    ///   - lhs: one
    ///   - rhs: other
    ///   - matcher: Matcher instance used for comparison
    /// - Returns: true if they are matching, false otherwise
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case (.value(let left), .value(let right)): return left.compare(left.value,right.value,matcher)
        default: return false
        }
    }
}

// MARK: - Compare using default comparators

/// This section is required to be able to persist information about ValueType being a Sequence/Equatable.

public extension Parameter where ValueType: Sequence, ValueType: Equatable {
    /// [Internal] Compare two parameters
    ///
    /// - Parameters:
    ///   - lhs: one
    ///   - rhs: other
    ///   - matcher: Matcher instance used for comparison
    /// - Returns: true if they are matching, false otherwise
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case let (.value(left), .value(right)):
            guard let compare = matcher.comparator(for: ValueType.self) else {
                noComparatorFailure(in: matcher)
            }
            return compare(left,right)
        default: return false
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func wrapAsGeneric() -> Parameter<GenericAttribute> {
        // TODO: - Simplify in same way as type erased attribute.
        switch self {
        case ._:
            return .value(GenericAttribute(
                value: Mirror(reflecting: ValueType.self),
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? Mirror else { return false }
                    if let rv = r as? Mirror {
                        return lv.subjectType == rv.subjectType
                    } else if let _ = r as? ValueType {
                        return true // .any comparing .value or .matching
                    } else {
                        return false
                    }
                }
            ))
        case let .value(value):
            return .value(GenericAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ValueType  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.value(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? ((ValueType) -> Bool) {
                        return rv(lv)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        case let .matching(match):
            return .value(GenericAttribute(
                value: match,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ((ValueType) -> Bool)  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.matching(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func typeErasedAttribute() -> Parameter<TypeErasedAttribute> {
        // A side note - compare is different to `wrapAsGeneric`, as the actual type will always match. There will be no
        // unrelated types.
        switch self {
        case ._:
            return .any
        case let .value(value):
            return .value(TypeErasedAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (lattr, rattr, m) -> Bool in
                    guard let lvalue = lattr as? ValueType else { return false }
                    guard let rvalue = rattr as? ValueType else { return false }
                    return Parameter<ValueType>.compare(lhs: .value(lvalue), rhs: .value(rvalue), with: m)
                }
            ))
        case let .matching(match):
            return .matching { rattr -> Bool in
                guard let rvalue = rattr as? ValueType else { return false }
                return match(rvalue)
            }
        }
    }
}

public extension Parameter where ValueType: Sequence, ValueType.Element: Equatable {
    /// [Internal] Compare two parameters
    ///
    /// - Parameters:
    ///   - lhs: one
    ///   - rhs: other
    ///   - matcher: Matcher instance used for comparison
    /// - Returns: true if they are matching, false otherwise
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case (.value(let left), .value(let right)):
            guard let compare = matcher.comparator(for: ValueType.self) else {
                noComparatorFailure(in: matcher)
            }
            return compare(left,right)
        default: return false
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func wrapAsGeneric() -> Parameter<GenericAttribute> {
        // TODO: - Simplify in same way as type erased attribute.
        switch self {
        case ._:
            return .value(GenericAttribute(
                value: Mirror(reflecting: ValueType.self),
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? Mirror else { return false }
                    if let rv = r as? Mirror {
                        return lv.subjectType == rv.subjectType
                    } else if let _ = r as? ValueType {
                        return true // .any comparing .value or .matching
                    } else {
                        return false
                    }
                }
            ))
        case let .value(value):
            return .value(GenericAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ValueType  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.value(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? ((ValueType) -> Bool) {
                        return rv(lv)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        case let .matching(match):
            return .value(GenericAttribute(
                value: match,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ((ValueType) -> Bool)  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.matching(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func typeErasedAttribute() -> Parameter<TypeErasedAttribute> {
        // A side note - compare is different to `wrapAsGeneric`, as the actual type will always match. There will be no
        // unrelated types.
        switch self {
        case ._:
            return .any
        case let .value(value):
            return .value(TypeErasedAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (lattr, rattr, m) -> Bool in
                    guard let lvalue = lattr as? ValueType else { return false }
                    guard let rvalue = rattr as? ValueType else { return false }
                    return Parameter<ValueType>.compare(lhs: .value(lvalue), rhs: .value(rvalue), with: m)
                }
            ))
        case let .matching(match):
            return .matching { rattr -> Bool in
                guard let rvalue = rattr as? ValueType else { return false }
                return match(rvalue)
            }
        }
    }
}

public extension Parameter where ValueType: Sequence, ValueType.Element: Equatable, ValueType: Equatable {
    /// [Internal] Compare two parameters
    ///
    /// - Parameters:
    ///   - lhs: one
    ///   - rhs: other
    ///   - matcher: Matcher instance used for comparison
    /// - Returns: true if they are matching, false otherwise
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case let (.value(left), .value(right)):
            guard let compare = matcher.comparator(for: ValueType.self) else {
                noComparatorFailure(in: matcher)
            }
            return compare(left,right)
        default: return false
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func wrapAsGeneric() -> Parameter<GenericAttribute> {
        // TODO: - Simplify in same way as type erased attribute.
        switch self {
        case ._:
            return .value(GenericAttribute(
                value: Mirror(reflecting: ValueType.self),
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? Mirror else { return false }
                    if let rv = r as? Mirror {
                        return lv.subjectType == rv.subjectType
                    } else if let _ = r as? ValueType {
                        return true // .any comparing .value or .matching
                    } else {
                        return false
                    }
                }
            ))
        case let .value(value):
            return .value(GenericAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ValueType  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.value(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? ((ValueType) -> Bool) {
                        return rv(lv)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        case let .matching(match):
            return .value(GenericAttribute(
                value: match,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ((ValueType) -> Bool)  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.matching(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func typeErasedAttribute() -> Parameter<TypeErasedAttribute> {
        // A side note - compare is different to `wrapAsGeneric`, as the actual type will always match. There will be no
        // unrelated types.
        switch self {
        case ._:
            return .any
        case let .value(value):
            return .value(TypeErasedAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (lattr, rattr, m) -> Bool in
                    guard let lvalue = lattr as? ValueType else { return false }
                    guard let rvalue = rattr as? ValueType else { return false }
                    return Parameter<ValueType>.compare(lhs: .value(lvalue), rhs: .value(rvalue), with: m)
                }
            ))
        case let .matching(match):
            return .matching { rattr -> Bool in
                guard let rvalue = rattr as? ValueType else { return false }
                return match(rvalue)
            }
        }
    }
}

public extension Parameter where ValueType: Sequence {
    /// Element
    typealias Element = ValueType.Element
    /// [Internal] Compare two parameters
    ///
    /// - Parameters:
    ///   - lhs: one
    ///   - rhs: other
    ///   - matcher: Matcher instance used for comparison
    /// - Returns: true if they are matching, false otherwise
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case let (.value(left), .value(right)):
            guard let compare = matcher.comparator(for: ValueType.self) else {
                noComparatorFailure(in: matcher)
            }
            return compare(left,right)
        default: return false
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func wrapAsGeneric() -> Parameter<GenericAttribute> {
        // TODO: - Simplify in same way as type erased attribute.
        switch self {
        case ._:
            return .value(GenericAttribute(
                value: Mirror(reflecting: ValueType.self),
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? Mirror else { return false }
                    if let rv = r as? Mirror {
                        return lv.subjectType == rv.subjectType
                    } else if let _ = r as? ValueType {
                        return true // .any comparing .value or .matching
                    } else {
                        return false
                    }
                }
            ))
        case let .value(value):
            return .value(GenericAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ValueType  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.value(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? ((ValueType) -> Bool) {
                        return rv(lv)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        case let .matching(match):
            return .value(GenericAttribute(
                value: match,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ((ValueType) -> Bool)  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.matching(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func typeErasedAttribute() -> Parameter<TypeErasedAttribute> {
        // A side note - compare is different to `wrapAsGeneric`, as the actual type will always match. There will be no
        // unrelated types.
        switch self {
        case ._:
            return .any
        case let .value(value):
            return .value(TypeErasedAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (lattr, rattr, m) -> Bool in
                    guard let lvalue = lattr as? ValueType else { return false }
                    guard let rvalue = rattr as? ValueType else { return false }
                    return Parameter<ValueType>.compare(lhs: .value(lvalue), rhs: .value(rvalue), with: m)
                }
            ))
        case let .matching(match):
            return .matching { rattr -> Bool in
                guard let rvalue = rattr as? ValueType else { return false }
                return match(rvalue)
            }
        }
    }
}

public extension Parameter where ValueType: Equatable {
    /// [Internal] Compare two parameters
    ///
    /// - Parameters:
    ///   - lhs: one
    ///   - rhs: other
    ///   - matcher: Matcher instance used for comparison
    /// - Returns: true if they are matching, false otherwise
    static func compare(lhs: Parameter<ValueType>, rhs: Parameter<ValueType>, with matcher: Matcher) -> Bool {
        switch (lhs, rhs) {
        case (._, _): return true
        case (_, ._): return true
        case (.matching(let match), .value(let value)): return match(value)
        case (.value(let value), .matching(let match)): return match(value)
        case let (.value(left), .value(right)):
            guard let compare = matcher.comparator(for: ValueType.self) else {
                noComparatorFailure(in: matcher)
            }
            return compare(left,right)
        default: return false
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func wrapAsGeneric() -> Parameter<GenericAttribute> {
        // TODO: - Simplify in same way as type erased attribute.
        switch self {
        case ._:
            return .value(GenericAttribute(
                value: Mirror(reflecting: ValueType.self),
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? Mirror else { return false }
                    if let rv = r as? Mirror {
                        return lv.subjectType == rv.subjectType
                    } else if let _ = r as? ValueType {
                        return true // .any comparing .value or .matching
                    } else {
                        return false
                    }
                }
            ))
        case let .value(value):
            return .value(GenericAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ValueType  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.value(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? ((ValueType) -> Bool) {
                        return rv(lv)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        case let .matching(match):
            return .value(GenericAttribute(
                value: match,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (l, r, m) -> Bool in
                    guard let lv = l as? ((ValueType) -> Bool)  else { return false }
                    if let rv = r as? ValueType {
                        let lhs = Parameter<ValueType>.matching(lv)
                        let rhs = Parameter<ValueType>.value(rv)
                        return Parameter<ValueType>.compare(lhs: lhs, rhs: rhs, with: m)
                    } else if let rv = r as? Mirror {
                        return Mirror(reflecting: ValueType.self).subjectType == rv.subjectType
                    } else {
                        return false
                    }
                }
            ))
        }
    }

    /// [Internal] Wraps as generic Parameter instance. Should not be ever called directly.
    /// - Returns: Wrapped parameter
    func typeErasedAttribute() -> Parameter<TypeErasedAttribute> {
        // A side note - compare is different to `wrapAsGeneric`, as the actual type will always match. There will be no
        // unrelated types.
        switch self {
        case ._:
            return .any
        case let .value(value):
            return .value(TypeErasedAttribute(
                value: value,
                intValue: intValue,
                shortDescription: shortDescription,
                compare: { (lattr, rattr, m) -> Bool in
                    guard let lvalue = lattr as? ValueType else { return false }
                    guard let rvalue = rattr as? ValueType else { return false }
                    return Parameter<ValueType>.compare(lhs: .value(lvalue), rhs: .value(rvalue), with: m)
                }
            ))
        case let .matching(match):
            return .matching { rattr -> Bool in
                guard let rvalue = rattr as? ValueType else { return false }
                return match(rvalue)
            }
        }
    }
}

// MARK: - Runtime Parameter+Optionals.swift

import Foundation

// MARK: - Optionality checks

/// Protocol around Optional, allowing additional checks and features on `Paramater` where value is optional.
public protocol OptionalType: ExpressibleByNilLiteral {
    var isNotNil: Bool { get }
}

extension Optional: OptionalType {
    public var isNotNil: Bool {
        switch self {
        case .some: return true
        case .none: return false
        }
    }
}

public extension Parameter where ValueType: OptionalType {
    static var notNil: Parameter<ValueType> {
        return Parameter.matching { $0.isNotNil }
    }
}

// MARK: - Runtime Parameter.swift

import Foundation

// MARK: - Parameter

/// Parameter wraps method attribute, allowing to make a difference between explicit value,
/// expressed by `.value` case and wildcard value, expressed by `.any` case.
///
/// Whole idea is to be able to test and specify behaviours, in both generic and explicit way
/// (and any mix of these two). Every test method matches mock methods in signature, but changes attributes types
/// to Parameter.
///
/// That allows pattern like matching between two Parameter values:
/// - **.any** is equal to every other parameter. (**!!!** actual case name is `._`, but it is advised to use `.any`)
/// - **.value(p1)** is equal to **.value(p2)** only, when p1 == p2
///
/// **Important!** Comparing parameters, where ValueType is not Equatable will result in fatalError,
/// unless you register comparator for its *ValueType* in **Matcher** instance used (typically Matcher.default)
///
/// - any: represents and matches any parameter value
/// - value: represents explicit parameter value
public enum Parameter<ValueType> {
    /// Wildcard - any value
    case `_`
    /// Explicit value
    case value(ValueType)
    /// Any value matching
    case matching((ValueType) -> Bool)

    /// Represents and matches any parameter value - syntactic sugar for `._` case.
    public static var any: Parameter<ValueType> { return Parameter<ValueType>._ }

    /// Represents and matches any parameter value - syntactic sugar for `._` case. Used, when needs to explicitely specify
    /// wrapped *ValueType* type, to resolve ambiguity between methods with same signatures, but different attribute types.
    ///
    /// - Parameter type: Explicitly specify ValueType type
    /// - Returns: any parameter
    public static func any<T>(_ type: T.Type) -> Parameter<T> {
        return Parameter<T>._
    }

    public var shortDescription: String {
        switch self {
        case ._: return ".any"
        case .value(let value as TypeErasedValue): return value.shortDescription
        case .value(let value): return String(describing: value)
        case .matching: return ".matching(\(String(describing: ValueType.self)) -> Bool)"
        }
    }
}

// MARK: - Parameter convenience initializers

public extension Parameter where ValueType: AnyObject {

    /// Represents and matches values on an "same instance" basis.
    ///
    /// - Parameter instance: Instance to match against
    static func sameInstance<T: AnyObject>(as instance: T) -> Parameter<ValueType> {
        return .matching { this in
            guard let thisCasted = this as? T else { return false }
            return thisCasted === instance
        }
    }

    /// Represents and matches whether parameter is of specific type, using `is` operator.
    ///
    /// - Parameter type: Type to match against
    static func isInstance<T: AnyObject>(of type: T.Type) -> Parameter<ValueType> {
        return .matching { $0 is T }
    }
}

public extension Parameter {

    /// Allows combining multiple Parameter constraints into one Parameter constraint.
    ///
    /// - Parameter matching: List of parameter constraints
    static func all(_ matching: Parameter<ValueType>...) -> Parameter<ValueType> {
        return .matching { (value: ValueType) -> Bool in
            return matching.contains { (element: Parameter<ValueType>) -> Bool in
                return !Parameter<ValueType>.compare(
                    lhs: element,
                    rhs: .value(value),
                    with: Matcher.default
                )
            }
        }
    }
}

// MARK: - Ordering parameters

public extension Parameter where ValueType: TypeErasedValue {
    /// Used for invocations sorting purpose.
    var intValue: Int {
        switch self {
        case ._: return 0
        case let .value(generic): return generic.intValue
        case .matching: return 1
        }
    }
}

public extension Parameter {
    /// Used for invocations sorting purpose.
    var intValue: Int {
        switch self {
        case ._: return 0
        case .value: return 1
        case .matching: return 1
        }
    }
}

// MARK: - Runtime Policies.swift

import Foundation

// MARK: - Stubbing Policy
/// Given Policy for treating sequence of events (products). Used to determine if stub return values should be consumed
/// once (.drop), or reused (.wrap). Applies to sequence as well - .drop means remove from stack after using, while
/// .wrap iterates over sequence indefinitely.
///
/// - `default`: Use current policy specified for Mock method type
/// - `wrap`: Default policy in general. When reaching end of sequence of events, index will rewind to beginning (looping)
/// - `drop`: With this policy, every call drops event. When events count reaches zero, given is removed from mock.
public enum StubbingPolicy {
    /// Use current policy specified for Mock method type
    case `default`
    /// Default policy in general. When reaching end of sequence of events, index will rewind to beginning (looping)
    case wrap
    /// With this policy, every call drops event. When events count reaches zero, given is removed from mock.
    case drop

    /// [Internal] Resolves used policy. If self is default, will use inherited, otherwise self
    ///
    /// - Parameter inherited: Inherited (usually global default) policy
    /// - Returns: Policy used. Always .wrap or .drop
    public func real(_ inherited: StubbingPolicy) -> StubbingPolicy {
        switch (self, inherited) {
        case (.default, .default): return .wrap // Special case, wrap is always default in general
        case (.default, _): return inherited    // Use inherited for real policy if self is default
        default: return self                    // If policy specified, use it instead of inherited
        }
    }

    /// [Internal] Computes new index for stubs array. For wrap will rewind if out of bounds, for drop will not.
    /// Default is handled as wrap.
    ///
    /// - Parameters:
    ///   - index: Index of current element
    ///   - count: Number of elements
    /// - Returns: New index
    public func updated(_ index: Int, with count: Int) -> Int {
        switch self {
        case .default, .wrap: return (index + 1) % count
        case .drop: return index + 1
        }
    }
}

/// [Internal] used for marking that stubs have configurable policy
public protocol WithStubbingPolicy: AnyObject {
    /// Stubbing policy
    var policy: StubbingPolicy { get set }
    /// [Internal] with new policy
    ///
    /// - Parameter policy: New policy
    /// - Returns: Self with new policy
    func with(_ policy: StubbingPolicy) -> Self
}

public extension WithStubbingPolicy {
    /// [Internal] with new policy
    ///
    /// - Parameter policy: New policy
    /// - Returns: Self with new policy
    func with(_ policy: StubbingPolicy) -> Self {
        self.policy = policy
        return self
    }
}

// MARK: - Sequencing policy
/// Sequencing policy - in which order Given would be resolved. Pleas ehve in mind that this policy is applied ONLY after
/// first ordering (based on how explicit is stub) is done.
///
/// - `lastWrittenResolvedFirst`: Default policy. Last given overrides previous, if they are both with same generocity level
/// - `inWritingOrder`: Givens would be recalled in order of generocity, respecting writing order (first line resolved first)
public enum SequencingPolicy {
    /// Default policy. Last given overrides previous, if they are both with same generocity level
    case lastWrittenResolvedFirst
    /// Givens would be recalled in order of generocity, respecting writing order (first line resolved first)
    case inWritingOrder

    /// [Internal] Sorts stub return values / errors throw with respect to ordering rule and policy
    ///
    /// - Parameters:
    ///   - array: Array to sort
    ///   - order: Default ordering closure
    /// - Returns: Sorted with respoect to ordering and policy
    public func sorted<T>(_ array: [T], by order: (T, T) -> Bool) -> [T] {
        switch self {
        case .lastWrittenResolvedFirst: return array.reversed().sorted(by: order)
        case .inWritingOrder: return array.sorted(by: order)
        }
    }
}

/// Has sequencing policy for stubbing methods
public protocol WithSequencingPolicy {
    /// Used sequencibg policy
    var sequencingPolicy: SequencingPolicy { get set }
}

/// Has sequencing policy for stubbing static methods
public protocol WithStaticSequencingPolicy {
    /// Used sequencibg policy
    static var sequencingPolicy: SequencingPolicy { get set }
}

// MARK: - Runtime Stubbing.swift

import Foundation

/// [Internal] Generic Mock library errors
///
/// - notStubed: Calling method on mock, for which return value was not yet stubbed. DO NOT USE it as stub throw value!
public enum MockError: Error {
    case notStubed
}

/// [Internal] Possible Given products. Method can either return or throw an error (in general)
///
/// - `return`: Return value
/// - `throw`: Thrown error value
public enum StubProduct {
    case `return`(Any)
    case `throw`(Error)

    /// [Internal] If self is returns, and nested value can be casted to T, returns value. Can fail (fatalError)
    ///
    /// - Returns: Value if self is return
    /// - Throws: Error if self is throw
    public func casted<T>() throws -> T {
        switch self {
        case let .throw(error): throw error
        case let .return(value): return (value as? T).orFail("Casting to \(T.self) failed")
        }
    }
}

/// [Internal] Allows to reduce Mock.generated.swif size, by moving part of implementation here.
open class StubbedMethod: WithStubbingPolicy {
    /// [Internal] Returns whether there are still products to be used as stub return values
    public var isValid: Bool { return index < products.count }
    /// [Internal] Stubbing policy. By default uses parent mock policy
    public var policy: StubbingPolicy = .default
    /// [Internal] Array of stub return values
    private var products: [StubProduct]
    /// [Internal] Index of next retutn value. Can be out of bounds.
    private var index: Int = 0

    /// [Internal] Creates new method init with given products.
    ///
    /// - Parameter products: All stub return values
    public init(_ products: [StubProduct]) {
        self.products = products
        self.index = 0
    }

    /// [Internal] Get next product, with respect to self.policy and inherited policy
    ///
    /// - Parameter policy: Inherited policy
    /// - Returns: StubProduct from products array
    public func getProduct(policy: StubbingPolicy) -> StubProduct {
        defer { index = self.policy.real(policy).updated(index, with: products.count) }
        return products[index]
    }

    /// [Internal] New instance of stubber class, used to populate products array
    ///
    /// - Parameter type: Returned value type
    /// - Returns: Stubber instance
    public func stub<T>(for type: T.Type) -> Stubber<T> {
        return Stubber(self, returning: T.self)
    }

    /// [Internal] New instance of stubber class, used to populate products array
    ///
    /// - Parameter type: Returned value type
    /// - Returns: Stubber instance
    public func stubThrows<T>(for type: T.Type) -> StubberThrows<T> {
        return StubberThrows(self, returning: T.self)
    }

    /// Appends new product to products array
    ///
    /// - Parameter product: New stub return value (or error thrown) to append
    fileprivate func append(_ product: StubProduct) {
        products.append(product)
    }
}

/// Used to populate stubbed method with sequence of events. Call it's methods, to record subsequent stub return values.
public struct Stubber<ReturnedValue> {
    /// [Internal] stubbed method
    private var method: StubbedMethod
    /// Stubbing policy. If wrap - it will iterate over recorded values. If drop - it will remove value when stub returns. If default - it will use mock settings
    public var policy: StubbingPolicy {
        get { return method.policy }
        set { method.policy = newValue }
    }

    /// [Internal] New instance of stubber class, used to populate products array
    ///
    /// - Parameters:
    ///   - method: Stubbed method
    ///   - returning: Return
    public init(_ method: StubbedMethod, returning: ReturnedValue.Type) {
        self.method = method
    }

    /// Record return value
    ///
    /// - Parameter value: return value
    public func `return`(_ value: ReturnedValue) {
        method.append(.return(value))
    }

    /// Record subsequent return values, in given order (comma separated)
    ///
    /// - Parameter values: return values
    public func `return`(_ values: ReturnedValue...) {
        values.forEach(self.return)
    }
}

/// Used to populate stubbed method with sequence of events. Call it's methods, to record subsequent stub return/throw values.
public struct StubberThrows<ReturnedValue> {
    /// [Internal] stubbed method
    private var method: StubbedMethod
    /// Stubbing policy. If wrap - it will iterate over recorded values. If drop - it will remove value when stub returns. If default - it will use mock settings
    public var policy: StubbingPolicy {
        get { return method.policy }
        set { method.policy = newValue }
    }

    /// [Internal] New instance of stubber class, used to populate products array
    ///
    /// - Parameters:
    ///   - method: Stubbed method
    ///   - returning: Return
    public init(_ method: StubbedMethod, returning: ReturnedValue.Type) {
        self.method = method
    }

    /// Record return value
    ///
    /// - Parameter value: return value
    public func `return`(_ value: ReturnedValue) {
        method.append(.return(value))
    }

    /// Record subsequent return values, in given order (comma separated)
    ///
    /// - Parameter values: return values
    public func `return`(_ values: ReturnedValue...) {
        values.forEach(self.return)
    }

    /// Record thrown error
    ///
    /// - Parameter error: Error to throw
    public func `throw`(_ error: Error) {
        method.append(.throw(error))
    }

    /// Record subsequent thrown errors, in given order (comma separated)
    ///
    /// - Parameter errors: Errors to throw
    public func `throw`(_ errors: Error...) {
        errors.forEach(self.throw)
    }
}

// MARK: - Runtime Utils.swift

import Foundation

extension Matcher {
    public struct ComparisonResult {
        public let matched: Int
        public let total: Int
        public let results: [ParameterComparisonResult]

        public var percentage: Float { return self.total != 0 ? (Float(matched) / Float(total)) * 100.0 : 0 }
        public var percentageString: String { return String(format: "%.2f", percentage) }
        public var isFullMatch: Bool { return matched == total && total != 0 }
        public var isMatch: Bool { return self.matched > 0 }

        public init(_ results: [ParameterComparisonResult]) {
            self.results = results
            // Add 1 to both for matching method. So methods with na params are 1/1
            self.matched = results.filter { $0.matches }.count + 1
            self.total = results.count + 1
        }

        public init(matched: Int, total: Int) {
            self.matched = matched
            self.total = total
            self.results = []
        }

        public static var match: ComparisonResult { return ComparisonResult(matched: 1, total: 1) }
        public static var none: ComparisonResult { return ComparisonResult(matched: 0, total: 0) }

        public func resultString(_ index: Int, _ selectorName: String) -> String {
            let resultsString = self.results.map { "  \($0.resultString)" }.joined(separator: "\n")
            return "\(index + 1)) \(selectorName) [\(self.percentageString)%]\n\(resultsString)"
        }
    }

    public struct ParameterComparisonResult {
        let matches: Bool
        let left: String
        let right: String
        let label: String

        public init<T,U>(_ matches: Bool, _ left: Parameter<T>, _ right: Parameter<U>, _ label: String) {
            self.matches = matches
            self.left = left.shortDescription
            self.right = right.shortDescription
            self.label = label
        }

        public var resultString: String {
            if self.matches {
                return "- (ok)   \(self.label): \(self.left) == \(self.right)"
            } else {
                return "- (fail) \(self.label): \(self.left) != \(self.right)"
            }
        }
    }
}

public enum Utils {

    public static func closestCallsMessage(
        for results: [Matcher.ComparisonResult],
        name assertionName: String
    ) -> String {
        let closestMisses = results
            .reversed()
            .filter { !$0.isFullMatch && $0.isMatch }
            .sorted { $0.percentage > $1.percentage }

        guard !closestMisses.isEmpty else { return "" }

        let message = closestMisses[..<Swift.min(closestMisses.count, 3)]
            .enumerated()
            .map { offset, element in return element.resultString(offset, assertionName) }
            .joined(separator: "\n")

        return "\nClosest calls recorded:\n\(message)"
    }
}

// MARK: - Runtime ArgumentCaptor.swift

import Foundation

public class ArgumentCaptor<ValueType> {
	/// Last captured value (if any)
	public var value: ValueType? {
		return allValues.last
	}
	/// All captured values
	public private(set) var allValues = [ValueType]()

	public init() {}

	/// Return parameter matcher which captures the argument.
	public func capture(where matches: ((ValueType) -> Bool)? = nil) -> Parameter<ValueType> {
		return .matching { (value: ValueType) -> Bool in
			if let matchFunction = matches {
				let match = matchFunction(value)
				if match {
					self.allValues.append(value)
				}
				return match
			}
			self.allValues.append(value)
			return true
		}
	}
}

// MARK: - Runtime CustomAssertions.swift

#if canImport(XCTest)
import XCTest

/// Allows to verify if error was thrown, and if it is of given type.
///
/// - Parameters:
///   - expression: Expression
///   - error: Expected error type
///   - message: Optional message
///   - file: File (optional)
///   - line: Line (optional)
public func XCTAssertThrowsError<T, E: Error>(
    _ expression: @autoclosure () throws -> T,
    of error: E.Type,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) {
    let throwMessage = message().isEmpty ? "Expected \(T.self) thrown" : message()
    XCTAssertThrowsError(try expression(), throwMessage, file: file, line: line) { errorThrown in
        let typeMessage = message().isEmpty ? "Expected \(T.self), got \(String(describing: errorThrown))" : message()
        XCTAssertTrue(errorThrown is E, typeMessage, file: file, line: line)
    }
}

/// Allows to verify if error was throws, and if its exactly the one expected.
///
/// - Parameters:
///   - expression: Expression
///   - error: Expected error conforming to Equatable, Error
///   - message: Optional message
///   - file: File (optional)
///   - line: Line (optional)
public func XCTAssertThrowsError<T, E>(
    _ expression: @autoclosure () throws -> T,
    error: E, _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) where E: Error, E: Equatable {
    let throwMessage = message().isEmpty ? "Expected \(error) thrown" : message()
    XCTAssertThrowsError(try expression(), throwMessage, file: file, line: line) { errorThrown in
        let typeMessage = message().isEmpty ? "Expected \(error), got \(String(describing: errorThrown))" : message()
        XCTAssertTrue((errorThrown as? E) == error, typeMessage, file: file, line: line)
    }
}
#endif

// MARK: - Runtime MockyAssert.swift

#if canImport(XCTest)
import XCTest
#endif
import Foundation

/// You can use this class if there is need to define custom
/// assertion handler. You can use its static handler closure to alter default
/// behaviour.
///
/// If it is `nil`, the default `assert` method would be used.
public final class MockyAssertion {
    /// You can use it to define assertion behaviour.
    /// Leave blank to not assert at all.
    public static var handler: ((Bool, String, StaticString, UInt) -> Void)?
}

/// [internal] Assertion used by mocks and Verify methods
///
/// - Parameters:
///   - expression: Expression to assert on
///   - message: Message
///   - file: File name (levae default)
///   - line: Line (levae default)
public func MockyAssert(
    _ expression: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = "Verify failed",
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let handler = MockyAssertion.handler else {
        return XCTMockyAssert(expression(), message(), file: file, line: line)
    }

    handler(expression(), message(), file, line)
}


/// [internal] Assertion used by mocks and Verify methods
///
/// - Parameters:
///   - expression: Expression to assert on
///   - message: Message
///   - file: File name (levae default)
///   - line: Line (levae default)
private func XCTMockyAssert(
    _ expression: @autoclosure () -> Bool,
    _ message: @autoclosure () -> String = "Verify failed",
    file: StaticString = #file,
    line: UInt = #line
) {
    #if canImport(XCTest)
    XCTAssert(expression(), message(), file: file, line: line)
    #else
    assert(expression(), message(), file: file, line: line)
    #endif
}

// MARK: - Runtime Parameter+Literals.swift

import Foundation

// MARK: - ExpressibleByStringLiteral

extension Parameter:
    ExpressibleByStringLiteral,
    ExpressibleByExtendedGraphemeClusterLiteral,
    ExpressibleByUnicodeScalarLiteral
    where ValueType: ExpressibleByStringLiteral
{
    public typealias StringLiteralType = ValueType.StringLiteralType
    public typealias ExtendedGraphemeClusterLiteralType = ValueType.ExtendedGraphemeClusterLiteralType
    public typealias UnicodeScalarLiteralType = ValueType.UnicodeScalarLiteralType

    public init(stringLiteral value: StringLiteralType) {
        self = .value(ValueType.init(stringLiteral: value))
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self = .value(ValueType.init(extendedGraphemeClusterLiteral: value))
    }

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self = .value(ValueType.init(unicodeScalarLiteral: value))
    }
}

// MARK: - ExpressibleByNilLiteral

extension Parameter: ExpressibleByNilLiteral where ValueType: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .value(nil)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Parameter: ExpressibleByIntegerLiteral where ValueType: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = ValueType.IntegerLiteralType

    public init(integerLiteral value: ValueType.IntegerLiteralType) {
        self = .value(ValueType.init(integerLiteral: value))
    }
}

// MARK: - ExpressibleByBooleanLiteral

extension Parameter: ExpressibleByBooleanLiteral where ValueType: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = ValueType.BooleanLiteralType

    public init(booleanLiteral value: BooleanLiteralType) {
        self = .value(ValueType.init(booleanLiteral: value))
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Parameter: ExpressibleByFloatLiteral where ValueType: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = ValueType.FloatLiteralType

    public init(floatLiteral value: FloatLiteralType) {
        self = .value(ValueType.init(floatLiteral: value))
    }
}

// MARK: - ExpressibleByArrayLiteral

private extension ExpressibleByArrayLiteral {
    init(_ elements: [ArrayLiteralElement]) {
        let castedInit = unsafeBitCast(Self.init(arrayLiteral:), to: (([ArrayLiteralElement]) -> Self).self)
        self = castedInit(elements)  // TODO: Update once splatting is supported. https://bugs.swift.org/browse/SR-128
    }
}

private extension ExpressibleByArrayLiteral where ArrayLiteralElement: Hashable {
    init(_ elements: [ArrayLiteralElement]) {
        let castedInit = unsafeBitCast(Self.init(arrayLiteral:), to: (([ArrayLiteralElement]) -> Self).self)
        self = castedInit(elements)  // TODO: Update once splatting is supported. https://bugs.swift.org/browse/SR-128
    }
}

extension Parameter: ExpressibleByArrayLiteral where ValueType: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = ValueType.ArrayLiteralElement

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self = .value(ValueType.init(elements))
    }
}

// MARK: - ExpressibleByDictionaryLiteral

private extension ExpressibleByDictionaryLiteral where Key: Hashable {
    init(_ elements: [(Key, Value)]) {
        let value: [Key: Value] = Dictionary.init(uniqueKeysWithValues: elements)
        self = value as! Self  // TODO: Check if can be fixed. For some reason could not use init(arayLiteral elements: ...)
    }
}

extension Parameter: ExpressibleByDictionaryLiteral where ValueType: ExpressibleByDictionaryLiteral, ValueType.Key: Hashable {
    public typealias Key = ValueType.Key
    public typealias Value = ValueType.Value

    public init(dictionaryLiteral elements: (Key, Value)...) {
        self = .value(ValueType.init(elements))
    }
}

// MARK: - Runtime SwiftyMockyTestObserver.swift

import Foundation
#if canImport(XCTest)
import XCTest

/// Used for observing tests and handling internal library errors.
public class SwiftyMockyTestObserver: NSObject, XCTestObservation {
    /// [Internal] Current test case
    private static var currentTestCase: XCTestCase?
    /// [Internal] Setup observing once
    private static let setupBlock: (() -> Void) = {
        Matcher.fatalErrorHandler = SwiftyMockyTestObserver.handleFatalError
        let addObserver = { XCTestObservationCenter.shared.addTestObserver(SwiftyMockyTestObserver()) }
        if Thread.isMainThread {
            addObserver()
        } else {
            DispatchQueue.main.async {
                addObserver()
            }
        }
        return {}
    }()

    /// Call this method to setup custom error handling for SwiftyMocky, that allows to gracefully handle missing stub fatal errors.
    /// In general it should be done automatically and there should be no reason to call it directly.
    public static func setup() {
        setupBlock()
    }

    /// [Internal] Observer for test start
    ///
    /// - Parameter testCase: current test
    public func testCaseWillStart(_ testCase: XCTestCase) {
        SwiftyMockyTestObserver.currentTestCase = testCase
    }

    /// [Internal] Observer for test finished
    ///
    /// - Parameter testCase: current test
    public func testCaseDidFinish(_ testCase: XCTestCase) {
        SwiftyMockyTestObserver.currentTestCase = nil
    }

    /// [Internal] used to notify about internal error. Do not call it directly.
    ///
    /// - Parameters:
    ///   - message: Message
    ///   - file: File
    ///   - line: Line
    public static func handleFatalError(message: String, file: StaticString, line: UInt) {
        guard let testCase = SwiftyMockyTestObserver.currentTestCase else {
            return XCTFail(message, file: file, line: line)
        }

        let continueAfterFailure = testCase.continueAfterFailure
        defer { testCase.continueAfterFailure = continueAfterFailure }
        testCase.continueAfterFailure = false
        let methodName = getNameOfExtecutedTestCase(testCase)
        if let name = methodName, let failingLine = FilesExlorer().findTestCaseLine(for: name, file: file) {
            testCase.record(XCTIssue(
                type: .system,
                compactDescription: message,
                detailedDescription: nil,
                sourceCodeContext: .init(location: .init(filePath: file.description, lineNumber: Int(failingLine))),
                associatedError: nil,
                attachments: []
            ))
        } else if let name = methodName {
            XCTFail("\(name) - \(message)", file: file, line: line)
        } else {
            XCTFail(message, file: file, line: line)
        }
    }

    /// [Internal] Geting name of current test
    ///
    /// - Parameter testCase: Test case
    /// - Returns: Name
    private static func getNameOfExtecutedTestCase(_ testCase: XCTestCase) -> String? {
        return testCase.name.components(separatedBy: " ")[1].components(separatedBy: "]").first
    }
}

/// [Internal] Internal dependency that looks for line of test case, that caused test failure.
private class FilesExlorer {
    /// Parses test case file to get line number assigned with test
    ///
    /// - Parameter testCase: Test case
    /// - Parameter file: File we should look in
    /// - Returns: Line number or nil, if unable to find
    func findTestCaseLine(for methodName: String, file: StaticString) -> UInt? {
        guard let content = getFileContent(file: file.description) else {
            return nil
        }
        let lines = content.components(separatedBy: "\n")
        let offset = lines.enumerated().first { (index, line) -> Bool in
            return line.contains(methodName)
        }?.offset
        guard let line = offset else { return nil }
        let lineAdditionalOffset: UInt = 2 // just to show error within test case, below the name.
        return UInt(line) + lineAdditionalOffset
    }

    private func getFileContent(file: String) -> String? {
        // TODO: look for file encoding from file attributes
        guard let fileData = FileManager().contents(atPath: file) else { return nil }
        return String(data: fileData, encoding: .utf8) ?? String(data: fileData, encoding: .utf16)
    }
}

#else

public class SwiftyMockyTestObserver: NSObject {
    /// [Internal] No setup whatsoever
    @objc public static func setup() {
        // Empty on purpose
    }

    public static func handleFatalError(message: String, file: StaticString, line: UInt) {
        // Empty on purpose
    }
}
#endif

// MARK: - Generated Mocks

// Generated using Sourcery 2.3.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import XCTest
import Foundation
import UIKit
@testable import TestingTask


// MARK: - ArticleRouterInputMockable

open class ArticleRouterInputMockableMock: ArticleRouterInputMockable, Mock {
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

// MARK: - ArticleViewInputMockable

open class ArticleViewInputMockableMock: ArticleViewInputMockable, Mock {
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

// MARK: - AuthServiceProtocolMockable

open class AuthServiceProtocolMockableMock: AuthServiceProtocolMockable, Mock {
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

// MARK: - FavoriteRouterInputMockable

open class FavoriteRouterInputMockableMock: FavoriteRouterInputMockable, Mock {
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

// MARK: - FavoriteViewInputMockable

open class FavoriteViewInputMockableMock: FavoriteViewInputMockable, Mock {
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

// MARK: - LoginScreenRouterInputMockable

open class LoginScreenRouterInputMockableMock: LoginScreenRouterInputMockable, Mock {
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

// MARK: - LoginScreenViewInputMockable

open class LoginScreenViewInputMockableMock: LoginScreenViewInputMockable, Mock {
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

// MARK: - NewsRouterInputMockable

open class NewsRouterInputMockableMock: NewsRouterInputMockable, Mock {
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

// MARK: - NewsViewInputMockable

open class NewsViewInputMockableMock: NewsViewInputMockable, Mock {
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

// MARK: - SignUpScreenRouterInputMockable

open class SignUpScreenRouterInputMockableMock: SignUpScreenRouterInputMockable, Mock {
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

// MARK: - SignUpScreenViewInputMockable

open class SignUpScreenViewInputMockableMock: SignUpScreenViewInputMockable, Mock {
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

