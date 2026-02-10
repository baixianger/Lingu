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

        let tabVC = NSTabViewController()
        tabVC.tabStyle = .toolbar

        // General tab
        let generalTab = NSTabViewItem(
            viewController: NSHostingController(rootView: GeneralSettingsTab(viewModel: viewModel))
        )
        generalTab.label = "General"
        generalTab.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General")

        // API Keys tab
        let apiKeysTab = NSTabViewItem(
            viewController: NSHostingController(rootView: APIKeysSettingsTab(viewModel: viewModel))
        )
        apiKeysTab.label = "API Keys"
        apiKeysTab.image = NSImage(systemSymbolName: "key", accessibilityDescription: "API Keys")

        tabVC.addTabViewItem(generalTab)
        tabVC.addTabViewItem(apiKeysTab)

        let window = NSWindow(contentViewController: tabVC)
        window.styleMask = [.titled, .closable]
        window.center()
        window.isReleasedWhenClosed = false
        window.level = .floating
        self.window = window

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
