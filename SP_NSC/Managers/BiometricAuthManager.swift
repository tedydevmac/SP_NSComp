import LocalAuthentication

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    private let context = LAContext()
    
    private init() {}
    
    var biometricType: LABiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    var isBiometricAvailable: Bool {
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let reason = "Authenticate to sign in to your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
} 