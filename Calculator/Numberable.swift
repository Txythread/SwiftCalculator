//
//  Numberable.swift
//  Calculator
//
//  Created by Michael Rudolf on 18.12.25.
//

/// Anything that can be turned into a number
protocol Numberable {
    func calculate() -> Number
}


extension Numberable {
    func calculateClean() -> Number {
        return self.calculate().cleanedUp()
    }
}
