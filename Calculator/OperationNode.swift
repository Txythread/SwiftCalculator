//
//  OperationNode.swift
//  Calculator
//
//  Created by Michael Rudolf on 18.12.25.
//

/// An operation and the corrisponding arguments
struct OperationNode {
    var arguments: [Numberable]
    var operation: Operation
    
    static func generateFromTokens(tokens: [Token]) -> Numberable {
        // The left side node
        var currentNode: Numberable? = nil
        var nextOperation: Operation? = nil
        
        for token in tokens {
            switch token {
                case .Number(let number):
                    if let operation = nextOperation {
                        currentNode = OperationNode(arguments: [currentNode!, number], operation: operation)
                        nextOperation = nil
                    } else {
                        currentNode = number
                    }
                case .Operator(let operation):
                    nextOperation = operation
            }
        }
        
        return currentNode!
    }
    
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
                let result = a.asDouble()! * b.asDouble()!
                let resultingNumber = Number(fromDouble: result, base: a.base)
                
                return resultingNumber
            case .Subtraction:
                let result = a.asDouble()! - b.asDouble()!
                let resultingNumber = Number(fromDouble: result, base: a.base)
                
                return resultingNumber
            case .Division:
                let result = a.asDouble()! / b.asDouble()!
                let resultingNumber = Number(fromDouble: result, base: a.base)
                
                return resultingNumber
        }
    }
}
