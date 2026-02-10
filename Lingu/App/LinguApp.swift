import SwiftUI

@main
struct LinguApp: App {
    @StateObject private var viewModel = TranslatorViewModel()

    var body: some Scene {
        MenuBarExtra("Lingu", systemImage: "character.bubble") {
            TranslatorView(viewModel: viewModel)
        }
        .menuBarExtraStyle(.window)

        Settings {
            TabView {
                GeneralSettingsTab(viewModel: viewModel)
                    .tabItem {
                        Label("General", systemImage: "gearshape")
                    }

                APIKeysSettingsTab(viewModel: viewModel)
                    .tabItem {
                        Label("API Keys", systemImage: "key")
                    }
            }
        }
    }
}
