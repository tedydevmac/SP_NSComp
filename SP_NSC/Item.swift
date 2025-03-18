//
//  Item.swift
//  SP_NSC
//
//  Created by Ted Goh on 18/3/25.
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
