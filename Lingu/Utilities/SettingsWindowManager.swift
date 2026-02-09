import AppKit
import SwiftUI

@MainActor
final class SettingsWindowManager {
    static let shared = SettingsWindowManager()
    private var window: NSWindow?

    func open(viewModel: TranslatorViewModel) {
        if let window, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let settingsView = SettingsView(viewModel: viewModel)
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = "Lingu Settings"
        window.styleMask = [.titled, .closable, .resizable]
        window.setContentSize(NSSize(width: 450, height: 380))
        window.contentMinSize = NSSize(width: 380, height: 300)
        window.contentMaxSize = NSSize(width: 600, height: 500)
        window.center()
        window.isReleasedWhenClosed = false
        window.level = .floating
        self.window = window

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
