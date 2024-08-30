//
//  ChatViewModel.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    
    @Published var messages = [Message]()
    @Published var textMessage: String = ""
    @Published var isOnline: Bool = false
    
    private lazy var chatDataGenerator = MockDataGenerator()
    private var subscriptions = Set<AnyCancellable>()
    
    func sendMessage() {
        if !textMessage.isEmpty {
            messages.append(Message(content: textMessage, isCurrentUser: true))
            textMessage = ""
        }
    }
    
    func connect() {
        guard !isOnline else {
            return
        }
        isOnline = true
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let message = self.chatDataGenerator.randomMessage()
                self.messages.append(message)
            }
            .store(in: &subscriptions)
    }
    
    func disconnect() {
        guard isOnline else {
            return
        }
        isOnline = false
        subscriptions.removeAll()
    }
}
