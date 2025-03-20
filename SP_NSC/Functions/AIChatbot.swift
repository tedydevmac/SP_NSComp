//
//  AIChatbot.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isInitialized = false
    private var assistantId: String?
    private var threadId: String?
    
    // Replace with your actual API key
    private let apiKey = "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"
    
    init() {
        initializeChat()
    }
    
    private func initializeChat() {
        print("Starting chat initialization...")
        createAssistant()
    }
    
    private func createAssistant() {
        print("Creating assistant...")
        guard let url = URL(string: "https://api.openai.com/v1/assistants") else {
            print("Invalid URL for creating assistant")
            return
        }
        
        let assistantRequest = AssistantRequest(
            instructions: "You are an assistant for the SG60 app. Help users learn about Singapore's history and culture by acting as a trivia bot. When you send a response, make sure the text does not include any styling like bold text because it appears as astericks from raw json.",
            name: "SG60 Assistant",
            tools: [AssistantRequest.Tool(type: "code_interpreter")],
            model: "gpt-4o"
        )
        
        guard let jsonData = try? JSONEncoder().encode(assistantRequest) else {
            print("Failed to encode assistant request")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
        
        print("Sending assistant creation request...")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error creating assistant: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Assistant creation response status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received from assistant creation")
                return
            }
            
            // Print raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw assistant creation response: \(responseString)")
            }
            
            do {
                let response = try JSONDecoder().decode(AssistantResponse.self, from: data)
                print("Assistant created successfully with ID: \(response.id)")
                DispatchQueue.main.async {
                    self?.assistantId = response.id
                    self?.createThread()
                }
            } catch {
                print("Error decoding assistant response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func createThread() {
        print("Creating thread...")
        guard let url = URL(string: "https://api.openai.com/v1/threads") else {
            print("Invalid URL for creating thread")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
        
        print("Sending thread creation request...")
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error creating thread: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Thread creation response status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received from thread creation")
                return
            }
            
            // Print raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw thread creation response: \(responseString)")
            }
            
            do {
                let response = try JSONDecoder().decode(ThreadResponse.self, from: data)
                print("Thread created successfully with ID: \(response.id)")
                DispatchQueue.main.async {
                    self?.threadId = response.id
                    self?.isInitialized = true
                }
            } catch {
                print("Error decoding thread response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func sendMessage(_ text: String) {
        guard isInitialized else {
            print("Chat not initialized yet. Waiting for initialization...")
            messages.append(ChatMessage(role: "system", content: "Please wait while the chat initializes..."))
            return
        }
        
        guard let threadId = threadId, let assistantId = assistantId else {
            print("Thread ID: \(String(describing: threadId))")
            print("Assistant ID: \(String(describing: assistantId))")
            print("Missing thread or assistant ID")
            return
        }
        
        print("Sending message to thread \(threadId)...")
        
        // Add message to UI immediately
        let userMessage = ChatMessage(role: "user", content: text)
        messages.append(userMessage)
        
        // Send message to thread
        let messageUrl = URL(string: "https://api.openai.com/v1/threads/\(threadId)/messages")!
        var messageRequest = URLRequest(url: messageUrl)
        messageRequest.httpMethod = "POST"
        messageRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        messageRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        messageRequest.addValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
        
        let messageData = ThreadMessageRequest(role: "user", content: text)
        messageRequest.httpBody = try? JSONEncoder().encode(messageData)
        
        URLSession.shared.dataTask(with: messageRequest) { [weak self] data, response, error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Message send response status: \(httpResponse.statusCode)")
            }
            
            // Run the assistant
            self?.runAssistant(threadId: threadId, assistantId: assistantId)
        }.resume()
    }
    
    private func runAssistant(threadId: String, assistantId: String) {
        print("Running assistant on thread \(threadId)...")
        let runUrl = URL(string: "https://api.openai.com/v1/threads/\(threadId)/runs")!
        var runRequest = URLRequest(url: runUrl)
        runRequest.httpMethod = "POST"
        runRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        runRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        runRequest.addValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
        
        let runData = ["assistant_id": assistantId]
        runRequest.httpBody = try? JSONEncoder().encode(runData)
        
        URLSession.shared.dataTask(with: runRequest) { [weak self] data, response, error in
            if let error = error {
                print("Error running assistant: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Run assistant response status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received from run assistant")
                return
            }
            
            do {
                let runResponse = try JSONDecoder().decode(RunResponse.self, from: data)
                print("Run created with ID: \(runResponse.id)")
                
                // Poll for run completion
                self?.pollRunStatus(threadId: threadId, runId: runResponse.id)
            } catch {
                print("Error decoding run response: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func pollRunStatus(threadId: String, runId: String) {
        let statusUrl = URL(string: "https://api.openai.com/v1/threads/\(threadId)/runs/\(runId)")!
        var statusRequest = URLRequest(url: statusUrl)
        statusRequest.httpMethod = "GET"
        statusRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        statusRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        statusRequest.addValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
        
        URLSession.shared.dataTask(with: statusRequest) { [weak self] data, response, error in
            if let error = error {
                print("Error checking run status: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received from run status check")
                return
            }
            
            do {
                let statusResponse = try JSONDecoder().decode(RunStatusResponse.self, from: data)
                print("Run status: \(statusResponse.status)")
                
                if statusResponse.status == "completed" {
                    // Wait a moment for the message to be processed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.fetchMessages(threadId: threadId)
                    }
                } else if statusResponse.status == "failed" {
                    print("Run failed: \(statusResponse.last_error?.message ?? "Unknown error")")
                } else if statusResponse.status == "expired" {
                    print("Run expired")
                } else {
                    // If still running, poll again after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.pollRunStatus(threadId: threadId, runId: runId)
                    }
                }
            } catch {
                print("Error decoding run status: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func fetchMessages(threadId: String) {
        print("Fetching messages from thread \(threadId)...")
        let messagesUrl = URL(string: "https://api.openai.com/v1/threads/\(threadId)/messages")!
        var messagesRequest = URLRequest(url: messagesUrl)
        messagesRequest.httpMethod = "GET"
        messagesRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        messagesRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        messagesRequest.addValue("assistants=v2", forHTTPHeaderField: "OpenAI-Beta")
        
        URLSession.shared.dataTask(with: messagesRequest) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching messages: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Fetch messages response status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No message data received")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ThreadMessageResponse.self, from: data)
                // Find the first assistant message that we haven't shown yet
                if let assistantMessage = response.data.first(where: { message in
                    message.role == "assistant" && 
                    !(self?.messages.contains(where: { $0.content == message.content.first?.text.value }) ?? false)
                }),
                   let messageContent = assistantMessage.content.first?.text.value {
                    print("Received assistant message: \(messageContent)")
                    DispatchQueue.main.async {
                        let assistantMessage = ChatMessage(role: "assistant", content: messageContent)
                        self?.messages.append(assistantMessage)
                    }
                }
            } catch {
                print("Error decoding messages: \(error.localizedDescription)")
            }
        }.resume()
    }
}
