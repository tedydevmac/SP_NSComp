import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject private var userManager = UserManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoginSuccessful = false
    @State private var showBiometricButton = false
    
    let singaporeRed = Color(hex: "#ED1C24")
    let singaporeWhite = Color.white
    
    var body: some View {
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
                    
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(singaporeRed)
                    
                    Text("Sign in to continue your SG60 journey")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 40)
                
                // Login Form
                VStack(spacing: 20) {
                    CustomTextField(text: $email, placeholder: "Email", icon: "envelope.fill")
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    CustomSecureField(text: $password, placeholder: "Password", icon: "lock.fill")
                }
                .padding(.horizontal, 30)
                
                // Login Button
                Button(action: handleLogin) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(singaporeWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(singaporeRed)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                // Biometric Login Button
                if showBiometricButton {
                    Button(action: handleBiometricLogin) {
                        HStack {
                            Image(systemName: BiometricAuthManager.shared.biometricType == .faceID ? "faceid" : "touchid")
                                .font(.title2)
                            Text("Sign in with \(BiometricAuthManager.shared.biometricType == .faceID ? "Face ID" : "Touch ID")")
                                .font(.headline)
                        }
                        .foregroundColor(singaporeRed)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(singaporeRed.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                }
                
                // Sign Up Link
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignupView()) {
                        Text("Sign Up")
                            .foregroundColor(singaporeRed)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .alert("Login Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .navigationDestination(isPresented: $isLoginSuccessful) {
            ContentView().navigationBarBackButtonHidden(true)
        }
        .onAppear {
            checkBiometricAvailability()
        }
    }
    
    private func checkBiometricAvailability() {
        if BiometricAuthManager.shared.isBiometricAvailable && userManager.getLastUsedEmail() != nil {
            showBiometricButton = true
        }
    }
    
    private func handleLogin() {
        // Basic validation
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        // Attempt to login using UserManager
        if userManager.login(email: email, password: password) {
            isLoginSuccessful = true
        } else {
            alertMessage = "Invalid email or password"
            showAlert = true
        }
    }
    
    private func handleBiometricLogin() {
        userManager.loginWithBiometrics { success in
            if success {
                isLoginSuccessful = true
            } else {
                alertMessage = "Biometric authentication failed"
                showAlert = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
} 
