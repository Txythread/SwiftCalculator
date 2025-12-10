//
//  Button.swift
//  Calculator
//
//  Created by Michael Rudolf on 10.12.25.
//

import SwiftUI

struct CalculatorButton: View {
    @Binding var buttonMeta: CalculatorButtonMeta
    var body: some View {
        GeometryReader() { geometry in
            Text("1")
                .frame(width: geometry.size.height, height: geometry.size.height)
                .background(buttonMeta.getType() == .Numeral ? .gray : .orange)
                .cornerRadius(geometry.size.width/2)
                .padding()
        }
    }
}

enum CalculatorButtonType {
    case Numeral
    case Operator
}

enum CalculatorButtonMeta {
    case Numeral(Int)
    case Operator(Operation)
    
    
    func getType() -> CalculatorButtonType {
        switch self {
            case .Numeral(_):
                return .Numeral
            case .Operator(_):
                return .Operator
        }
    }
}

enum Operation {
    case Addition
    case Multiplication
    case Subtraction
    case Division
}

#Preview {
    @Previewable @State var buttonT = CalculatorButtonMeta.Numeral(2)
    CalculatorButton(buttonMeta: $buttonT)
}
