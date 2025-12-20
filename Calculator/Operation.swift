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
    
    var importance: Int {
        switch self {
            case .Addition:
                return 1
            case .Multiplication:
                return 10
            case .Subtraction:
                return 1
            case .Division:
                return 10
        }
    }
}
