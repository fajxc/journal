import SwiftUI

struct SignInView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 36) {
                // Back button
                HStack {
                    Button(action: {
                        hasCompletedOnboarding = false
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Onboarding")
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.leading, 24)
                    Spacer()
                }
                .padding(.top, 16)
                
                Spacer()
                Text("Welcome back")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 8)
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .submitLabel(.next)
                        .autocorrectionDisabled()
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.08))
                        .foregroundColor(.white)
                        .cornerRadius(22)
                        .font(.system(size: 18))
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white.opacity(0.08))
                        .foregroundColor(.white)
                        .cornerRadius(22)
                        .font(.system(size: 18))
                }
                .padding(.horizontal, 24)
                VStack(spacing: 16) {
                    Button(action: signIn) {
                        Text("Sign In")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                    }
                    Button(action: signUp) {
                        Text("Create Account")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.13))
                            .cornerRadius(16)
                    }
                    Button(action: continueAsGuest) {
                        Text("Continue as Guest")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.13))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 24)
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                Spacer()
            }
            .padding(.vertical, 24)
            .padding(.bottom, 16)
            .animation(.easeInOut, value: errorMessage)
        }
    }
    
    private func signIn() {
        errorMessage = ""
        Task {
            do {
                try await SupabaseManager.shared.signIn(email: email, password: password)
                if let userId = SupabaseManager.shared.userId {
                    print("[AUTH] Logged in as: \(userId)")
                    isSignedIn = true
                } else {
                    errorMessage = "Failed to sign in. Please check your email or create a new account."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func signUp() {
        errorMessage = ""
        Task {
            do {
                try await SupabaseManager.shared.signUp(email: email, password: password)
                if let userId = SupabaseManager.shared.userId {
                    print("[AUTH] Created user: \(userId)")
                    isSignedIn = true
                } else {
                    errorMessage = "Failed to create account. Please try again."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func continueAsGuest() {
        errorMessage = ""
        Task {
            do {
                try await SupabaseManager.shared.signInAsGuest()
                if let userId = SupabaseManager.shared.userId {
                    print("[AUTH] Guest session started: \(userId)")
                    isGuestUser = true
                    isSignedIn = true
                } else {
                    errorMessage = "Failed to start guest session."
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    SignInView()
} 
