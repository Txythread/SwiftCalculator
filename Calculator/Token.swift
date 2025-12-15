//
//  Token.swift
//  Calculator
//
//  Created by Michael Rudolf on 14.12.25.
//


enum Token: Equatable {
    static func == (lhs: Token, rhs: Token) -> Bool {
        switch lhs {
            case .Number(let numberA):
                switch rhs {
                    case .Number(let numberB):
                        return numberA == numberB
                    case .Operator(_):
                        return false
                }
            case .Operator(let operationA):
                switch rhs {
                    case .Number(_):
                        return false
                    case .Operator(let operationB):
                        return operationA == operationB
                }
        }
    }
    
    case Number(Number)
    case Operator(Operation)
    
    
    func getDisplayText() -> String {
        switch self {
            case .Number(let number):
                return number.getDisplayText()
            case .Operator(let operation):
                return operation.getDisplayText()
        }
    }
}

struct Number: Equatable {
    var base: UInt8 = 10
    var numerals: [UInt8]
    var commaPosition: UInt8? = nil
    
    init(base: UInt8, numerals: [UInt8]) {
        self.base = base
        self.numerals = numerals
    }
    
    func getDisplayText() -> String {
        assert(base <= 10)
        
        var text = ""
        
        for numeral in numerals {
            text += String(numeral)
        }
        
        if let commaPosition = commaPosition {
            text.insert(Character(","), at: text.index(text.startIndex, offsetBy: Int(commaPosition)))
        }
        
        return text
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
