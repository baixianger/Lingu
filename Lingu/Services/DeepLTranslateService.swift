import Foundation

final class DeepLTranslateService: TranslationService {
    private let apiKey: String
    private let useFreeAPI: Bool

    init(apiKey: String, useFreeAPI: Bool = true) {
        self.apiKey = apiKey
        self.useFreeAPI = useFreeAPI
    }

    private var baseURL: String {
        useFreeAPI
            ? "https://api-free.deepl.com/v2/translate"
            : "https://api.deepl.com/v2/translate"
    }

    func translate(text: String, from source: Language, to target: Language) async throws -> String {
        guard !apiKey.isEmpty else { throw TranslationError.missingAPIKey }

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "text": [text],
            "source_lang": source.deepLSourceCode,
            "target_lang": target.deepLTargetCode
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

        let decoded = try JSONDecoder().decode(DeepLTranslateResponse.self, from: data)
        guard let translation = decoded.translations.first else {
            throw TranslationError.invalidResponse
        }

        return translation.text
    }
}
