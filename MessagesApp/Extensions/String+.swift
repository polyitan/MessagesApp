//
//  String+.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import Foundation

extension String {
    var firstCapitalized: String {
        var string = self
        string.replaceSubrange(string.startIndex...string.startIndex, with: String(string[string.startIndex]).capitalized)
        return string
    }
}
