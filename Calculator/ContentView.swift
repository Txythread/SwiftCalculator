//
//  ContentView.swift
//  Calculator
//
//  Created by Michael Rudolf on 10.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State var calculationText = "Was geht ab im Taschenrechner"
    @State var buttonType0 = CalculatorButtonMeta.Numeral(0)
    
    var body: some View {
        VStack {
            Text(calculationText)
                .font(.system(size: 40))
                .padding(.all, 0)
                .frame(minWidth: 0, idealWidth: 20000, maxWidth: 20000)
                .padding(.all, 10)
                .background(Color.gray, alignment: .bottom)
                .cornerRadius(30)
                .padding(.all, 10)
            
            
                
            VStack {
                ForEach(0..<4) { i in
                    HStack {
                        CalculatorButton(buttonMeta: $buttonType0)
                            .frame(maxWidth: 100, maxHeight: 100)
                        CalculatorButton(buttonMeta: $buttonType0)
                            .frame(maxWidth: 100, maxHeight: 100)
                        CalculatorButton(buttonMeta: $buttonType0)
                            .frame(maxWidth: 100, maxHeight: 100)
                    }
                }
                
            }
            Spacer()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

