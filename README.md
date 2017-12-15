# Ainu
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![MIT License](https://img.shields.io/github/license/moriturus/Ainu.svg)

**Password Validator & Strength Evaluator** *influenced by [Navajo](https://github.com/mattt/Navajo)*.  
Ainu is completely written in Swift 4.

> Ainu is named in honour of the famed non-Japonic Languages speakers in the north of Japan.

## Requirement

- OSX 10.10+
- iOS 9.0+
- watchOS 3.0+
- tvOS 9.0+

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

```
github "moriturus/Ainu" ~> 4.0
```

## Usage

### Validating Password

```swift
let password = "abc123"

// default validator's rule is `LengthRule(minimum: 8, maximum: 128)`
let validator = Validator()

let result = validator.validate(password)

switch result {

case .OK:
    // do something with the validated password
    break

case .Failure(let failingRules):
    failingRules.forEach { rule in
        NSLog(rule.localizedErrorDescription)
    }

}
```

#### Available Validation Rules

- Allowed Characters
- Required Characters (e.g. lowercase, uppercase, decimal, symbol)
- Non-Dictionary Word (OSX/iOS only)
- Minimum / Maximum Length
- Predicate Match
- Regular Expression Match
- Function Evaluation

### Evaluating Password Strength

> Password strength is evaluated in terms of [information entropy](http://en.wikipedia.org/wiki/Entropy_%28information_theory%29).

```swift
let password = "password"
let strength = Strength(password: password)

NSLog(strength.description) // prints "Very Weak"
```

## Contact

[Henrique Sasaki Yuya](https://github.com/moriturus)
[@moriturus](https://twitter.com/moriturus)

## License

Ainu is available under the MIT license. See the LICENSE file for more info.
