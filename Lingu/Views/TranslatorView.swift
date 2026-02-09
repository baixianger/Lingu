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

                Button(action: {
                    SettingsWindowManager.shared.open(viewModel: viewModel)
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderless)
                .help("Settings")
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
            minWidth: viewModel.horizontalLayout ? 500 : 300,
            maxWidth: viewModel.horizontalLayout ? 900 : 420,
            minHeight: 250,
            maxHeight: 500
        )
        .onAppear {
            viewModel.onPopoverOpen()
        }
    }

    private var verticalPanels: some View {
        ScrollView {
            VStack(spacing: 2) {
                ForEach(viewModel.panels.indices, id: \.self) { index in
                    LanguagePanelView(panelIndex: index, viewModel: viewModel)
                    if index < viewModel.panels.count - 1 {
                        Divider()
                            .padding(.horizontal, 12)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var horizontalPanels: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(viewModel.panels.indices, id: \.self) { index in
                LanguagePanelView(panelIndex: index, viewModel: viewModel)
                if index < viewModel.panels.count - 1 {
                    Divider()
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
