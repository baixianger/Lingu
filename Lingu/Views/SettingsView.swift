import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TranslatorViewModel

    @State private var googleAPIKey: String = ""
    @State private var deepLAPIKey: String = ""
    @State private var showGoogleKey: Bool = false
    @State private var showDeepLKey: Bool = false
    @State private var selectedProviderLocal: TranslationProvider = .google
    @State private var deepLUseFreeAPI: Bool = true

    var body: some View {
        TabView {
            generalTab
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }

            apiTab
                .tabItem {
                    Label("API Keys", systemImage: "key")
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            googleAPIKey = KeychainHelper.apiKey(for: .google)
            deepLAPIKey = KeychainHelper.apiKey(for: .deepL)
            selectedProviderLocal = viewModel.provider
            deepLUseFreeAPI = UserDefaults.standard.object(forKey: "deepLUseFreeAPI") as? Bool ?? true
        }
    }

    // MARK: - General Tab

    private var generalTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Provider section
            GroupBox {
                VStack(alignment: .leading, spacing: 10) {
                    Picker("Translation Provider", selection: $selectedProviderLocal) {
                        ForEach(TranslationProvider.allCases) { provider in
                            Text(provider.rawValue).tag(provider)
                        }
                    }
                    .onChange(of: selectedProviderLocal) { newValue in
                        viewModel.selectedProvider = newValue.rawValue
                    }

                    Stepper("Number of Panels: \(viewModel.panelCount)",
                            value: Binding(
                                get: { viewModel.panelCount },
                                set: { viewModel.setPanelCount($0) }
                            ),
                            in: 2...3)

                    Picker("Layout", selection: $viewModel.horizontalLayout) {
                        Label("Vertical", systemImage: "rectangle.split.1x2").tag(false)
                        Label("Horizontal", systemImage: "rectangle.split.2x1").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(4)
            }

            // Languages section
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Languages")
                        .font(.headline)

                    ForEach(viewModel.panels.indices, id: \.self) { index in
                        Picker("Panel \(index + 1)", selection: Binding(
                            get: { viewModel.panels[index].language },
                            set: { viewModel.updateLanguage(at: index, to: $0) }
                        )) {
                            ForEach(Language.all) { lang in
                                Text("\(lang.nativeName) (\(lang.name))")
                                    .tag(lang)
                            }
                        }
                    }
                }
                .padding(4)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - API Keys Tab

    private var apiTab: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Google Translate
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Google Translate", systemImage: "g.circle")
                        .font(.headline)

                    apiKeyField(
                        key: $googleAPIKey,
                        showKey: $showGoogleKey,
                        placeholder: "Enter Google Translate API key",
                        onSave: { KeychainHelper.setAPIKey($0, for: .google) }
                    )

                    Text("Get a key from Google Cloud Console → APIs & Services → Credentials")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(4)
            }

            // DeepL
            GroupBox {
                VStack(alignment: .leading, spacing: 8) {
                    Label("DeepL", systemImage: "d.circle")
                        .font(.headline)

                    apiKeyField(
                        key: $deepLAPIKey,
                        showKey: $showDeepLKey,
                        placeholder: "Enter DeepL API key",
                        onSave: { KeychainHelper.setAPIKey($0, for: .deepL) }
                    )

                    Toggle("Use Free API (api-free.deepl.com)", isOn: $deepLUseFreeAPI)
                        .onChange(of: deepLUseFreeAPI) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "deepLUseFreeAPI")
                        }

                    Text("Free keys end with \":fx\". Get one at deepl.com/pro-api")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(4)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Reusable API Key Field

    private func apiKeyField(
        key: Binding<String>,
        showKey: Binding<Bool>,
        placeholder: String,
        onSave: @escaping (String) -> Void
    ) -> some View {
        HStack(spacing: 6) {
            Group {
                if showKey.wrappedValue {
                    TextField(placeholder, text: key)
                } else {
                    SecureField(placeholder, text: key)
                }
            }
            .textFieldStyle(.roundedBorder)
            .onChange(of: key.wrappedValue) { newValue in
                onSave(newValue)
            }

            Button(action: { showKey.wrappedValue.toggle() }) {
                Image(systemName: showKey.wrappedValue ? "eye.slash" : "eye")
                    .frame(width: 20)
            }
            .buttonStyle(.borderless)
            .help(showKey.wrappedValue ? "Hide API key" : "Show API key")
        }
    }
}
