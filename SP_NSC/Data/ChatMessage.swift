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
    let role: String   // "user" or "assistant"
    let content: String
}

// Request payload with "model" and "input".
struct ChatRequest: Codable {
    let model: String
    let input: String
}

// The expected response structure.
struct ChatResponse: Codable {
    let id: String
    let object: String
    let created_at: Int
    let status: String
    let model: String
    let output: [OutputMessage]
    
    struct OutputMessage: Codable, Identifiable {
        var id: String { uniqueId }
        let uniqueId: String
        let type: String
        let status: String
        let role: String
        let content: [ContentBlock]
        
        struct ContentBlock: Codable {
            let type: String
            let text: String
            let annotations: [String]  // Adjust type if needed.
        }
        
        // Map JSON key "id" to "uniqueId" if necessary.
        private enum CodingKeys: String, CodingKey {
            case uniqueId = "id"
            case type, status, role, content
        }
    }
}
