import SwiftUI

struct SignInView: View {
    @AppStorage("isSignedIn") private var isSignedIn = false
    @AppStorage("isGuestUser") private var isGuestUser = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var email = ""
    @State private var password = ""
    
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
                
                Button(action: continueAsGuest) {
                    Text("continue as guest")
                        .font(Theme.bodyStyle)
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.buttonStyle())
                        .cornerRadius(Theme.cornerRadius)
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
        // TODO: Implement actual sign in logic
        isSignedIn = true
    }
    
    private func continueAsGuest() {
        isGuestUser = true
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
