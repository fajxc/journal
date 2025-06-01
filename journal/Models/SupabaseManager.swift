import Foundation

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    private let projectUrl = URL(string: "https://jthhvjlqhryhocnbwqff.supabase.co")!
    private let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0aGh2amxxaHJ5aG9jbmJ3cWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3NDYyMjQsImV4cCI6MjA2NDMyMjIyNH0.VaHcP4KgZUeCe7gaoi6lAybku3x-o6fSJS7fKBhFql0"
    
    private(set) var accessToken: String?
    private(set) var userId: String?
    
    private init() {}
    
    // MARK: - Auth
    
    struct AuthResponse: Codable {
        let access_token: String?
        let user: User?
    }
    
    struct User: Codable {
        let id: String
        let email: String?
    }
    
    struct SignUpResponse: Codable {
        let id: String?
        let email: String?
        let access_token: String?
    }
    
    // Sign up
    func signUp(email: String, password: String) async throws {
        print("[AUTH DEBUG] Attempting signUp with: email=\(email), password=\(password)")
        let url = projectUrl.appendingPathComponent("auth/v1/signup")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(anonKey, forHTTPHeaderField: "apikey")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)
        print("[AUTH DEBUG] Request headers: \(request.allHTTPHeaderFields ?? [:])")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(SignUpResponse.self, from: data)
            print("[AUTH DEBUG] signUp response: \(String(data: data, encoding: .utf8) ?? "nil")")
            print("[AUTH DEBUG] user id: \(String(describing: response.id))")
            print("[AUTH DEBUG] access_token: \(String(describing: response.access_token))")
            self.userId = response.id
            self.accessToken = response.access_token
            if self.userId == nil {
                print("[AUTH ERROR] No user ID returned after signUp. Not proceeding.")
                return
            }
        } catch {
            print("[AUTH ERROR] signUp error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Sign in
    func signIn(email: String, password: String) async throws {
        print("[AUTH DEBUG] Attempting signIn with: email=\(email), password=\(password)")
        let url = projectUrl.appendingPathComponent("auth/v1/token?grant_type=password")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(anonKey, forHTTPHeaderField: "apikey")
        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)
        print("[AUTH DEBUG] Request headers: \(request.allHTTPHeaderFields ?? [:])")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(AuthResponse.self, from: data)
            print("[AUTH DEBUG] signIn response: \(String(data: data, encoding: .utf8) ?? "nil")")
            print("[AUTH DEBUG] user: \(String(describing: response.user))")
            print("[AUTH DEBUG] access_token: \(String(describing: response.access_token))")
            self.accessToken = response.access_token
            self.userId = response.user?.id
            if self.userId == nil {
                print("[AUTH ERROR] No user ID returned after signIn. Not proceeding.")
                return
            }
            if self.accessToken == nil {
                print("[AUTH ERROR] No session/access token returned after signIn. Not proceeding.")
                return
            }
        } catch {
            print("[AUTH ERROR] signIn error: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Guest login (anonymous)
    func signInAsGuest() async throws {
        let email = "guest+\(UUID().uuidString.prefix(6))@example.com"
        let password = UUID().uuidString
        print("[AUTH DEBUG] Attempting guest signUp with: email=\(email), password=\(password)")
        do {
            try await signUp(email: email, password: password)
            if let userId = self.userId, let accessToken = self.accessToken {
                print("[AUTH] Guest sign up succeeded: \(userId)")
            } else {
                print("[AUTH ERROR] No user ID or session returned after guest signUp. Not proceeding.")
            }
        } catch {
            print("[AUTH ERROR] Guest signUp error: \(error.localizedDescription)")
            throw error
        }
    }
} 