import Foundation

class AchievementManager {
    
    func checkPointsAchievements(for user: inout User) {
        // Points milestones
        let pointsAchievements = [
            (100, "First Milestone", "Earned 100 points!", "star.fill"),
            (500, "Halfway There", "Earned 500 points!", "star.circle.fill"),
            (1000, "Point Master", "Earned 1000 points!", "star.square.fill")
        ]
        
        for (points, title, description, icon) in pointsAchievements {
            if user.points >= points && !user.achievements.contains(where: { $0.title == title }) {
                user.achievements.append(User.Achievement(
                    title: title,
                    description: description,
                    icon: icon,
                    dateEarned: Date(),
                    isUnlocked: true
                ))
                print("DEBUG: Achievement unlocked - \(title)")
            }
        }
    }
    
    func checkActionAchievements(for user: inout User, action: String) {
        // Action-specific achievements
        switch action {
        case "photobooth":
            if !user.achievements.contains(where: { $0.title == "Photobooth Pro" }) {
                user.achievements.append(User.Achievement(
                    title: "Photobooth Pro",
                    description: "Used the photobooth feature and took a photo!",
                    icon: "camera.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
                print("DEBUG: Achievement unlocked - Photobooth Pro")
            }
        case "trivia":
            if !user.achievements.contains(where: { $0.title == "Trivia Master" }) {
                user.achievements.append(User.Achievement(
                    title: "Trivia Master",
                    description: "Used the Singapore Trivia chatbot!",
                    icon: "questionmark.circle.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
                print("DEBUG: Achievement unlocked - Trivia Master")
            }
        case "explore":
            if !user.achievements.contains(where: { $0.title == "Culture Explorer" }) {
                user.achievements.append(User.Achievement(
                    title: "Culture Explorer",
                    description: "Used the explore page!",
                    icon: "map.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
                print("DEBUG: Achievement unlocked - Culture Explorer")
            }
        case "timeline":
            if !user.achievements.contains(where: { $0.title == "History Buff" }) {
                user.achievements.append(User.Achievement(
                    title: "History Buff",
                    description: "Used the TimelineView!",
                    icon: "book.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
                print("DEBUG: Achievement unlocked - History Buff")
            }
        default:
            break
        }
    }
    
    func getAllPossibleAchievements() -> [User.Achievement] {
        // Welcome achievement
        let welcomeAchievement = User.Achievement(
            title: "Welcome to SG60",
            description: "You've joined the SG60 community!",
            icon: "star.fill",
            dateEarned: Date(),
            isUnlocked: false
        )
        
        // Points milestones
        let pointsAchievements = [
            (100, "First Milestone", "Earned 100 points!", "star.fill"),
            (500, "Halfway There", "Earned 500 points!", "star.circle.fill"),
            (1000, "Point Master", "Earned 1000 points!", "star.square.fill")
        ].map { points, title, description, icon in
            User.Achievement(
                title: title,
                description: description,
                icon: icon,
                dateEarned: Date(),
                isUnlocked: false
            )
        }
        
        // Feature achievements
        let featureAchievements = [
            ("Photobooth Pro", "Used the photobooth feature and took a photo!", "camera.fill"),
            ("Trivia Master", "Used the Singapore Trivia chatbot!", "questionmark.circle.fill"),
            ("Culture Explorer", "Used the explore page!", "map.fill"),
            ("History Buff", "Used the TimelineView!", "book.fill")
        ].map { title, description, icon in
            User.Achievement(
                title: title,
                description: description,
                icon: icon,
                dateEarned: Date(),
                isUnlocked: false
            )
        }
        
        return [welcomeAchievement] + pointsAchievements + featureAchievements
    }
    
    func getAllAchievements(for user: User) -> [User.Achievement] {
        let allPossible = getAllPossibleAchievements()
        return allPossible.map { possible in
            if let unlocked = user.achievements.first(where: { $0.title == possible.title }) {
                return unlocked
            }
            return possible
        }
    }
}
