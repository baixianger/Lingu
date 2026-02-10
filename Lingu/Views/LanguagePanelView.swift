import SwiftUI

struct LanguagePanelView: View {
    let panelIndex: Int
    @ObservedObject var viewModel: TranslatorViewModel
    var isHorizontal: Bool = false
    @State private var isHovering = false
    @FocusState private var isFocused: Bool

    private var panel: LanguagePanel {
        guard panelIndex < viewModel.panels.count else {
            return LanguagePanel(language: Language.all[0])
        }
        return viewModel.panels[panelIndex]
    }

    private var isSource: Bool {
        viewModel.activeSourceIndex == panelIndex
    }

    private var isTarget: Bool {
        viewModel.activeSourceIndex != nil && !isSource
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Language selector header
            HStack {
                Picker("", selection: Binding(
                    get: { panel.language },
                    set: { viewModel.updateLanguage(at: panelIndex, to: $0) }
                )) {
                    ForEach(Language.all) { lang in
                        if isHorizontal {
                            Text(lang.nativeName)
                                .tag(lang)
                        } else {
                            Text("\(lang.nativeName) (\(lang.name))")
                                .tag(lang)
                        }
                    }
                }
                .labelsHidden()
                .frame(maxWidth: isHorizontal ? 120 : 180)
                .pickerStyle(.menu)

                Spacer()

                if panel.isLoading {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 16, height: 16)
                }

                Button(action: { viewModel.copyText(at: panelIndex) }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderless)
                .help("Copy to clipboard")
                .opacity(isHovering && !panel.text.isEmpty ? 1 : 0)
            }

            // Text area
            ZStack(alignment: .topLeading) {
                if panel.text.isEmpty && !isFocused {
                    Text("Type to translate...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }

                TextEditor(text: Binding(
                    get: { panel.text },
                    set: { viewModel.textDidChange(panelIndex: panelIndex, newText: $0) }
                ))
                .font(.system(size: 14))
                .foregroundColor(isTarget ? .secondary : .primary)
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .frame(minHeight: isHorizontal ? 120 : 60, maxHeight: isHorizontal ? .infinity : 100)
            }
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isFocused ? Color.accentColor.opacity(0.05) : Color(nsColor: .controlBackgroundColor))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isFocused ? Color.accentColor.opacity(0.5) : Color(nsColor: .separatorColor), lineWidth: 1)
            )
        }
        .padding(.horizontal, isHorizontal ? 8 : 12)
        .padding(.vertical, 4)
        .onHover { isHovering = $0 }
    }
}
