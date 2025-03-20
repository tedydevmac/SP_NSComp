import Foundation

struct User: Codable {
    var username: String
    var email: String
    var password: String
    var points: Int
    var achievements: [Achievement]
    var joinDate: Date
    
    struct Achievement: Codable, Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let icon: String
        let dateEarned: Date
        let isUnlocked: Bool
    }
} 