//
//  Validator.swift
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

/// Password validator
public struct Validator {

    /// Rule type
    public typealias Rule = RuleType

    /// Result type
    public enum Result: Equatable {

        case OK
        case Failure([Rule])

    }

    /// rules
    private let rules: [Rule]

    /**

    Initializes with default rule.
    The default rule is `LengthRule` with the minimum length: 8, the maximum length: 128.

    */
    public init() {

        self.init(rules: [LengthRule(minimum: 8, maximum: 128)])

    }

    /**

    Initializes with rules.

    - parameter rules: rules array

    */
    public init(rules: [Rule]) {

        self.rules = rules

    }

    /**

    Validates password string.

    - parameter password: password string

    - returns: Validation result. If the validation failed, `Failure([rule])` has the failing rules.

    */
    public func validate(password: String) -> Validator.Result {

        let failingRules = rules.filter { !$0.evaluate(password) }

        if failingRules.count == 0 {

            return .OK

        } else {

            return .Failure(failingRules)

        }
    }

}

public func ==(lhs: Validator.Result, rhs: Validator.Result) -> Bool {

    switch (lhs, rhs) {

    case (.OK, .OK):
        return true

    case (.Failure(let lrs), .Failure(let rrs)):
        return lrs.description == rrs.description

    default:
        return false

    }

}
