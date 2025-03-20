import SwiftUI

let singaporeRed = Color(hex: "#ED1C24")

struct ChatMessageView: View {
    let message: ChatMessage
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(singaporeRed)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: isAnimating ? 0 : 50)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(singaporeRed)
                    .padding(.leading, 8)
            } else {
                Image(systemName: "smallcircle.circle.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(singaporeRed.opacity(0.6))
                    .padding(.trailing, 8)
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(singaporeRed.opacity(0.2))
                    .cornerRadius(16)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: isAnimating ? 0 : -50)
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct AIChatModal: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    @State private var isButtonPressed = false
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageView(message: message)
                                .id(message.id)
                        }
                        if isLoading {
                            HStack {
                                Image(systemName: "smallcircle.circle.fill")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(singaporeRed.opacity(0.6))
                                    .padding(.trailing, 8)
                                LoadingDots()
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(singaporeRed.opacity(0.2))
                                    .cornerRadius(16)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: viewModel.messages.count) {
                    if let lastMessage = viewModel.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            
            Divider()
            
            HStack(spacing: 8) {
                TextField("Ask about Singapore...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading, 8)
                
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isButtonPressed = true
                        sendMessage()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            isButtonPressed = false
                        }
                    }
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(singaporeRed)
                        .scaleEffect(isButtonPressed ? 0.8 : 1.0)
                        .opacity(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
                }
                .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.trailing, 8)
            }
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
        }
        .navigationTitle("Singapore Trivia")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        // Award points for asking a question
        userManager.addPoints(25, for: "trivia")
        
        isLoading = true
        withAnimation {
            viewModel.sendMessage(trimmedInput)
            userInput = ""
        }
        // Simulate network delay for loading indicator
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
        }
    }
}

struct LoadingDots: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(singaporeRed.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(0.2 * Double(index)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}
