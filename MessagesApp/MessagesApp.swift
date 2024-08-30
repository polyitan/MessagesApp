//
//  MessagesApp.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import SwiftUI

@main
struct MessagesApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView(viewModel: ChatViewModel())
        }
    }
}
