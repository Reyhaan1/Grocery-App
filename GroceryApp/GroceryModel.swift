//
//  GroceryModel.swift
//  GroceryApp
//
//  Created by Reyhaan Alim on 21/03/2022.
//

import Foundation

class GroceryModel {
    var key: String
    var isComplete: Bool
    var title: String
    var description: String
    
    init(key: String, title: String, description: String, isComplete: Bool) {
        self.key = key
        self.title = title
        self.description = description
        self.isComplete = isComplete
    }
}
