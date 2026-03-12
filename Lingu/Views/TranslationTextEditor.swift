import SwiftUI

struct TranslationTextEditor: NSViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var textColor: NSColor = .labelColor
    var onTranslate: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> NSScrollView {
        let textView = TranslationNSTextView()
        textView.delegate = context.coordinator
        textView.onTranslate = onTranslate
        textView.onFocusChange = { focused in
            DispatchQueue.main.async {
                context.coordinator.parent.isFocused = focused
            }
        }
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.textColor = textColor
        textView.isRichText = false
        textView.allowsUndo = true
        textView.backgroundColor = .clear
        textView.textContainerInset = NSSize(width: 0, height: 4)
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false

        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = false

        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.autoresizingMask = [.width]
        textView.textContainer?.widthTracksTextView = true

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? TranslationNSTextView else { return }
        if textView.string != text {
            context.coordinator.isUpdatingProgrammatically = true
            textView.string = text
            context.coordinator.isUpdatingProgrammatically = false
        }
        textView.textColor = textColor
        textView.onTranslate = onTranslate
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: TranslationTextEditor
        var isUpdatingProgrammatically = false

        init(_ parent: TranslationTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard !isUpdatingProgrammatically else { return }
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}

class TranslationNSTextView: NSTextView {
    var onTranslate: (() -> Void)?
    var onFocusChange: ((Bool) -> Void)?

    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        if result { onFocusChange?(true) }
        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        if result { onFocusChange?(false) }
        return result
    }

    override func keyDown(with event: NSEvent) {
        // Return without Shift → translate
        if event.keyCode == 36 && !event.modifierFlags.contains(.shift) {
            onTranslate?()
            return
        }
        // Shift+Return → newline (default behavior)
        super.keyDown(with: event)
    }
}
