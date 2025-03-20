import SwiftUI

struct SignupView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSignupSuccessful = false
    
    let singaporeRed = Color(hex: "#ED1C24")
    let singaporeWhite = Color.white
    
    var body: some View {
        NavigationStack{
            ZStack {
            // Background pattern
            Color(hex: "#F8F8F8")
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 10) {
                    Image("SG60-normal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("Join SG60")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(singaporeRed)
                    
                    Text("Create your account to start your journey")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                // Signup Form
                VStack(spacing: 20) {
                    CustomTextField(text: $username, placeholder: "Username", icon: "person.fill")
                    CustomTextField(text: $email, placeholder: "Email", icon: "envelope.fill")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    CustomSecureField(text: $password, placeholder: "Password", icon: "lock.fill")
                    CustomSecureField(text: $confirmPassword, placeholder: "Confirm Password", icon: "lock.fill")
                }
                .padding(.horizontal, 30)
                
                // Signup Button
                Button(action: handleSignup) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(singaporeWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(singaporeRed)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Login Link
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .foregroundColor(singaporeRed)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .alert("Signup Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .navigationDestination(isPresented: $isSignupSuccessful) {
            ContentView().navigationBarBackButtonHidden(true)
        }
    }
}
    private func handleSignup() {
        // Basic validation
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        if password != confirmPassword {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        // Create user account
        userManager.signUp(username: username, email: email, password: password)
        
        // Verify the user was created successfully
        if userManager.currentUser != nil {
            isSignupSuccessful = true
        } else {
            alertMessage = "Failed to create account. Please try again."
            showAlert = true
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#ED1C24"))
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "#ED1C24"))
                .frame(width: 20)
            
            SecureField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    NavigationStack {
        SignupView()
    }
} 
