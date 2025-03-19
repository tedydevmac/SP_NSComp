//
//  AIChatModal.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

let singaporeRed = Color(hex: "#ED1C24")

struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(singaporeRed)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text(message.content)
                    .padding()
                    .background(singaporeRed.opacity(0.2))
                    .cornerRadius(10)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct AIChatModal: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput = ""
    var body: some View {
        NavigationView {
            VStack {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(viewModel.messages) { message in
                                    ChatMessageView(message: message)
                                }
                            }
                            .padding(.vertical)
                        }
                        
                        HStack {
                            TextField("Type a message...", text: $userInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                            
                            Button(action: {
                                                guard !userInput.isEmpty else { return }
                                                viewModel.sendMessage(userInput)
                                                userInput = ""
                                            }) {
                                                Image(systemName: "paperplane.fill")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                    .background(singaporeRed)
                                                    .clipShape(Circle())
                                            }
                            .padding(.trailing)
                        }
                        .padding(.vertical)
                    }
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            }).tint(singaporeRed)
        }
    }
}
