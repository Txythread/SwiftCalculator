//
//  Number.swift
//  Calculator
//
//  Created by Michael Rudolf on 16.12.25.
//

/// A number in any base allowing any size (within memory bounds or base^2^64)
struct Number {
    var base: UInt8 = 10
    var numerals: [UInt8]
    var commaPosition: UInt8? = nil
    
    init(base: UInt8, numerals: [UInt8]) {
        self.base = base
        self.numerals = numerals
    }
    
    /// Creates a text which can be displayed on screen
    func getDisplayText() -> String {
        // For now, texts can only be created when the base is decimal or lower
        assert(base <= 10)
        
        var text = ""
        numerals.forEach { numeral in
            text += String(numeral)
        }
        
        if let commaPosition = commaPosition {
            // Insert the comma at the correct position
            text.insert(Character(Language.getLanguage().comma), at: text.index(text.startIndex, offsetBy: Int(commaPosition)))
            
            // If the position is zero, append a leading zero for formatting
            if commaPosition == 0 {
                text.insert(Character("0"), at: text.startIndex)
            }
        }
        
        return text
    }
    
    func countPositionsAfterDecimal() -> Int {
        let commaPosition = commaPosition ?? UInt8(numerals.count)
        return numerals.count - Int(commaPosition)
    }
    
    func countPositionsBeforeDecimal() -> Int {
        let commaPosition = commaPosition ?? UInt8(numerals.count)
        return Int(commaPosition)
    }
    
    func getNumeralDecimalRelative(_ pindex: Int) -> UInt8 {
        let indexz = -Int(commaPosition ?? UInt8(numerals.count)) + pindex + numerals.count
        let index = numerals.count - indexz
        
        print("getting numeral at position \(index) (comma at: \(commaPosition), index: \(pindex), #numerals: \(numerals.count)")
        
        if index < 0 || index >= numerals.count {
            return 0
        }
        
        return numerals[index]
    }
    
    /// Appends a numeral when provided, a comma otherwise
    mutating func appendNumeral(new numeral: UInt8?) {
        if let numeral = numeral {
            numerals.append(numeral)
        } else {
            commaPosition = UInt8(numerals.count)
        }
    }
}


extension Number: Numberable, Equatable {
    func calculate() -> Number {
        return self
    }
}
