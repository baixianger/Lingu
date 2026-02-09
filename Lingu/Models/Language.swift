import Foundation

struct Language: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let nativeName: String
    let googleCode: String
    let deepLSourceCode: String
    let deepLTargetCode: String

    static let all: [Language] = [
        Language(id: "en", name: "English", nativeName: "English", googleCode: "en", deepLSourceCode: "EN", deepLTargetCode: "EN-US"),
        Language(id: "zh", name: "Chinese", nativeName: "中文", googleCode: "zh-CN", deepLSourceCode: "ZH", deepLTargetCode: "ZH-HANS"),
        Language(id: "ja", name: "Japanese", nativeName: "日本語", googleCode: "ja", deepLSourceCode: "JA", deepLTargetCode: "JA"),
        Language(id: "ko", name: "Korean", nativeName: "한국어", googleCode: "ko", deepLSourceCode: "KO", deepLTargetCode: "KO"),
        Language(id: "fr", name: "French", nativeName: "Français", googleCode: "fr", deepLSourceCode: "FR", deepLTargetCode: "FR"),
        Language(id: "de", name: "German", nativeName: "Deutsch", googleCode: "de", deepLSourceCode: "DE", deepLTargetCode: "DE"),
        Language(id: "es", name: "Spanish", nativeName: "Español", googleCode: "es", deepLSourceCode: "ES", deepLTargetCode: "ES"),
        Language(id: "pt", name: "Portuguese", nativeName: "Português", googleCode: "pt", deepLSourceCode: "PT", deepLTargetCode: "PT-BR"),
        Language(id: "ru", name: "Russian", nativeName: "Русский", googleCode: "ru", deepLSourceCode: "RU", deepLTargetCode: "RU"),
        Language(id: "it", name: "Italian", nativeName: "Italiano", googleCode: "it", deepLSourceCode: "IT", deepLTargetCode: "IT"),
        Language(id: "nl", name: "Dutch", nativeName: "Nederlands", googleCode: "nl", deepLSourceCode: "NL", deepLTargetCode: "NL"),
        Language(id: "pl", name: "Polish", nativeName: "Polski", googleCode: "pl", deepLSourceCode: "PL", deepLTargetCode: "PL"),
    ]

    static func find(byId id: String) -> Language? {
        all.first { $0.id == id }
    }
}
