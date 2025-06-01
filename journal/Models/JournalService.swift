import Foundation

struct SupabaseJournalEntry: Codable {
    let id: String?
    let user_id: String
    let title: String
    let content: String
    let mood: String
    let prompt: String?
    let created_at: String?
}

final class JournalService {
    private let supabaseUrl = URL(string: "https://jthhvjlqhryhocnbwqff.supabase.co/rest/v1/journal_entries")!
    private let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0aGh2amxxaHJ5aG9jbmJ3cWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3NDYyMjQsImV4cCI6MjA2NDMyMjIyNH0.VaHcP4KgZUeCe7gaoi6lAybku3x-o6fSJS7fKBhFql0"
    
    // Upload a journal entry
    func uploadEntry(_ entry: JournalEntry) async throws {
        guard let userId = SupabaseManager.shared.userId, let accessToken = SupabaseManager.shared.accessToken else {
            throw NSError(domain: "No user session", code: 401)
        }
        var request = URLRequest(url: supabaseUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(anonKey)", forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let supabaseEntry = SupabaseJournalEntry(
            id: nil,
            user_id: userId,
            title: entry.title,
            content: entry.content,
            mood: entry.mood,
            prompt: entry.prompt?.shortTitle,
            created_at: nil
        )
        request.httpBody = try JSONEncoder().encode([supabaseEntry])
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw NSError(domain: "Upload failed", code: 500)
        }
    }
    
    // Fetch all entries for the current user
    func fetchEntries() async throws -> [JournalEntry] {
        guard let userId = SupabaseManager.shared.userId, let accessToken = SupabaseManager.shared.accessToken else {
            throw NSError(domain: "No user session", code: 401)
        }
        var components = URLComponents(url: supabaseUrl, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            URLQueryItem(name: "order", value: "created_at.desc")
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(anonKey)", forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fetch failed", code: 500)
        }
        let supabaseEntries = try JSONDecoder().decode([SupabaseJournalEntry].self, from: data)
        return supabaseEntries.map { supabase in
            JournalEntry(
                date: ISO8601DateFormatter().date(from: supabase.created_at ?? "") ?? Date(),
                title: supabase.title,
                content: supabase.content,
                mood: supabase.mood,
                prompt: supabase.prompt.map { ReflectionPrompt(shortTitle: $0, fullPrompt: $0) }
            )
        }
    }

    // TEST: Post a hardcoded entry
    func testPostEntryToSupabase() async {
        let userId = SupabaseManager.shared.userId
        let accessToken = SupabaseManager.shared.accessToken
        if let userId = userId, let accessToken = accessToken {
            print("[TEST] Logged in as user: \(userId)")
        } else {
            print("[TEST] No user session available. Please sign in or sign up first.")
            return
        }
        var request = URLRequest(url: supabaseUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(anonKey)", forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        let testEntry = SupabaseJournalEntry(
            id: nil,
            user_id: userId!,
            title: "test title",
            content: "test content",
            mood: "neutral",
            prompt: "test prompt",
            created_at: nil
        )
        do {
            request.httpBody = try JSONEncoder().encode([testEntry])
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("[TEST] POST status: \(httpResponse.statusCode)")
                if let body = String(data: data, encoding: .utf8) {
                    print("[TEST] POST response body: \(body)")
                }
                if httpResponse.statusCode == 201 {
                    print("[TEST] Upload succeeded!")
                }
            }
        } catch {
            print("[TEST] POST error: \(error)")
        }
    }

    // TEST: Fetch 5 most recent entries
    func testFetchRecentEntries() async {
        guard let userId = SupabaseManager.shared.userId, let accessToken = SupabaseManager.shared.accessToken else {
            print("[TEST] No user session available.")
            return
        }
        var components = URLComponents(url: supabaseUrl, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "user_id", value: "eq.\(userId)"),
            URLQueryItem(name: "order", value: "created_at.desc"),
            URLQueryItem(name: "limit", value: "5")
        ]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(anonKey)", forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("[TEST] FETCH status: \(httpResponse.statusCode)")
            }
            let supabaseEntries = try JSONDecoder().decode([SupabaseJournalEntry].self, from: data)
            print("[TEST] Recent entries:")
            for entry in supabaseEntries {
                print("- \(entry.title)")
            }
        } catch {
            print("[TEST] FETCH error: \(error)")
        }
    }
} 