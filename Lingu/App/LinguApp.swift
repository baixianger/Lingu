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
            SettingsView(viewModel: viewModel)
        }
    }
}
