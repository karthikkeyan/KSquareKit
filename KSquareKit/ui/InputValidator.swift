//
//  InputValidator.swift
//  KSquare
//
//  Created by Karthikkeyan on 12/1/15.
//  Copyright © 2016 Karthikkeyan. All rights reserved.
//

import UIKit

// MARK: - InputValidating Protocol

public protocol InputValidating {
    
    func fullText(existingText: String?, appendText: String, replacementRange range: NSRange) -> String
    
    func shouldChange(text: String?) -> Bool
    
    func isValid(text: String?) -> Bool
    
    func clearFormat(text: String) -> String
    
    func format(string text: String?) -> String?
    
}

public extension InputValidating {
    
    func fullText(existingText: String?, appendText: String, replacementRange range: NSRange) -> String {
        guard let unwrappedText = existingText else {
            return ""
        }
        
        return unwrappedText.replacingCharacters(in: range.toRange(string: unwrappedText), with: appendText)
    }
    
    func shouldChange(text: String?) -> Bool {
        return true
    }
    
    func isValid(text: String?) -> Bool {
        return true
    }
    
    func clearFormat(text: String) -> String {
        return text
    }
    
    func format(string text: String?) -> String? {
        return text
    }
    
}


// MARK: - EmailValidator

open class EmailValidator: InputValidating {
    
    public init() {}
    
    public func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        let regex = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
}


// MARK: - NumberValidator

open class NumberValidator: InputValidating {
    
    public var limit: Int = 4
    
    public convenience init(withLimit limit: Int) {
        self.init()
        
        self.limit = limit
    }
    
    open func shouldChange(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return true
        }
        
        var regex = "[0-9]{0,10}"
        if limit > 0 {
            regex = "[0-9]{0,\(limit)}"
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    open func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        var regex = "[0-9]"
        if limit > 0 {
            regex = "[0-9]{\(limit)}"
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    open func clearFormat(text: String) -> String {
        return text
    }
    
    open func format(string text: String?) -> String? {
        return text
    }
    
}


// MARK: - DecimalNumberValidator

open class DecimalNumberValidator: InputValidating {
    
    public var limit = 6
    
    open func shouldChange(string text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return true
        }
        
        var regex = "([0-9]{0,\(limit)})(([.]{0,1})([0-9]{0,2}))"
        
        if text.characters.count > 0, let component = text.components(separatedBy: ".").first, component.characters.count > limit {
            regex = "([0-9]{\(limit)})(([.]{1})([0-9]{0,2}))"
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    open func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        let regex = "([0-9]{1,\(limit)})(([.]{0,1})([0-9]{0,2}))"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
}


// (XXX)-XXX-XXXX
// MARK: - PhoneNumberValidator

open class PhoneNumberValidator: NumberValidator {
    
    public var divider = "-"
    
    override public init() {
        super.init()
        
        self.limit = 10
    }
    
    override open func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        let regex = "[0-9]{\(self.limit)}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    override open func clearFormat(text: String) -> String {
        var clearString = text
        
        clearString = clearString.replacingOccurrences(of: divider, with: "")
        clearString = clearString.replacingOccurrences(of: "(", with: "")
        clearString = clearString.replacingOccurrences(of: ")", with: "")
        
        return clearString
    }
    
    override open func format(string text: String?) -> String? {
        guard let text = text, text.characters.count > 0 else {
            return nil
        }
        
        var formattedString = clearFormat(text: text)
        if (formattedString.characters.count > 3) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 3))
        }
        
        if (formattedString.characters.count > 7) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 7))
        }
        
        if (formattedString.characters.count > 12) {
            formattedString.insert(contentsOf: "(".characters, at: formattedString.index(formattedString.startIndex, offsetBy: 0))
            formattedString.insert(contentsOf: ")".characters, at: formattedString.index(formattedString.startIndex, offsetBy: 4))
        }
        
        return formattedString
    }
    
}

// XXX-XX-XXXX
// MARK: - SocialSecurityNumberValidator

open class SocialSecurityNumberValidator: NumberValidator {
    
    public var divider = "-"
    
    override public init() {
        super.init()
        
        self.limit = 9
    }
    
    override open func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        let regex = "[0-9]{\(self.limit)}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    override open func clearFormat(text: String) -> String {
        return text.replacingOccurrences(of: divider, with: "")
    }
    
    override open func format(string text: String?) -> String? {
        guard let text = text, text.characters.count > 0 else {
            return nil
        }
        
        var formattedString = clearFormat(text: text)
        if (formattedString.characters.count > 3) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 3))
        }
        
        if (formattedString.characters.count > 6) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 6))
        }
        
        return formattedString
    }
    
}


// MARK: - CreditCardNumberValidator

open class CreditCardNumberValidator: NumberValidator {
    
    public var divider = " "
    
    override public init() {
        super.init()
        
        self.limit = 16
    }
    
    override open func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        let regex = "[0-9]{\(self.limit)}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    override open func clearFormat(text: String) -> String {
        return text.replacingOccurrences(of: divider, with: "")
    }
    
    override open func format(string text: String?) -> String? {
        guard let text = text, text.characters.count > 0 else {
            return nil
        }
        
        var formattedString = clearFormat(text: text)
        if (formattedString.characters.count > 4) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 4))
        }
        
        if (formattedString.characters.count > 9) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 9))
        }
        
        if (formattedString.characters.count > 14) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 14))
        }
        
        return formattedString
    }
    
}


// MARK: - DateValidator

open class DateValidator: NumberValidator {
    
    public var divider = "/"
    
    override public init() {
        super.init()
        
        self.limit = 6
    }
    
    override open func isValid(text: String?) -> Bool {
        guard let text = text, text.characters.count > 0 else {
            return false
        }
        
        let regex = "[0-9]{\(self.limit)}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: clearFormat(text: text))
    }
    
    override open func clearFormat(text: String) -> String {
        return text.replacingOccurrences(of: divider, with: "")
    }
    
    override open func format(string text: String?) -> String? {
        guard let text = text, text.characters.count > 0 else {
            return nil
        }
        
        var formattedString = clearFormat(text: text)
        if (formattedString.characters.count > 2) {
            formattedString.insert(contentsOf: divider.characters, at: formattedString.index(formattedString.startIndex, offsetBy: 2))
        }
        
        return formattedString
    }
    
}

