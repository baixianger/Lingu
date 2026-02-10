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
        Language(id: "zh-TW", name: "Chinese (Traditional)", nativeName: "繁體中文", googleCode: "zh-TW", deepLSourceCode: "ZH", deepLTargetCode: "ZH-HANT"),
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
        Language(id: "ar", name: "Arabic", nativeName: "العربية", googleCode: "ar", deepLSourceCode: "AR", deepLTargetCode: "AR"),
        Language(id: "tr", name: "Turkish", nativeName: "Türkçe", googleCode: "tr", deepLSourceCode: "TR", deepLTargetCode: "TR"),
        Language(id: "sv", name: "Swedish", nativeName: "Svenska", googleCode: "sv", deepLSourceCode: "SV", deepLTargetCode: "SV"),
        Language(id: "da", name: "Danish", nativeName: "Dansk", googleCode: "da", deepLSourceCode: "DA", deepLTargetCode: "DA"),
        Language(id: "fi", name: "Finnish", nativeName: "Suomi", googleCode: "fi", deepLSourceCode: "FI", deepLTargetCode: "FI"),
        Language(id: "el", name: "Greek", nativeName: "Ελληνικά", googleCode: "el", deepLSourceCode: "EL", deepLTargetCode: "EL"),
        Language(id: "cs", name: "Czech", nativeName: "Čeština", googleCode: "cs", deepLSourceCode: "CS", deepLTargetCode: "CS"),
        Language(id: "ro", name: "Romanian", nativeName: "Română", googleCode: "ro", deepLSourceCode: "RO", deepLTargetCode: "RO"),
        Language(id: "hu", name: "Hungarian", nativeName: "Magyar", googleCode: "hu", deepLSourceCode: "HU", deepLTargetCode: "HU"),
        Language(id: "uk", name: "Ukrainian", nativeName: "Українська", googleCode: "uk", deepLSourceCode: "UK", deepLTargetCode: "UK"),
        Language(id: "id", name: "Indonesian", nativeName: "Bahasa Indonesia", googleCode: "id", deepLSourceCode: "ID", deepLTargetCode: "ID"),
        Language(id: "vi", name: "Vietnamese", nativeName: "Tiếng Việt", googleCode: "vi", deepLSourceCode: "VI", deepLTargetCode: "VI"),
        Language(id: "th", name: "Thai", nativeName: "ไทย", googleCode: "th", deepLSourceCode: "TH", deepLTargetCode: "TH"),
        Language(id: "hi", name: "Hindi", nativeName: "हिन्दी", googleCode: "hi", deepLSourceCode: "HI", deepLTargetCode: "HI"),
        Language(id: "nb", name: "Norwegian", nativeName: "Norsk", googleCode: "no", deepLSourceCode: "NB", deepLTargetCode: "NB"),
        Language(id: "bg", name: "Bulgarian", nativeName: "Български", googleCode: "bg", deepLSourceCode: "BG", deepLTargetCode: "BG"),
        Language(id: "sk", name: "Slovak", nativeName: "Slovenčina", googleCode: "sk", deepLSourceCode: "SK", deepLTargetCode: "SK"),
        Language(id: "et", name: "Estonian", nativeName: "Eesti", googleCode: "et", deepLSourceCode: "ET", deepLTargetCode: "ET"),
        Language(id: "lv", name: "Latvian", nativeName: "Latviešu", googleCode: "lv", deepLSourceCode: "LV", deepLTargetCode: "LV"),
        Language(id: "lt", name: "Lithuanian", nativeName: "Lietuvių", googleCode: "lt", deepLSourceCode: "LT", deepLTargetCode: "LT"),
        Language(id: "sl", name: "Slovenian", nativeName: "Slovenščina", googleCode: "sl", deepLSourceCode: "SL", deepLTargetCode: "SL"),
    ]

    static func find(byId id: String) -> Language? {
        all.first { $0.id == id }
    }
}
