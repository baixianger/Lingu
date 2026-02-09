import Foundation

enum TranslationProvider: String, CaseIterable, Identifiable {
    case google = "Google Translate"
    case deepL = "DeepL"

    var id: String { rawValue }
}

enum TranslationError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case apiError(String)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key not configured. Open Settings to add one."
        case .invalidResponse:
            return "Invalid response from translation service."
        case .apiError(let message):
            return "API error: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

protocol TranslationService {
    func translate(text: String, from sourceLanguage: Language, to targetLanguage: Language) async throws -> String
}
