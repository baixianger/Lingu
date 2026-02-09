import Foundation

final class GoogleTranslateService: TranslationService {
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func translate(text: String, from source: Language, to target: Language) async throws -> String {
        guard !apiKey.isEmpty else { throw TranslationError.missingAPIKey }

        var components = URLComponents(string: "https://translation.googleapis.com/language/translate/v2")!
        components.queryItems = [URLQueryItem(name: "key", value: apiKey)]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "q": text,
            "source": source.googleCode,
            "target": target.googleCode,
            "format": "text"
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranslationError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw TranslationError.apiError("HTTP \(httpResponse.statusCode): \(errorBody)")
        }

        let decoded = try JSONDecoder().decode(GoogleTranslateResponse.self, from: data)
        guard let translation = decoded.data.translations.first else {
            throw TranslationError.invalidResponse
        }

        return translation.translatedText
    }
}
