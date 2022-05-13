//
//  Note.swift
//  QuickThink
//
//  Created by Daniel Senga on 2022/05/12.
//

import Foundation

class Note: NSObject, Codable {
    var name: String
    var note: String
    
    init(name: String, note: String) {
        self.name = name
        self.note = note
    }
}
