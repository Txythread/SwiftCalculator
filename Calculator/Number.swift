//
//  Number.swift
//  Calculator
//
//  Created by Michael Rudolf on 16.12.25.
//

import Darwin

/// A number in any base allowing any size (within memory bounds or base^2^64)
struct Number {
    var base: UInt8 = 10
    var numerals: [UInt8]
    var commaPosition: UInt8? = nil
    var isNegative: Bool = false
    
    
    /// Creates a text which can be displayed on screen
    func getDisplayText() -> String {
        var clonedSelf = self
        clonedSelf.cleanUp()
        
        // For now, texts can only be created when the base is decimal or lower
        assert(base <= 10)
        
        var text = ""
        
        if self.isNegative {
            text += "-"
        }
        
        clonedSelf.numerals.forEach { numeral in
            text += String(numeral)
        }
        
        if let commaPosition = clonedSelf.commaPosition {
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
        
        print("getting numeral at position \(index) (comma at: \(String(describing: commaPosition)), index: \(pindex), #numerals: \(numerals.count)")
        
        if index < 0 || index >= numerals.count {
            return 0
        }
        
        return numerals[index]
    }
    
    /// Removes excessive leading and trailing zeroes
    mutating func cleanUp() {
        print("start has \(numerals) (decimal at: \(String(describing: commaPosition))")
        
        
        while true {
            if numerals.isEmpty { break }
            
            if numerals[0] == 0 {
                numerals.remove(at: 0)
                if commaPosition != nil {
                    commaPosition! -= 1
                }
                continue
            }
            
            if numerals.last == 0 && numerals.count > Int(commaPosition ?? 0) {
                numerals.removeLast()
                continue
            }
            break
        }
        
        if commaPosition != nil && commaPosition! == numerals.count {
            commaPosition = nil
        }
        
        print("now has \(numerals) (decimal at: \(commaPosition)")
    }
    
    func asDouble() -> Double? {
        var double = 0.0
        
        for i in -self.countPositionsAfterDecimal()...self.countPositionsBeforeDecimal() {
            
            double += Double(self.getNumeralDecimalRelative(i)) * Double(pow(Double(self.base), Double(i - 1)))
        }
        
        if self.isNegative {
            double = -double
        }
        
        return double
    }
    
    /// Appends a numeral when provided, a comma otherwise
    mutating func appendNumeral(new numeral: UInt8?) {
        if let numeral = numeral {
            numerals.append(numeral)
        } else {
            commaPosition = UInt8(numerals.count)
        }
    }
    
    
    init(base: UInt8, numerals: [UInt8]) {
        self.base = base
        self.numerals = numerals
    }
    
    init(fromDouble double: Double, base: UInt8) {
        let text = String(abs(double))
        
        self.base = base
        self.commaPosition = nil
        self.numerals = []
        
        for char in text {
            let numeral = UInt8(String(char))
            
            if let numeral = numeral {
                self.numerals.append(numeral)
            }
            
            if char == "." {
                self.commaPosition = UInt8(self.numerals.count)
            }
        }
        
        self.isNegative = double < 0
        
    }
}


extension Number: Numberable, Equatable {
    func calculate() -> Number {
        return self
    }
}
