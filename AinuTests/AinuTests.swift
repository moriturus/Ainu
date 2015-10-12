//
//  AinuTests.swift
//  AinuTests
//
//  Created by Henrique Sasaki Yuya on 10/12/15.
//  Copyright © 2015 Henrique Sasaki Yuya. All rights reserved.
//

import XCTest
@testable import Ainu

class AinuTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Strength
    
    func testEmptyPassword() {
        
        let password = ""
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength == .Empty, "password strength was not Empty: actually \(strength)")
        
    }
    
    func testVeryWeakPassword() {
        
        let password = " "
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength == .VeryWeak, "password strength was not Very Weak: actually \(strength)")
        
    }
    
    func testWeakPassword() {
        
        let password = "012345678"
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength == .Weak, "password strength was not Weak: actually \(strength)")
        
    }
    
    func testReasonablePassword() {
        
        let password = "0123456."
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength == .Reasonable, "password strength was not Reasonable: actually \(strength)")
        
    }
    
    func testStrongPassword() {
        
        let password = "012345678aB.+"
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength == .Strong, "password strength was not Strong: actually \(strength)")
        
    }
    
    func testVeryStrongPassword() {
        
        let password = "012345678aB.+ 日本語"
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength == .Strong, "password strength was not Very Strong: actually \(strength)")
        
    }
    
    func testReasonableAndAbove() {
        
        let password = "012345678aB.+ 日本語"
        let strength = Strength(password: password)
        
        XCTAssertTrue(strength >= .Reasonable, "password strength was not Reasonable and above: actually \(strength)")
        
    }
    
    // MARK: Validator
    
    func testDefaultRuleValidatorSuccess() {
        
        let validator = Validator()
        let password = "01234567"
        let result = validator.validate(password)
        
        XCTAssertTrue(result == .OK, "password was not validated.")
        
    }
    
    func testDefaultRuleValidatorFailure() {
        
        let validator = Validator()
        let password = "0123456"
        let result = validator.validate(password)
        
        XCTAssertTrue(result != .OK, "password was validated.")
        
    }
    
    func testCustomRuleValidator() {
        
        let rule = FunctionalRule {
            return $0.characters.count == 10
        }
        let validator = Validator(rules: [rule])
        let password = "0123456789"
        let result = validator.validate(password)
        
        XCTAssertTrue(result == .OK, "password was not validated.")
        
    }
    
    // MARK: Rule
    
    func testAllowedCharacterRuleSuccess() {
        
        let allowedCharacters = NSCharacterSet(charactersInString: "password")
        let password = "sdwpsroa"
        
        let rule = AllowedCharacterRule(allowedCharacters: allowedCharacters)
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password included not allowed characters.")
        
    }
    
    func testAllowedCharacterRuleFailure() {
        
        let allowedCharacters = NSCharacterSet(charactersInString: "password")
        let password = "hello world"
        
        let rule = AllowedCharacterRule(allowedCharacters: allowedCharacters)
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password was constructed from allowed characters.")
        
    }
    
    func testLowercaseCharacterRuleSuccess() {
        
        let password = "pASSWORD"
        
        let rule = RequiredCharacterRule.lowercaseCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password had no lowercase characters.")
        
    }
    
    func testLowercaseCharacterRuleFailure() {
        
        let password = "PASSWORD"
        
        let rule = RequiredCharacterRule.lowercaseCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password had lowercase characters.")
        
    }
    
    func testUppercaseCharacterRuleSuccess() {
        
        let password = "Password"
        
        let rule = RequiredCharacterRule.uppercaseCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password had no uppercase characters.")
        
    }
    
    func testUpperaseCharacterRuleFailure() {
        
        let password = "password"
        
        let rule = RequiredCharacterRule.uppercaseCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password had uppercase characters.")
        
    }
    
    func testDecimalDigitCharacterRuleSuccess() {
        
        let password = "0password"
        
        let rule = RequiredCharacterRule.decimalDigitCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password had no decimal digit characters.")
        
    }
    
    func testDecimalDigitCharacterRuleFailure() {
        
        let password = "password"
        
        let rule = RequiredCharacterRule.decimalDigitCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password had decimal digit characters.")
        
    }
    
    func testSymbolCharacterRuleSuccess() {
        
        let password = "+password"
        
        let rule = RequiredCharacterRule.symbolCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password had no symbol characters.")
        
    }
    
    func testSymbolCharacterRuleFailure() {
        
        let password = "password"
        
        let rule = RequiredCharacterRule.symbolCharacterRequiredRule()
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password had symbol characters.")
        
    }
    
#if os(OSX)
    // on iOS Simulator, UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm() always returns false.
    
    func testDictionaryWordRuleSuccess() {
        
        let password = "beiruq[ewralsdb"
        
        let rule = NonDictionaryWordRule()
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password was not non-dictionary word.")
        
    }
    
    func testDictionaryWordRuleFailure() {
        
        let password = "password"
        
        let rule = NonDictionaryWordRule()
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password was non-dictionary word.")
        
    }
    
#endif
    
    func testLengthRuleSuccess() {
        
        let password = "01234567"
        
        let rule = LengthRule(minimum: 8, maximum: 32)
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password did not reach 8 characters.")
        
    }
    
    func testLengthRuleFailure() {
        
        let password = "0123456"
        
        let rule = LengthRule(minimum: 8, maximum: 32)
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password reached 8 characters.")
        
    }
    
    func testPredicateRuleSuccess() {
        
        let password = "password"
        let predicate = NSPredicate(value: true)
        
        let rule = PredicateRule(predicate: predicate)
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password was not evaluated true by predicate.")
        
    }
    
    func testPredicateRuleFailure() {
        
        let password = "0123456"
        let predicate = NSPredicate(value: false)
        
        let rule = PredicateRule(predicate: predicate)
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password was evaluated true by predicate.")
        
    }
    
    func testRegularExpressionRuleSuccess() {
        
        let password = "password0"
        let regex = try! NSRegularExpression(pattern: "^password[0-9]$", options: NSRegularExpressionOptions())
        
        let rule = RegularExpressionRule(regularExpression: regex)
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password did not match the given regular expression.")
        
    }
    
    func testRegularExpressionRuleFailure() {
        
        let password = "password"
        let regex = try! NSRegularExpression(pattern: "^[0-9]$", options: NSRegularExpressionOptions())
        
        let rule = RegularExpressionRule(regularExpression: regex)
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password matched the given regular expression.")
        
    }
    
    func match(s: String) -> Bool {
        return s == "password"
    }
    
    func testFunctionalRuleSuccess() {
        
        let password = "password"
        
        let rule = FunctionalRule(function: match)
        let result = rule.evaluate(password)
        
        XCTAssertTrue(result, "password did not match the given function.")
        
    }
    
    func testFunctionalRuleFailure() {
        
        let password = "password0"
        
        let rule = FunctionalRule(function: match)
        let result = rule.evaluate(password)
        
        XCTAssertFalse(result, "password matched the given function.")
        
    }
    
    

}
