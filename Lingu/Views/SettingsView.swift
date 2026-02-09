import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TranslatorViewModel

    @State private var googleAPIKey: String = ""
    @State private var deepLAPIKey: String = ""
    @State private var selectedProviderLocal: TranslationProvider = .google

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
        .frame(width: 420, height: 300)
        .onAppear {
            googleAPIKey = KeychainHelper.apiKey(for: .google)
            deepLAPIKey = KeychainHelper.apiKey(for: .deepL)
            selectedProviderLocal = viewModel.provider
        }
    }

    private var generalTab: some View {
        Form {
            Section {
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
            }

            Section("Languages") {
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
        }
        .formStyle(.grouped)
        .padding()
    }

    private var apiTab: some View {
        Form {
            Section("Google Translate") {
                SecureField("API Key", text: $googleAPIKey)
                    .onChange(of: googleAPIKey) { newValue in
                        KeychainHelper.setAPIKey(newValue, for: .google)
                    }
                Text("Get a key from Google Cloud Console → APIs & Services")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section("DeepL") {
                SecureField("API Key", text: $deepLAPIKey)
                    .onChange(of: deepLAPIKey) { newValue in
                        KeychainHelper.setAPIKey(newValue, for: .deepL)
                    }
                Text("Get a free key from deepl.com/pro-api")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}
