import Foundation

@Observable
final class FeedbackService {
    var isSubmitting = false
    var showSuccess = false
    var errorMessage: String?

    private let backendURL: String

    init(backendURL: String) {
        self.backendURL = backendURL
    }

    func submitFeedback(topic: String?, name: String?, email: String, message: String) async {
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        struct FeedbackRequest: Codable {
            let topic: String?
            let name: String?
            let email: String
            let message: String
        }

        let request = FeedbackRequest(topic: topic, name: name, email: email, message: message)

        guard let url = URL(string: backendURL) else {
            errorMessage = "Invalid server URL"
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)

        do {
            let (_, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                showSuccess = true
            } else {
                errorMessage = "Server error. Please try again."
            }
        } catch {
            errorMessage = "Network error. Please check your connection."
        }
    }
}
