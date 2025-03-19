//
//  AIChatbot.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    
    // Replace with your actual API key.
    private let apiKey = "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"
    
    func sendMessage(_ text: String) {
        // Append user's message to chat.
        let userMessage = ChatMessage(role: "user", content: text)
        messages.append(userMessage)
        
        // Fetch AI response.
        fetchAIResponse(for: text)
    }
    
    private func fetchAIResponse(for prompt: String) {
        // Updated endpoint per the curl example.
        guard let url = URL(string: "https://api.openai.com/v1/responses") else {
            print("Invalid URL")
            return
        }
        
        // Create payload with the required "input" parameter.
        let payload = ChatRequest(model: "gpt-4o", input: prompt)
        guard let jsonData = try? JSONEncoder().encode(payload) else {
            print("Failed to encode JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data in response")
                return
            }
            
            // Debug: Print the raw JSON response (optional)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            do {
                let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                // Extract the first output message's text.
                if let aiOutput = chatResponse.output.first?.content.first?.text {
                    DispatchQueue.main.async {
                        let message = ChatMessage(role: "assistant", content: aiOutput)
                        self.messages.append(message)
                    }
                } else {
                    print("No output message found")
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
