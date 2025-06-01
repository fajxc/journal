import SwiftUI

struct SignInView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(spacing: 25) {
                Text("welcome back")
                    .font(Theme.headerStyle)
                    .foregroundColor(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, Theme.screenPadding)
                
                VStack(spacing: 15) {
                    TextField("email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textContentType(.password)
                }
                
                Button(action: signIn) {
                    Text("sign in")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.buttonStyle(isProminent: true))
                        .cornerRadius(Theme.cornerRadius)
                }
                
                Button(action: signUp) {
                    Text("create account")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.cardBackground)
                        .cornerRadius(Theme.cornerRadius)
                }
                
                Button(action: continueAsGuest) {
                    Text("continue as guest")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.buttonStyle())
                        .cornerRadius(Theme.cornerRadius)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding(Theme.screenPadding)
            
            Button(action: { hasCompletedOnboarding = false }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Theme.textSecondary)
                    .imageScale(.large)
                    .padding(20)
            }
        }
        .background(Theme.backgroundColor)
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

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .foregroundColor(Theme.textPrimary)
    }
}

#Preview {
    SignInView()
} 
