//
//  Item.swift
//  Calculator
//
//  Created by Michael Rudolf on 10.12.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
