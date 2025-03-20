//
//  ChatMessage.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import Foundation

// Simple message model for the chat UI.
struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String   // "user", "assistant", or "system"
    let content: String
}

// Request payload for creating an assistant
struct AssistantRequest: Codable {
    let instructions: String
    let name: String
    let tools: [Tool]
    let model: String
    
    struct Tool: Codable {
        let type: String
    }
}

// Response structure for assistant creation
struct AssistantResponse: Codable {
    let id: String
    let object: String
    let created_at: Int
    let name: String
    let description: String?
    let model: String
    let instructions: String
    let tools: [AssistantRequest.Tool]
}

// Response structure for thread creation
struct ThreadResponse: Codable {
    let id: String
    let object: String
    let created_at: Int
}

// Request payload for creating a thread message
struct ThreadMessageRequest: Codable {
    let role: String
    let content: String
}

// Response structure for messages
struct ThreadMessageResponse: Codable {
    let data: [Message]
    
    struct Message: Codable {
        let id: String
        let object: String
        let created_at: Int
        let role: String
        let content: [Content]
        
        struct Content: Codable {
            let type: String
            let text: Text
            
            struct Text: Codable {
                let value: String
            }
        }
    }
}

// Response structure for run creation
struct RunResponse: Codable {
    let id: String
    let object: String
    let created_at: Int
    let assistant_id: String
    let thread_id: String
    let status: String
}

// Response structure for run status
struct RunStatusResponse: Codable {
    let id: String
    let object: String
    let created_at: Int
    let assistant_id: String
    let thread_id: String
    let status: String
    let last_error: RunError?
    
    struct RunError: Codable {
        let code: String
        let message: String
    }
}
