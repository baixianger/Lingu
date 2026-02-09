import Foundation
import Combine
import SwiftUI

struct LanguagePanel: Identifiable {
    let id = UUID()
    var language: Language
    var text: String = ""
    var isLoading: Bool = false
}

@MainActor
final class TranslatorViewModel: ObservableObject {
    @Published var panels: [LanguagePanel] = []
    @Published var activeSourceIndex: Int? = nil
    @Published var error: String? = nil

    @AppStorage("selectedProvider") var selectedProvider: String = TranslationProvider.google.rawValue
    @AppStorage("panelCount") var panelCount: Int = 3
    @AppStorage("languageIds") var languageIdsStorage: String = "en,zh,ja"
    @AppStorage("horizontalLayout") var horizontalLayout: Bool = false

    private var inputSubject = PassthroughSubject<(index: Int, text: String), Never>()
    private var cancellables = Set<AnyCancellable>()
    private var translationTask: Task<Void, Never>?

    var provider: TranslationProvider {
        TranslationProvider(rawValue: selectedProvider) ?? .google
    }

    var languageIds: [String] {
        get { languageIdsStorage.split(separator: ",").map(String.init) }
        set { languageIdsStorage = newValue.joined(separator: ",") }
    }

    init() {
        setupPanels()
        setupDebounce()
    }

    func setupPanels() {
        let ids = languageIds
        panels = ids.compactMap { id in
            guard let lang = Language.find(byId: id) else { return nil }
            return LanguagePanel(language: lang)
        }
        // Ensure we have at least 2 panels
        if panels.count < 2 {
            panels = [
                LanguagePanel(language: Language.all[0]),
                LanguagePanel(language: Language.all[1]),
            ]
            languageIds = panels.map(\.language.id)
        }
    }

    private func setupDebounce() {
        inputSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] index, text in
                self?.performTranslation(sourceIndex: index, text: text)
            }
            .store(in: &cancellables)
    }

    func textDidChange(panelIndex: Int, newText: String) {
        panels[panelIndex].text = newText
        activeSourceIndex = panelIndex
        error = nil

        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            translationTask?.cancel()
            for i in panels.indices where i != panelIndex {
                panels[i].text = ""
                panels[i].isLoading = false
            }
            return
        }

        inputSubject.send((index: panelIndex, text: newText))
    }

    private func performTranslation(sourceIndex: Int, text: String) {
        translationTask?.cancel()

        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let sourceLanguage = panels[sourceIndex].language

        // Mark target panels as loading
        for i in panels.indices where i != sourceIndex {
            panels[i].isLoading = true
        }

        translationTask = Task {
            let service = makeService()
            guard let service else {
                self.error = TranslationError.missingAPIKey.errorDescription
                for i in panels.indices where i != sourceIndex {
                    panels[i].isLoading = false
                }
                return
            }

            await withTaskGroup(of: (Int, String?).self) { group in
                for i in panels.indices where i != sourceIndex {
                    let targetLanguage = panels[i].language
                    let panelIndex = i
                    group.addTask {
                        do {
                            let result = try await service.translate(
                                text: trimmed,
                                from: sourceLanguage,
                                to: targetLanguage
                            )
                            return (panelIndex, result)
                        } catch {
                            return (panelIndex, nil)
                        }
                    }
                }

                for await (index, result) in group {
                    guard !Task.isCancelled else { return }
                    if let result {
                        panels[index].text = result
                    } else if error == nil {
                        self.error = "Translation failed for \(panels[index].language.name)"
                    }
                    panels[index].isLoading = false
                }
            }
        }
    }

    private func makeService() -> TranslationService? {
        let key = KeychainHelper.apiKey(for: provider)
        guard !key.isEmpty else { return nil }

        switch provider {
        case .google:
            return GoogleTranslateService(apiKey: key)
        case .deepL:
            let useFree = UserDefaults.standard.object(forKey: "deepLUseFreeAPI") as? Bool ?? true
            return DeepLTranslateService(apiKey: key, useFreeAPI: useFree)
        }
    }

    func onPopoverOpen() {
        if let clipboardText = ClipboardManager.read(),
           !clipboardText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Only auto-fill if all panels are empty
            let allEmpty = panels.allSatisfy { $0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            if allEmpty {
                textDidChange(panelIndex: 0, newText: clipboardText)
            }
        }
    }

    func copyText(at panelIndex: Int) {
        ClipboardManager.write(panels[panelIndex].text)
    }

    func clearAll() {
        translationTask?.cancel()
        for i in panels.indices {
            panels[i].text = ""
            panels[i].isLoading = false
        }
        activeSourceIndex = nil
        error = nil
    }

    func updateLanguage(at index: Int, to language: Language) {
        panels[index].language = language
        panels[index].text = ""
        languageIds = panels.map(\.language.id)

        // Re-translate if there's a source
        if let sourceIndex = activeSourceIndex, sourceIndex != index,
           !panels[sourceIndex].text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textDidChange(panelIndex: sourceIndex, newText: panels[sourceIndex].text)
        }
    }

    func setPanelCount(_ count: Int) {
        let clamped = max(2, min(3, count))
        panelCount = clamped

        var ids = languageIds
        if clamped > ids.count {
            // Add languages not already in use
            let usedIds = Set(ids)
            for lang in Language.all where !usedIds.contains(lang.id) {
                ids.append(lang.id)
                if ids.count >= clamped { break }
            }
        } else if clamped < ids.count {
            ids = Array(ids.prefix(clamped))
        }
        languageIds = ids
        setupPanels()
    }
}
