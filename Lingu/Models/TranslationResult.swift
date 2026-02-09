import Foundation

// MARK: - Google Translate API v2 Response

struct GoogleTranslateResponse: Codable {
    let data: GoogleTranslateData
}

struct GoogleTranslateData: Codable {
    let translations: [GoogleTranslation]
}

struct GoogleTranslation: Codable {
    let translatedText: String
    let detectedSourceLanguage: String?
}

// MARK: - DeepL API v2 Response

struct DeepLTranslateResponse: Codable {
    let translations: [DeepLTranslation]
}

struct DeepLTranslation: Codable {
    let detectedSourceLanguage: String?
    let text: String

    enum CodingKeys: String, CodingKey {
        case detectedSourceLanguage = "detected_source_language"
        case text
    }
}
