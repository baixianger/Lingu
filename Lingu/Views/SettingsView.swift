import SwiftUI

// MARK: - General Tab

struct GeneralSettingsTab: View {
    @ObservedObject var viewModel: TranslatorViewModel
    @State private var selectedProviderLocal: TranslationProvider = .google

    var body: some View {
        Form {
            Picker("Provider", selection: $selectedProviderLocal) {
                ForEach(TranslationProvider.allCases) { provider in
                    Text(provider.rawValue).tag(provider)
                }
            }
            .onChange(of: selectedProviderLocal) { newValue in
                viewModel.selectedProvider = newValue.rawValue
            }

            Stepper(
                "Number of Panels: \(viewModel.panelCount)",
                value: Binding(
                    get: { viewModel.panelCount },
                    set: { viewModel.setPanelCount($0) }
                ),
                in: 2...3
            )

            Picker("Layout", selection: $viewModel.horizontalLayout) {
                Text("Vertical").tag(false)
                Text("Horizontal").tag(true)
            }
            .pickerStyle(.segmented)

            Divider()

            ForEach(Array(viewModel.panels.enumerated()), id: \.element.id) { index, _ in
                Picker("Panel \(index + 1)", selection: Binding(
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
        .formStyle(.grouped)
        .frame(width: 380)
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
        Form {
            Section {
                apiKeyField(
                    key: $googleAPIKey,
                    showKey: $showGoogleKey,
                    onSave: { KeychainHelper.setAPIKey($0, for: .google) }
                )
            } header: {
                Label("Google Translate", systemImage: "g.circle")
            } footer: {
                Text("Get a key from [Google Cloud Console](https://console.cloud.google.com/apis/credentials)")
            }

            Section {
                apiKeyField(
                    key: $deepLAPIKey,
                    showKey: $showDeepLKey,
                    onSave: { KeychainHelper.setAPIKey($0, for: .deepL) }
                )

                Toggle("Use Free API (api-free.deepl.com)", isOn: $deepLUseFreeAPI)
                    .onChange(of: deepLUseFreeAPI) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "deepLUseFreeAPI")
                    }
            } header: {
                Label("DeepL", systemImage: "d.circle")
            } footer: {
                Text("Free keys end with \":fx\". Get one at [deepl.com/pro-api](https://www.deepl.com/pro-api)")
            }
        }
        .formStyle(.grouped)
        .frame(width: 380)
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
