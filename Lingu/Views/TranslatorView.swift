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

                Button(action: { viewModel.clearAll() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderless)
                .help("Clear all")

                Button(action: {
                    if #available(macOS 14.0, *) {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    } else {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }
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
        .frame(width: 340)
        .frame(minHeight: 280, maxHeight: 500)
        .onAppear {
            viewModel.onPopoverOpen()
        }
    }
}
