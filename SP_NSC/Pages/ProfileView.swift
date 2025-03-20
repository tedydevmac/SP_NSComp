import SwiftUI

struct ProfileView: View {
    @StateObject private var userManager = UserManager.shared
    @Environment(\.dismiss) private var dismiss
    
    let singaporeRed = Color(hex: "#ED1C24")
    let singaporeWhite = Color.white
    
    var body: some View {
        ScrollView {
            if let user = userManager.currentUser {
                VStack(spacing: 25) {
                    // Profile Header
                    VStack(spacing: 15) {
                        Image("SG60-normal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(singaporeRed, lineWidth: 3))
                        
                        Text(user.username)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Points Card
                    VStack(spacing: 10) {
                        Text("Your Points")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("\(user.points)")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(singaporeRed)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(singaporeWhite)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Achievements Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Achievements")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(user.achievements) { achievement in
                            AchievementRow(achievement: achievement, singaporeRed: singaporeRed)
                        }
                    }
                    .padding(.top, 20)
                    
                    // Sign Out Button
                    Button(action: {
                        userManager.signOut()
                        dismiss()
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(singaporeWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(singaporeRed)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                }
            } else {
                VStack(spacing: 20) {
                    Text("Please sign in to view your profile")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(singaporeWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(singaporeRed)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 40)
            }
        }
        .background(Color(hex: "#F8F8F8"))
        .navigationTitle("Profile")
    }
}

struct AchievementRow: View {
    let achievement: User.Achievement
    let singaporeRed: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.isUnlocked ? singaporeRed : .gray)
                .frame(width: 40, height: 40)
                .background(achievement.isUnlocked ? singaporeRed.opacity(0.1) : Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(achievement.isUnlocked ? .primary : .gray)
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(singaporeRed)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
} 