import Foundation

struct Language: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let nativeName: String
    let googleCode: String
    let deepLCode: String

    static let all: [Language] = [
        Language(id: "en", name: "English", nativeName: "English", googleCode: "en", deepLCode: "EN"),
        Language(id: "zh", name: "Chinese", nativeName: "中文", googleCode: "zh-CN", deepLCode: "ZH-HANS"),
        Language(id: "ja", name: "Japanese", nativeName: "日本語", googleCode: "ja", deepLCode: "JA"),
        Language(id: "ko", name: "Korean", nativeName: "한국어", googleCode: "ko", deepLCode: "KO"),
        Language(id: "fr", name: "French", nativeName: "Français", googleCode: "fr", deepLCode: "FR"),
        Language(id: "de", name: "German", nativeName: "Deutsch", googleCode: "de", deepLCode: "DE"),
        Language(id: "es", name: "Spanish", nativeName: "Español", googleCode: "es", deepLCode: "ES"),
        Language(id: "pt", name: "Portuguese", nativeName: "Português", googleCode: "pt", deepLCode: "PT-BR"),
        Language(id: "ru", name: "Russian", nativeName: "Русский", googleCode: "ru", deepLCode: "RU"),
        Language(id: "it", name: "Italian", nativeName: "Italiano", googleCode: "it", deepLCode: "IT"),
        Language(id: "nl", name: "Dutch", nativeName: "Nederlands", googleCode: "nl", deepLCode: "NL"),
        Language(id: "pl", name: "Polish", nativeName: "Polski", googleCode: "pl", deepLCode: "PL"),
    ]

    static func find(byId id: String) -> Language? {
        all.first { $0.id == id }
    }
}
