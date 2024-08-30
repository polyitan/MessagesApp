//
//  ChatView.swift
//  MessagesApp
//
//  Created by Sergii Tkachenko on 30.08.2024.
//

import Combine
import SwiftUI

struct ChatView: View {
    
    @StateObject private var viewModel: ChatViewModel
    @FocusState  private var newMessageIsFocused: Bool
    @State       private var hasScrolledToEnd: Bool = false
    
    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                DetectionScrollView(hasScrolledToEnd: $hasScrolledToEnd) {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(viewModel.messages, id: \.self) { message in
                            MessageView(currentMessage: message)
                                .id(message)
                        }
                    }
                    .onReceive(Just(viewModel.$messages)) { message in
                        print("onReceive: \(viewModel.messages.count), bottom: \(hasScrolledToEnd)")
                        //guard hasScrolledToEnd else { return } // TODO: fix it
                        withAnimation(.easeOut(duration: 0.2).delay(0.1)) {
                            proxy.scrollTo(viewModel.messages.last, anchor: .bottom)
                        }
                    }
                }
                .onTapGesture {
                    guard newMessageIsFocused else {
                        return
                    }
                    newMessageIsFocused = false
                    withAnimation(.easeOut(duration: 0.2).delay(0.1)) {
                        proxy.scrollTo(viewModel.messages.last, anchor: .bottom)
                    }
                }
            }
            // Send text message
            sendMessageView
        }
        .overlay(alignment: .top) {
            overlayView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: viewModel.connect)
        .onDisappear(perform: viewModel.disconnect)
    }
    
    @ViewBuilder
    private var sendMessageView: some View {
        VStack {
            HStack {
                TextField("Text message", text: $viewModel.textMessage)
                    .textFieldStyle(.roundedBorder)
                    .focused($newMessageIsFocused)
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "paperplane")
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var overlayView: some View {
        HStack {
            Spacer()
            Button(action: viewModel.isOnline ? viewModel.disconnect : viewModel.connect) {
                Image(systemName: viewModel.isOnline ? "network" : "network.slash")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .aspectRatio(contentMode: .fit)
            }
        }
        .frame(height: 64)
        .padding()
    }
}

#Preview {
    ChatView(viewModel: ChatViewModel())
}

