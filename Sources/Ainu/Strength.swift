//
//  Strength.swift
//  Ainu
//
//  Copyright (c) 2017 Henrique Sasaki Yuya (moriturus@alimensir.com)
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
import CoreGraphics

/// Strength of password
public enum Strength: CustomStringConvertible, Comparable {

    /// The password is empty.
    case empty
    /// The password is very weak.
    case veryWeak
    /// The password is weak.
    case weak
    /// The password is not bad.
    case reasonable
    /// The password is strong.
    case strong
    /// The password is very strong.
    case veryStrong

    fileprivate var intValue: Int {

        switch self {

        case .empty:
            return -1

        case .veryWeak:
            return 0

        case .weak:
            return 1

        case .reasonable:
            return 2

        case .strong:
            return 3

        case .veryStrong:
            return 4

        }

    }

    public var description: String {

        switch self {

        case .empty:
            return NSLocalizedString("Empty", tableName: "Ainu", comment: "Empty")

        case .veryWeak:
            return NSLocalizedString("Very Weak Password", tableName: "Ainu", comment: "very weak password")

        case .weak:
            return NSLocalizedString("Weak Password", tableName: "Ainu", comment: "weak password")

        case .reasonable:
            return NSLocalizedString("Reasonable Password", tableName: "Ainu", comment: "reasonable password")

        case .strong:
            return NSLocalizedString("Strong Password", tableName: "Ainu", comment: "strong password")

        case .veryStrong:
            return NSLocalizedString("Very Strong Password", tableName: "Ainu", comment: "very strong password")

        }

    }

    /**

    Initializes with password string.

    - parameter password: password string

    */
    public init(password: String) {

        self.init(entropy: Strength.entropy(password))

    }

    /**

    Initializes with password's entropy value.

    - parameter entropy: password's entropy value

    */
    private init(entropy: CGFloat) {

        switch entropy {

        case -(CGFloat.greatestFiniteMagnitude) ..< 0.0:
            self = .empty

        case 0.0 ..< 28.0:
            self = .veryWeak

        case 28.0 ..< 36.0:
            self = .weak

        case 36.0 ..< 60.0:
            self = .reasonable

        case 60.0 ..< 128.0:
            self = .strong

        default:
            self = .veryStrong

        }

    }

    /**

    Computes entopy value for the given string.

    - parameter string: string to be computed entropy

    - returns: entropy

    */
    private static func entropy(_ string: String) -> CGFloat {

        guard !string.isEmpty else {

            return -CGFloat.greatestFiniteMagnitude

        }

        var includesLowercaseCharacter = false
        var includesUppercaseCharacter = false
        var includesDecimalDigitCharacter = false
        var includesPunctuationCharacter = false
        var includesSymbolCharacter = false
        var includesWhitespaceCharacter  = false
        var includesNonBaseCharacter  = false

        let base: UInt = string.unicodeScalars.reduce(0) { (accm, c) in
            var accm = accm
            if !includesLowercaseCharacter && CharacterSet.lowercaseLetters.contains(c) {
                includesLowercaseCharacter = true
                accm += 26
            }
            
            if !includesUppercaseCharacter && CharacterSet.uppercaseLetters.contains(c) {
                includesUppercaseCharacter = true
                accm += 2
            }
            
            if !includesDecimalDigitCharacter && CharacterSet.decimalDigits.contains(c) {
                includesDecimalDigitCharacter = true
                accm += 10
            }
            
            if !includesPunctuationCharacter && CharacterSet.punctuationCharacters.contains(c) {
                includesPunctuationCharacter = true
                accm += 20
            }
            
            if !includesSymbolCharacter && CharacterSet.symbols.contains(c) {
                includesSymbolCharacter = true
                accm += 10
            }
            
            if !includesWhitespaceCharacter && CharacterSet.whitespaces.contains(c) {
                includesWhitespaceCharacter = true
                accm += 1
            }
            
            if !includesNonBaseCharacter && CharacterSet.nonBaseCharacters.contains(c) {
                includesNonBaseCharacter = true
                accm += 32 + 128
            }
            
            return accm
        }
        
        let entropyPerCharacter = log2(CGFloat(base))
        return entropyPerCharacter * CGFloat(string.unicodeScalars.count)
    }

}

public func <(lhs: Strength, rhs: Strength) -> Bool {
    return lhs.intValue < rhs.intValue
}
