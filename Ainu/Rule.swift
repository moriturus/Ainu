//
//  Rule.swift
//  Ainu
//
//  Copyright (c) 2015 Henrique Sasaki Yuya (http://alimensir.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

#if os(OSX)
    import CoreServices
#elseif os(iOS)
    import UIKit
#endif

/// Rule type
public protocol RuleType {

    /// localized error description
    var localizedErrorDescription: String { get }

    /**

    Evaluates the given string.

    - parameter string: String to be evaluated.

    - returns: If it confirms to the condition, `true`, otherwise `false`.

    */
    func evaluate(string: String) -> Bool

}

/// Rule of allowed characters.
public struct AllowedCharacterRule: RuleType {

    private let disallowedCharacters: NSCharacterSet

    public var localizedErrorDescription: String {
        return NSLocalizedString("Must not include disallowed character", tableName: "Ainu", comment: "disallowed")
    }

    /**

    Initializes with allowed characters set.

    - parameter allowedCharacters: Characters set you allowed.

    */
    public init(allowedCharacters: NSCharacterSet) {

        self.disallowedCharacters = allowedCharacters.invertedSet

    }

    public func evaluate(string: String) -> Bool {

        return string.rangeOfCharacterFromSet(disallowedCharacters) == .None

    }

}

/// Rule of required characters.
public struct RequiredCharacterRule: RuleType {

    private let requiredCharacters: NSCharacterSet
    public private(set) var localizedErrorDescription: String

    /**

    Initializes with required characters set and error description string.

    - parameter requiredCharacters: Characters set you specified to be required.
    - parameter errorDescription: Error description.

    */
    public init(requiredCharacters: NSCharacterSet, errorDescription: String) {

        self.requiredCharacters = requiredCharacters
        self.localizedErrorDescription = errorDescription

    }

    /**

    Initializes with required characters set.

    - parameter requiredCharacters: Characters set you specified to be required.

    */
    public init(requiredCharacters: NSCharacterSet) {

        self.init(
            requiredCharacters: requiredCharacters,
            errorDescription: NSLocalizedString("Must include required characters", tableName: "Ainu", comment: "general")
        )

    }

    /**

    Creates the rule required lowercase character.

    - returns: the rule required lowercase character

    */
    public static func lowercaseCharacterRequiredRule() -> RequiredCharacterRule {

        return RequiredCharacterRule(
            requiredCharacters: NSCharacterSet.lowercaseLetterCharacterSet(),
            errorDescription: NSLocalizedString("Must include lowercase character", tableName: "Ainu", comment: "lowercase")
        )

    }

    /**

    Creates the rule required uppercase character.

    - returns: the rule required uppercase character

    */
    public static func uppercaseCharacterRequiredRule() -> RequiredCharacterRule {

        return RequiredCharacterRule(
            requiredCharacters: NSCharacterSet.uppercaseLetterCharacterSet(),
            errorDescription: NSLocalizedString("Must include upper character", tableName: "Ainu", comment: "uppercase")
        )

    }

    /**

    Creates the rule required decimal digit character.

    - returns: the rule required decimal digit character

    */
    public static func decimalDigitCharacterRequiredRule() -> RequiredCharacterRule {

        return RequiredCharacterRule(
            requiredCharacters: NSCharacterSet.decimalDigitCharacterSet(),
            errorDescription: NSLocalizedString("Must include decimal digit character", tableName: "Ainu", comment: "digit")
        )

    }

    /**

    Creates the rule required symbol or punctuation character.

    - returns: the rule required symbol or punctuation character

    */
    public static func symbolCharacterRequiredRule() -> RequiredCharacterRule {

        let characterSet = NSMutableCharacterSet()
        characterSet.formUnionWithCharacterSet(NSCharacterSet.symbolCharacterSet())
        characterSet.formUnionWithCharacterSet(NSCharacterSet.punctuationCharacterSet())

        return RequiredCharacterRule(
            requiredCharacters: characterSet,
            errorDescription: NSLocalizedString("Must include symbol character", tableName: "Ainu", comment: "symbol")
        )

    }

    public func evaluate(string: String) -> Bool {

        return string.rangeOfCharacterFromSet(requiredCharacters) != .None

    }

}

private let nonLowercaseCharacters = NSCharacterSet.lowercaseLetterCharacterSet().invertedSet

#if os(OSX) || os(iOS) // tvOS does not have UIReferenceLibraryViewController class.

/// Rule of non-dictionary word
public struct NonDictionaryWordRule: RuleType {

    public var localizedErrorDescription: String {
        return NSLocalizedString("Must not be dictionary word", tableName: "Ainu", comment: "dictionary word")
    }

    public init() {
        // do nothing
    }

    public func evaluate(string: String) -> Bool {

        let term = string.lowercaseString.stringByTrimmingCharactersInSet(nonLowercaseCharacters)

        #if os(OSX)

            let range = DCSGetTermRangeInString(nil, term, 0)

            return range.location == kCFNotFound

        #elseif os(iOS)

            return !UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(term)

        #endif

    }

}
    
#endif

/// Rule of password length
public struct LengthRule: RuleType {

    /// Length information
    public struct Length {

        /// minimum length
        public let minimum: UInt
        /// maximum length
        public let maximum: UInt

        /// convert to `Range<Int>` structure
        private var range: Range<UInt> {

            return minimum ..< maximum

        }

    }

    public var localizedErrorDescription: String {
        return String(format: NSLocalizedString("Must be within range %@", tableName: "Ainu", comment: "length"), "\(length)")
    }

    private let length: Length

    /**

    Initializes with password length information.

    - parameter length: password length

    */
    public init(length: Length) {

        self.length = length

    }

    /**

    Initializes with the minimum and maximum password length.

    - parameter minimum: minimum password length
    - parameter maximum: maximum password length

    */
    public init(minimum: UInt, maximum: UInt) {

        self.init(length: Length(minimum: minimum, maximum: maximum))

    }

    public func evaluate(string: String) -> Bool {

        return length.range.contains(UInt(string.characters.count))

    }

}

/// Rule with `NSPredicate`
public struct PredicateRule: RuleType {

    public let localizedErrorDescription = NSLocalizedString("Must match predicate", tableName: "Ainu", comment: "predicate")
    private let predicate: NSPredicate

    /**

    Initializes with `NSPredicate`.

    - parameter predicate: The predicate to be evaluated

    */
    public init(predicate: NSPredicate) {

        self.predicate = predicate

    }

    public func evaluate(string: String) -> Bool {

        return predicate.evaluateWithObject(string)

    }

}

/// Rule with `NSRegularExpression`
public struct RegularExpressionRule: RuleType {

    public var localizedErrorDescription: String {
        return String(format: NSLocalizedString("Must match regular expression: %@", tableName: "Ainu", comment: "regex"), regex)
    }

    private let regex: NSRegularExpression

    /**

    Initializes with `NSRegularExpression`.

    - parameter regularExpression: The regular expression to be evaluated.

    */
    public init(regularExpression: NSRegularExpression) {

        self.regex = regularExpression

    }

    public func evaluate(string: String) -> Bool {

        return regex.numberOfMatchesInString(string, options: NSMatchingOptions(), range: NSRange(location: 0, length: string.characters.count)) > 0

    }

}

/// Rule with specified function.
public struct FunctionalRule: RuleType {

    public let localizedErrorDescription = NSLocalizedString("Must match regular expression", tableName: "Ainu", comment: "regex")
    private let function: String -> Bool

    /**

    Initializes with specified function.

    - parameter function: The function to be evaluated.

    */
    public init(function: String -> Bool) {

        self.function = function

    }

    public func evaluate(string: String) -> Bool {

        return function(string)

    }

}
