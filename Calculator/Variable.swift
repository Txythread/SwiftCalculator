//
//  Variable.swift
//  Calculator
//
//  Created by Michael Rudolf on 21.12.25.
//


struct VariableGroup {
    var values: [Number]
    var groupName: String = "x"
    
    init(values: Int, groupName: String) {
        self.values = []
        
        for i in 0...values {
            self.values.append(Number(base: 10, numerals: [UInt8(i + 1)]))
        }
        
        self.groupName = groupName
    }
}


