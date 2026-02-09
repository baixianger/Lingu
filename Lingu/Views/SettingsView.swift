import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TranslatorViewModel

    @State private var googleAPIKey = ""
    @State private var deepLAPIKey = ""
    @State private var showGoogleKey = false
    @State private var showDeepLKey = false
    @State private var selectedProviderLocal: TranslationProvider = .google
    @State private var deepLUseFreeAPI = true

    var body: some View {
        Form {
            Section("Translation") {
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
            }

            Section("Languages") {
                ForEach(viewModel.panels.indices, id: \.self) { index in
                    Picker("Panel \(index + 1)", selection: Binding(
                        get: { viewModel.panels[index].language },
                        set: { viewModel.updateLanguage(at: index, to: $0) }
                    )) {
                        ForEach(Language.all) { lang in
                            Text("\(lang.nativeName) (\(lang.name))").tag(lang)
                        }
                    }
                }
            }

            Section {
                apiKeyField(
                    key: $googleAPIKey,
                    showKey: $showGoogleKey,
                    onSave: { KeychainHelper.setAPIKey($0, for: .google) }
                )
            } header: {
                Label("Google Translate", systemImage: "g.circle")
            } footer: {
                Text("Get a key from Google Cloud Console → APIs & Services → Credentials")
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
                Text("Free keys end with \":fx\". Get one at deepl.com/pro-api")
            }
        }
        .formStyle(.grouped)
        .onAppear {
            googleAPIKey = KeychainHelper.apiKey(for: .google)
            deepLAPIKey = KeychainHelper.apiKey(for: .deepL)
            selectedProviderLocal = viewModel.provider
            deepLUseFreeAPI = UserDefaults.standard.object(forKey: "deepLUseFreeAPI") as? Bool ?? true
        }
    }

    // MARK: - API Key Field

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
