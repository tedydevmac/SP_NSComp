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
    private let achievementManager = AchievementManager()
    
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
            if (!allUsers.contains(where: { $0.email == user.email })) {
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
        achievementManager.checkPointsAchievements(for: &user)
        
        // Check for specific action achievements
        achievementManager.checkActionAchievements(for: &user, action: action)
        
        currentUser = user
    }
    
    func getAllAchievements() -> [User.Achievement] {
        guard let user = currentUser else { return achievementManager.getAllPossibleAchievements() }
        
        return achievementManager.getAllAchievements(for: user)
    }
}