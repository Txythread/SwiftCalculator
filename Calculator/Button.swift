//
//  Button.swift
//  Calculator
//
//  Created by Michael Rudolf on 10.12.25.
//

import SwiftUI

struct CalculatorButton: View {
    @Binding var buttonMeta: CalculatorButtonMeta
    @State var buttonColor: Color
    
    #if os(macOS)
    #else
    @GestureState private var isPressed = false
    #endif

    var body: some View {
        GeometryReader { geometry in
            Text(buttonMeta.getDisplayText())
                .font(.system(size: 30))
                .foregroundStyle(Color.white)
                .frame(width: geometry.size.height - 10, height: geometry.size.height - 10)
                .background(buttonColor)
                .cornerRadius(geometry.size.width/2)
                .padding(5)
                .onTapGesture {
                    // iOS and macOS: Animate feedback on tap
                    let originalColor = buttonMeta.getButtonColor()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        buttonColor = .red
                    }
                    // Animate back to original color after 0.2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            buttonColor = originalColor
                        }
                    }
                }
            #if os(macOS)
                .onHover { hovering in
                    let newColor = hovering ? Color.white : buttonMeta.getButtonColor()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        buttonColor = newColor
                    }
                }
            #else
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded {_ in
                            buttonColor = buttonMeta.getButtonColor()
                        }
                        .updating($isPressed) {x1,x2,x3 in
                            
                            withAnimation(.easeInOut(duration: 0.2)) {
                                buttonColor = .white
                            }
                            
                        }
                )
            #endif
        }
    }

    init(buttonMeta: Binding<CalculatorButtonMeta>) {
        self._buttonMeta = buttonMeta
        self._buttonColor = State(initialValue: buttonMeta.wrappedValue.getType() == .Numeral ? .gray : .orange)
    }
}

// The rest of your enums and structs remain unchanged.
enum CalculatorButtonType {
    case Numeral
    case Operator
}

struct CalculatorButtonMetaMeta: Identifiable {
    public var content: CalculatorButtonMeta
    public var id: UUID

    init(_ content: CalculatorButtonMeta) {
        self.content = content
        self.id = UUID()
    }
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

    func getDisplayText() -> String {
        switch self {
        case .Numeral(let x):
            return String(x)
        case .Operator(let op):
            return op.getDisplayText()
        }
    }
    
    func getButtonColor() -> Color {
        return getType() == .Numeral ? Color.gray : Color.orange
    }
}

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
/*
#Preview {
    @Previewable @State var buttonT = CalculatorButtonMeta.Numeral(2)
    
    CalculatorButton(buttonMeta: $buttonT)
        .frame(width: 100, height: 100)
}
*/
