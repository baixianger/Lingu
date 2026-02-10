import SwiftUI

struct TranslatorView: View {
    @ObservedObject var viewModel: TranslatorViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Lingu")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button(action: { viewModel.horizontalLayout.toggle() }) {
                    Image(systemName: viewModel.horizontalLayout ? "rectangle.split.1x2" : "rectangle.split.2x1")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderless)
                .help(viewModel.horizontalLayout ? "Switch to vertical" : "Switch to horizontal")

                Button(action: { viewModel.clearAll() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderless)
                .help("Clear all")

                settingsButton
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 4)

            // Error bar
            if let error = viewModel.error {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 11))
                    Text(error)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: { viewModel.error = nil }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 9))
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.1))
            }

            Divider()

            // Language panels
            if viewModel.horizontalLayout {
                horizontalPanels
            } else {
                verticalPanels
            }
        }
        .frame(
            minWidth: viewModel.horizontalLayout ? 600 : 300,
            maxWidth: viewModel.horizontalLayout ? 1000 : 420,
            minHeight: viewModel.horizontalLayout ? 300 : 250,
            maxHeight: viewModel.horizontalLayout ? 600 : 500
        )
        .onAppear {
            viewModel.onPopoverOpen()
        }
    }

    @ViewBuilder
    private var settingsButton: some View {
        if #available(macOS 14, *) {
            SettingsLink {
                Image(systemName: "gearshape")
                    .font(.system(size: 12))
            }
            .buttonStyle(.borderless)
            .help("Settings")
        } else {
            Button(action: {
                NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                NSApp.activate(ignoringOtherApps: true)
            }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 12))
            }
            .buttonStyle(.borderless)
            .help("Settings")
        }
    }

    private var verticalPanels: some View {
        VStack(spacing: 2) {
            ForEach(Array(viewModel.panels.enumerated()), id: \.element.id) { index, _ in
                LanguagePanelView(panelIndex: index, viewModel: viewModel, isHorizontal: false)
                if index < viewModel.panels.count - 1 {
                    Divider()
                        .padding(.horizontal, 12)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private var horizontalPanels: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Array(viewModel.panels.enumerated()), id: \.element.id) { index, _ in
                LanguagePanelView(panelIndex: index, viewModel: viewModel, isHorizontal: true)
                    .frame(maxWidth: .infinity)
                if index < viewModel.panels.count - 1 {
                    Divider()
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
