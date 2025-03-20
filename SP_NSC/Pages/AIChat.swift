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
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        ChatMessageView(message: message)
                    }
                }
                .padding(.vertical)
            }
            
            HStack {
                TextField("Ask about Singapore...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .font(.title2)
                        .foregroundColor(singaporeRed)
                }
                .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.trailing)
            }
            .padding(.vertical)
        }
        .navigationTitle("Singapore Trivia")
    }
    
    private func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        // Award points for asking a question
        userManager.addPoints(25, for: "trivia")
        
        viewModel.sendMessage(trimmedInput)
        userInput = ""
    }
}
