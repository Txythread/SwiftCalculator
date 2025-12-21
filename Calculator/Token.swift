//
//  Token.swift
//  Calculator
//
//  Created by Michael Rudolf on 14.12.25.
//

/// Anything that might be displayed at the calculator
enum Token: Equatable {
    case Number(Number)
    case Operator(Operation)
    case Variable(String, Int)
    

    
    func getDisplayText() -> String {
        switch self {
            case .Number(let number):
                return number.getDisplayText()
            case .Operator(let operation):
                return operation.getDisplayText()
            case .Variable(let groupName, let index):
                return "\(groupName)\(index)"
        }
    }
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        switch lhs {
            case .Number(let numberA):
                switch rhs {
                    case .Number(let numberB):
                        return numberA == numberB
                    case .Operator(_):
                        return false
                    case .Variable(_, _):
                        return false
                }
            case .Operator(let operationA):
                switch rhs {
                    case .Number(_):
                        return false
                    case .Operator(let operationB):
                        return operationA == operationB
                    case .Variable(_, _):
                        return false
                }
            case .Variable(let nameA, let valueA):
                switch rhs {
                    case .Number(_):
                        return false
                    case .Operator(_):
                        return false
                    case .Variable(let nameB, let valueB):
                        return nameA == nameB && valueA == valueB
                }
        }
    }
}

