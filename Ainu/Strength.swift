//
//  Strength.swift
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
import CoreGraphics

/// Strength of password
public enum Strength: CustomStringConvertible, Comparable {

    /// The password is empty.
    case Empty
    /// The password is very weak.
    case VeryWeak
    /// The password is weak.
    case Weak
    /// The password is not bad.
    case Reasonable
    /// The password is strong.
    case Strong
    /// The password is very strong.
    case VeryStrong

    private var intValue: Int {

        switch self {

        case .Empty:
            return -1

        case .VeryWeak:
            return 0

        case .Weak:
            return 1

        case .Reasonable:
            return 2

        case .Strong:
            return 3

        case .VeryStrong:
            return 4

        }

    }

    public var description: String {

        switch self {

        case .Empty:
            return NSLocalizedString("Empty", tableName: "Ainu", comment: "Empty")

        case .VeryWeak:
            return NSLocalizedString("Very Weak Password", tableName: "Ainu", comment: "very weak password")

        case .Weak:
            return NSLocalizedString("Weak Password", tableName: "Ainu", comment: "weak password")

        case .Reasonable:
            return NSLocalizedString("Reasonable Password", tableName: "Ainu", comment: "reasonable password")

        case .Strong:
            return NSLocalizedString("Strong Password", tableName: "Ainu", comment: "strong password")

        case .VeryStrong:
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

        case -(CGFloat.max) ..< 0.0:
            self = .Empty

        case 0.0 ..< 28.0:
            self = .VeryWeak

        case 28.0 ..< 36.0:
            self = .Weak

        case 36.0 ..< 60.0:
            self = .Reasonable

        case 60.0 ..< 128.0:
            self = .Strong

        default:
            self = .VeryStrong

        }

    }

    /**

    Computes entopy value for the given string.

    - parameter string: string to be computed entropy

    - returns: entropy

    */
    private static func entropy(string: String) -> CGFloat {

        guard string.characters.count != 0 else {

            return -CGFloat.max

        }

        var includesLowercaseCharacter = false
        var includesUppercaseCharacter = false
        var includesDecimalDigitCharacter = false
        var includesPunctuationCharacter = false
        var includesSymbolCharacter = false
        var includesWhitespaceCharacter  = false
        var includesNonBaseCharacter  = false

        var sizeOfCharacters: UInt = 0

        string.utf16.forEach { c in

            if !includesLowercaseCharacter && NSCharacterSet.lowercaseLetterCharacterSet().characterIsMember(UInt16(c.value)) {

                includesLowercaseCharacter = true
                sizeOfCharacters += 26

            }

            if !includesUppercaseCharacter && NSCharacterSet.uppercaseLetterCharacterSet().characterIsMember(UInt16(c.value)) {

                includesUppercaseCharacter = true
                sizeOfCharacters += 26

            }

            if !includesDecimalDigitCharacter && NSCharacterSet.decimalDigitCharacterSet().characterIsMember(UInt16(c.value)) {

                includesDecimalDigitCharacter = true
                sizeOfCharacters += 10

            }

            if !includesPunctuationCharacter && NSCharacterSet.punctuationCharacterSet().characterIsMember(UInt16(c.value)) {

                includesPunctuationCharacter = true
                sizeOfCharacters += 20

            }

            if !includesSymbolCharacter && NSCharacterSet.symbolCharacterSet().characterIsMember(UInt16(c.value)) {

                includesSymbolCharacter = true
                sizeOfCharacters += 10

            }

            if !includesWhitespaceCharacter && NSCharacterSet.whitespaceCharacterSet().characterIsMember(UInt16(c.value)) {

                includesWhitespaceCharacter = true
                sizeOfCharacters += 1

            }

            if !includesNonBaseCharacter && NSCharacterSet.nonBaseCharacterSet().characterIsMember(UInt16(c.value)) {

                includesNonBaseCharacter = true
                sizeOfCharacters += 32 + 128

            }

        }

        let entropyPerCharacter = log2(CGFloat(sizeOfCharacters))

        return entropyPerCharacter * CGFloat(string.utf16.count)

    }

}

public func <(lhs: Strength, rhs: Strength) -> Bool {

    return lhs.intValue < rhs.intValue

}
