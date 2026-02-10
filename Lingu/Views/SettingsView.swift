import SwiftUI

// MARK: - General Tab

struct GeneralSettingsTab: View {
    @ObservedObject var viewModel: TranslatorViewModel
    @State private var selectedProviderLocal: TranslationProvider = .google

    var body: some View {
        Form {
            Picker("Provider:", selection: $selectedProviderLocal) {
                ForEach(TranslationProvider.allCases) { provider in
                    Text(provider.rawValue).tag(provider)
                }
            }
            .onChange(of: selectedProviderLocal) { newValue in
                viewModel.selectedProvider = newValue.rawValue
            }

            LabeledContent("Panels:") {
                HStack(spacing: 6) {
                    Stepper("", value: Binding(
                        get: { viewModel.panelCount },
                        set: { viewModel.setPanelCount($0) }
                    ), in: 2...3)
                    .labelsHidden()
                    Text("\(viewModel.panelCount)")
                        .monospacedDigit()
                }
            }

            Picker("Layout:", selection: $viewModel.horizontalLayout) {
                Text("Vertical").tag(false)
                Text("Horizontal").tag(true)
            }

            Toggle("Auto-paste from clipboard", isOn: $viewModel.autoPasteEnabled)

            Divider()

            ForEach(Array(viewModel.panels.enumerated()), id: \.element.id) { index, _ in
                Picker("Panel \(index + 1):", selection: Binding(
                    get: {
                        guard index < viewModel.panels.count else { return Language.all[0] }
                        return viewModel.panels[index].language
                    },
                    set: {
                        guard index < viewModel.panels.count else { return }
                        viewModel.updateLanguage(at: index, to: $0)
                    }
                )) {
                    ForEach(Language.all) { lang in
                        Text("\(lang.nativeName) (\(lang.name))").tag(lang)
                    }
                }
            }
        }
        .formStyle(.columns)
        .padding(20)
        .frame(width: 400)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            selectedProviderLocal = viewModel.provider
        }
    }
}

// MARK: - API Keys Tab

struct APIKeysSettingsTab: View {
    @ObservedObject var viewModel: TranslatorViewModel

    @State private var googleAPIKey = ""
    @State private var deepLAPIKey = ""
    @State private var showGoogleKey = false
    @State private var showDeepLKey = false
    @State private var deepLUseFreeAPI = true

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Google Translate
            VStack(alignment: .leading, spacing: 6) {
                Label("Google Translate", systemImage: "g.circle")
                    .font(.headline)

                apiKeyField(
                    key: $googleAPIKey,
                    showKey: $showGoogleKey,
                    onSave: { KeychainHelper.setAPIKey($0, for: .google) }
                )

                Text("Get a key from [Google Cloud Console](https://console.cloud.google.com/apis/credentials)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            // DeepL
            VStack(alignment: .leading, spacing: 6) {
                Label("DeepL", systemImage: "d.circle")
                    .font(.headline)

                apiKeyField(
                    key: $deepLAPIKey,
                    showKey: $showDeepLKey,
                    onSave: { KeychainHelper.setAPIKey($0, for: .deepL) }
                )

                Toggle("Use Free API (api-free.deepl.com)", isOn: $deepLUseFreeAPI)
                    .onChange(of: deepLUseFreeAPI) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "deepLUseFreeAPI")
                    }

                Text("Free keys end with \":fx\". Get one at [deepl.com/pro-api](https://www.deepl.com/pro-api)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(width: 400)
        .fixedSize(horizontal: false, vertical: true)
        .onAppear {
            googleAPIKey = KeychainHelper.apiKey(for: .google)
            deepLAPIKey = KeychainHelper.apiKey(for: .deepL)
            deepLUseFreeAPI = UserDefaults.standard.object(forKey: "deepLUseFreeAPI") as? Bool ?? true
        }
    }

    private func apiKeyField(
        key: Binding<String>,
        showKey: Binding<Bool>,
        onSave: @escaping (String) -> Void
    ) -> some View {
        HStack {
            Group {
                if showKey.wrappedValue {
                    TextField("API Key", text: key)
                } else {
                    SecureField("API Key", text: key)
                }
            }
            .textFieldStyle(.roundedBorder)
            .onChange(of: key.wrappedValue) { newValue in
                onSave(newValue)
            }

            Button {
                showKey.wrappedValue.toggle()
            } label: {
                Image(systemName: showKey.wrappedValue ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            .help(showKey.wrappedValue ? "Hide API key" : "Show API key")
        }
    }
}
