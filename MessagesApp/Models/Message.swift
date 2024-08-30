//
//  Message.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import Foundation

struct Message: Hashable {
    var id = UUID()
    var content: String
    var isCurrentUser: Bool
}
