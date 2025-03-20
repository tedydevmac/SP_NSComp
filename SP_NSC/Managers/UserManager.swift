import Foundation

class UserManager: ObservableObject {
    @Published var currentUser: User? {
        didSet {
            if let user = currentUser {
                saveUser(user)
            }
        }
    }
    
    static let shared = UserManager()
    private let userDefaultsKey = "currentUser"
    private let allUsersKey = "allUsers"
    private let lastEmailKey = "lastUsedEmail"
    
    private init() {
        loadUser()
    }
    
    private func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("DEBUG: User saved successfully - Email: \(user.email)")
            
            // Save last used email
            UserDefaults.standard.set(user.email, forKey: lastEmailKey)
            
            var allUsers = getAllUsers()
            if !allUsers.contains(where: { $0.email == user.email }) {
                allUsers.append(user)
                if let encoded = try? JSONEncoder().encode(allUsers) {
                    UserDefaults.standard.set(encoded, forKey: allUsersKey)
                }
            }
        } else {
            print("DEBUG: Failed to encode user data")
        }
    }
    
    private func getAllUsers() -> [User] {
        if let userData = UserDefaults.standard.data(forKey: allUsersKey),
           let users = try? JSONDecoder().decode([User].self, from: userData) {
            return users
        }
        return []
    }
    
    private func loadUser() {
        if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            print("DEBUG: User loaded successfully - Email: \(user.email)")
        } else {
            print("DEBUG: No user data found in UserDefaults")
        }
    }
    
    func signUp(username: String, email: String, password: String) {
        print("DEBUG: Starting signup process for email: \(email)")
        let newUser = User(
            username: username,
            email: email,
            password: password,
            points: 0,
            achievements: [
                User.Achievement(
                    title: "Welcome to SG60",
                    description: "You've joined the SG60 community!",
                    icon: "star.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                )
            ],
            joinDate: Date()
        )
        currentUser = newUser
        print("DEBUG: Signup completed - User set as current user")
    }
    
    func signOut() {
        print("DEBUG: Signing out user")
        currentUser = nil
    }
    
    func login(email: String, password: String) -> Bool {
        print("DEBUG: Attempting login for email: \(email)")
        let allUsers = getAllUsers()
        if let user = allUsers.first(where: { $0.email == email && $0.password == password }) {
            print("DEBUG: Login successful - Found matching user")
            currentUser = user
            return true
        } else {
            print("DEBUG: Login failed - Invalid email or password")
            return false
        }
    }
    
    func isSignedIn() -> Bool {
        return currentUser != nil
    }
    
    func getLastUsedEmail() -> String? {
        return UserDefaults.standard.string(forKey: lastEmailKey)
    }
    
    func loginWithBiometrics(completion: @escaping (Bool) -> Void) {
        guard let lastEmail = getLastUsedEmail(),
              let user = getAllUsers().first(where: { $0.email == lastEmail }) else {
            completion(false)
            return
        }
        
        BiometricAuthManager.shared.authenticateUser { success, error in
            if success {
                self.currentUser = user
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func addPoints(_ amount: Int, for action: String) {
        guard var user = currentUser else { return }
        user.points += amount
        
        // Check for achievements based on points
        checkPointsAchievements(user.points)
        
        // Check for specific action achievements
        checkActionAchievements(action)
        
        currentUser = user
    }
    
    private func checkPointsAchievements(_ totalPoints: Int) {
        guard var user = currentUser else { return }
        
        // Points milestones
        let pointsAchievements = [
            (100, "First Milestone", "Earned 100 points!", "star.fill"),
            (500, "Halfway There", "Earned 500 points!", "star.circle.fill"),
            (1000, "Point Master", "Earned 1000 points!", "star.square.fill")
        ]
        
        for (points, title, description, icon) in pointsAchievements {
            if totalPoints >= points && !user.achievements.contains(where: { $0.title == title }) {
                user.achievements.append(User.Achievement(
                    title: title,
                    description: description,
                    icon: icon,
                    dateEarned: Date(),
                    isUnlocked: true
                ))
            }
        }
        
        currentUser = user
    }
    
    private func checkActionAchievements(_ action: String) {
        guard var user = currentUser else { return }
        
        // Action-specific achievements
        switch action {
        case "photobooth":
            if !user.achievements.contains(where: { $0.title == "Photobooth Pro" }) {
                user.achievements.append(User.Achievement(
                    title: "Photobooth Pro",
                    description: "Used the photobooth feature!",
                    icon: "camera.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
            }
        case "trivia":
            if !user.achievements.contains(where: { $0.title == "Trivia Master" }) {
                user.achievements.append(User.Achievement(
                    title: "Trivia Master",
                    description: "Played Singapore Trivia!",
                    icon: "questionmark.circle.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
            }
        case "explore":
            if !user.achievements.contains(where: { $0.title == "Culture Explorer" }) {
                user.achievements.append(User.Achievement(
                    title: "Culture Explorer",
                    description: "Explored Singapore's culture!",
                    icon: "map.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
            }
        case "timeline":
            if !user.achievements.contains(where: { $0.title == "History Buff" }) {
                user.achievements.append(User.Achievement(
                    title: "History Buff",
                    description: "Explored Singapore's history!",
                    icon: "book.fill",
                    dateEarned: Date(),
                    isUnlocked: true
                ))
            }
        default:
            break
        }
        
        currentUser = user
    }
    
    private func getAllPossibleAchievements() -> [User.Achievement] {
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
            ("Photobooth Pro", "Used the photobooth feature!", "camera.fill"),
            ("Trivia Master", "Played Singapore Trivia!", "questionmark.circle.fill"),
            ("Culture Explorer", "Explored Singapore's culture!", "map.fill"),
            ("History Buff", "Explored Singapore's history!", "book.fill")
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
    
    func getAllAchievements() -> [User.Achievement] {
        guard let user = currentUser else { return getAllPossibleAchievements() }
        
        let allPossible = getAllPossibleAchievements()
        return allPossible.map { possible in
            if let unlocked = user.achievements.first(where: { $0.title == possible.title }) {
                return unlocked
            }
            return possible
        }
    }
} 