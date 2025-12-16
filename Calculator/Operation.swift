//
//  Operation.swift
//  Calculator
//
//  Created by Michael Rudolf on 16.12.25.
//

enum Operation {
    case Addition
    case Multiplication
    case Subtraction
    case Division
    
    func getDisplayText() -> String {
        switch self {
            case .Addition:
                return "+"
            case .Multiplication:
                return "*"
            case .Division:
                return "/"
            case .Subtraction:
                return "-"
        }
    }
}

/// An operation and the corrisponding arguments
struct OperationNode {
    var arguments: [Numberable]
    var operation: Operation
    
    init(arguments: [Numberable], operation: Operation) {
        self.arguments = arguments
        self.operation = operation
    }
}

extension OperationNode: Numberable {
    func calculate() -> Number {
        assert(arguments.count == 2)
        
        let a = arguments[0].calculate()
        let b = arguments[1].calculate()
        
        let posAfterDecimalCount =  Int(max(a.countPositionsAfterDecimal(), b.countPositionsAfterDecimal()))
        let posBeforeDecimalCount = Int(max(a.countPositionsBeforeDecimal(), b.countPositionsBeforeDecimal()))
        
        print("after decimal count: \(posAfterDecimalCount)")
        print("before decimal #: \(posBeforeDecimalCount)")
        
        switch operation {
            case .Addition:
                var rest = 0
                var resultingNumber = Number(base: a.base, numerals: [])
                resultingNumber.commaPosition = UInt8(posBeforeDecimalCount + 1)
                
                for i in -posAfterDecimalCount...posBeforeDecimalCount + 1 {
                    let currentResult = (UInt8(rest) + a.getNumeralDecimalRelative(i) + b.getNumeralDecimalRelative(i))
                    
                    print("added \(a.getNumeralDecimalRelative(i))) and \(b.getNumeralDecimalRelative(i)) (position \(i)) ")
                    
                    let currentNumeral = currentResult % resultingNumber.base
                    rest = Int(currentResult - currentNumeral) / Int(resultingNumber.base)
                    resultingNumber.numerals.insert(currentNumeral, at: 0)
                }
                
                return resultingNumber
            case .Multiplication:
                break
            case .Subtraction:
                break
            case .Division:
                break
        }
        
        return Number(base: 10, numerals: [])
    }
}


/// Anything that can be turned into a number
protocol Numberable {
    func calculate() -> Number
}
