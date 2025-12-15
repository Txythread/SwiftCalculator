//
//  Button.swift
//  Calculator
//
//  Created by Michael Rudolf on 10.12.25.
//

import SwiftUI

struct CalculatorButton: View {
    @Binding var buttonMeta: CalculatorButtonMeta
    @Binding var currentCalculation: [Token]
    @State var buttonColor: Color
    @State var pressed = false
    @State var buttonShrink: CGFloat = 10
    
    #if os(macOS)
    #else
    @GestureState private var isPressed = false
    #endif

    var body: some View {
        GeometryReader { geometry in
            Text(buttonMeta.getDisplayText())
                .font(.system(size: 30))
                .foregroundStyle(Color.white)
                .frame(width: geometry.size.height - buttonShrink, height: geometry.size.height - buttonShrink)
                .background(buttonColor)
                .opacity(buttonMeta.isOpaque() ? 1 : 0)
                .cornerRadius(geometry.size.width/2)
                .padding(buttonShrink/2)
                .onTapGesture {
                    updateCalculation()
                    let originalColor = buttonMeta.getButtonColor()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        pressed = true
                        buttonColor = .blue
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            buttonColor = originalColor
                            pressed = false
                        }
                    }
                }
            #if os(macOS)
                .onHover { hovering in
                    if hovering {
                        buttonColor = .white
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            buttonColor = buttonMeta.getButtonColor()
                        }
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
                .onChange(of: pressed) { oldValue, newValue in
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            buttonShrink = 20
                            
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            buttonShrink = 10
                        }
                    }
                }
        }
    }
    
    func updateCalculation()  {
        print("updating calculation_1")
        
        if let lastElement = self.currentCalculation.last {
            switch lastElement {
                case .Number(var number):
                    switch self.buttonMeta {
                        case .Numeral(_):
                            number.appendNumeral(new: self.buttonMeta.getNumber())
                            self.currentCalculation[self.currentCalculation.count - 1] = Token.Number(number)
                        default:
                            break
                    }
                    return
                case .Operator(_):
                    // Create new entry
                    // don't return
                    break
            }
        }
        
        // Handle creating a new element
        let newElement = Token.Number(Number(base: 10, numerals: [self.buttonMeta.getNumber()!]))
        
        print("updating calculation")
        
        currentCalculation.append(newElement)
        
        
    }

    init(buttonMeta: Binding<CalculatorButtonMeta>, currentCalculation: Binding<[Token]>) {
        self._buttonMeta = buttonMeta
        self._buttonColor = State(initialValue: buttonMeta.wrappedValue.getType() == .Numeral ? .gray : .orange)
        self._currentCalculation = currentCalculation
    }
}

// The rest of your enums and structs remain unchanged.
enum CalculatorButtonType {
    case Numeral
    case Operator
    case Other
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
    
    /// Invisible button that takes up normal space
    case Placeholder
    
    
    /// Wether the button should be hidden

    func getType() -> CalculatorButtonType {
        switch self {
            case .Numeral(_):
                return .Numeral
            case .Operator(_):
                return .Operator
            default:
                return .Other
        }
    }
    
    func isOpaque() -> Bool {
        switch self {
            case .Placeholder:
                return false
            default:
                return true
        }
    }
    
    func getNumber() -> UInt8? {
        switch self {
            case .Numeral(let int):
                return UInt8(int)
            default:
                return nil
        }
    }

    func getDisplayText() -> String {
        switch self {
            case .Numeral(let x):
                return String(x)
            case .Operator(let op):
                return op.getDisplayText()
            default:
                return ""
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
