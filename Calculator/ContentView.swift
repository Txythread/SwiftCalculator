//
//  ContentView.swift
//  Calculator
//
//  Created by Michael Rudolf on 10.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var calculationText = "Was geht ab im Taschenrechner"
    @State var buttons: [[CalculatorButtonMetaMeta]] = [
        [
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Clear),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Placeholder),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Placeholder),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Placeholder),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Operator(.Division))
        ],
        
        
        
        [
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Placeholder),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(9)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(8)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(7)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Operator(.Multiplication))
        ],
        
        [
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Placeholder),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(6)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(5)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(4)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Operator(.Subtraction))
        ],
        
        [
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Variable("x")),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(3)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(2)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(1)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Operator(.Addition))
        ],
        
        [
            CalculatorButtonMetaMeta(CalculatorButtonMeta.StoreInto),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Placeholder),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Numeral(0)),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Decimal),
            CalculatorButtonMetaMeta(CalculatorButtonMeta.Calculate)
        ],
    ]
    
    @State var currentCalculation: [Token] = []
    @State var buttonWidth: CGFloat = 10
    
    /// The padding of all buttons to the screen.
    let totalButtonPadding: CGFloat = 5
    
    var body: some View {
        ZStack {
            Color
                .black
                .ignoresSafeArea(.all)
            
            VStack {
                Text(calculationText)
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                    .padding(.all, 0)
                    .frame(minWidth: 0, idealWidth: 20000, maxWidth: 20000)
                    .padding(.all, 10)
                    .background(Color.gray, alignment: .bottom)
                    .cornerRadius(30)
                    .padding(.all, 10)
                    .onChange(of: currentCalculation) { _, _ in
                        updateCalculationText()
                    }
                
                
                Spacer()
                
                VStack(spacing: 0) {
                    ForEach(buttons.indices, id: \.self) { rowIndex in
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                ForEach(buttons[rowIndex].indices, id: \.self) { columnIndex in
                                    CalculatorButton(
                                        buttonMeta: $buttons[rowIndex][columnIndex].content,
                                        currentCalculation: $currentCalculation
                                    )
                                    .frame(
                                        maxWidth: buttonWidth,
                                        maxHeight: buttonWidth
                                    )
                                }
                                .padding([.leading, .trailing], totalButtonPadding/4)
                                
                            }
                            .onAppear {
                                // Recalculate the button width to match the available screen size
                                buttonWidth = CGFloat((Int(geometry.size.width) - Int(totalButtonPadding)) / buttons[rowIndex].count)
                            }
                            
                        }
                        .frame(height: buttonWidth)
                        
                    }
                    
                }
            }
        }
        
    }
    
    /// Re-calculate the text of the label based on the currentCalculation variable
    func updateCalculationText() {
        calculationText = ""
        for token in currentCalculation {
            calculationText += token.getDisplayText()
        }
        
        // Prevent empty texts
        if calculationText == "" {
            calculationText = " "
        }
    }
    
}

#Preview {
    ContentView()
}
