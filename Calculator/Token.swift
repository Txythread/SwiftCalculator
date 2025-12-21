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
    case StoreInto
    

    
    func getDisplayText() -> String {
        switch self {
            case .Number(let number):
                return number.getDisplayText()
            case .Operator(let operation):
                return operation.getDisplayText()
            case .Variable(let groupName, let index):
                return "\(groupName)\(index)"
            case .StoreInto:
                return "->"
        }
    }
    
    static func == (lhs: Token, rhs: Token) -> Bool {
        switch lhs {
            case .Number(let numberA):
                switch rhs {
                    case .Number(let numberB):
                        return numberA == numberB
                    default:
                        return false
                }
            case .Operator(let operationA):
                switch rhs {
                    case .Operator(let operationB):
                        return operationA == operationB
                    default:
                        return false
                }
            case .Variable(let nameA, let valueA):
                switch rhs {
                    case .Variable(let nameB, let valueB):
                        return nameA == nameB && valueA == valueB
                    default:
                        return false
                }
                
            case .StoreInto:
                switch rhs {
                    case .StoreInto:
                        return true
                    default:
                        return false
                }
        }
    }
}

