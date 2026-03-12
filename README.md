<p align="center">
  <img src="https://developer.apple.com/assets/elements/icons/sf-symbols/sf-symbols-96x96_2x.png" width="80" />
</p>

<h1 align="center">Lingu</h1>

<p align="center">
  <strong>Tired of swapping and switching languages in your translation apps?</strong>
</p>

<p align="center">
  A lightning-fast, multi-language translation utility that lives in your macOS menu bar.<br/>
  Type once. See every language. Instantly.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS%2013%2B-blue?style=flat-square&logo=apple" />
  <img src="https://img.shields.io/badge/swift-5.9-orange?style=flat-square&logo=swift" />
  <img src="https://img.shields.io/badge/UI-SwiftUI-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" />
</p>

---

## Why Lingu?

Traditional translation tools force you into a **one-language-at-a-time** workflow: pick source, pick target, translate, then swap and repeat for every language pair. It's slow, clunky, and breaks your flow.

**Lingu rethinks translation from scratch.** It sits in your menu bar, opens in a click, and translates to **2–3 languages simultaneously**. No browser tabs. No app switching. No swapping source and target. Just type — or paste — and see results everywhere at once.

---

## Features

### Hub-and-Spoke Translation
Type in **any** panel and all others translate instantly. The source is whichever panel you're typing in — no mode switching, no swap buttons.

### Simultaneous Multi-Language
See 2–3 languages translated **in parallel**, side by side. Compare nuances across languages in a single glance.

### Menu Bar Native
Lives in your macOS menu bar. Click to open, type, done. Never leaves your workspace — no window hunting, no Alt+Tab.

### Enter to Translate
Press **Return** to translate. **Shift+Return** for a new line. No wasted API calls on half-typed words. You control when translation fires.

### Clipboard-First Workflow
Copy text anywhere on your Mac → click Lingu → it's **already translated**. Auto-paste drops clipboard content right into the source panel on open.

### Flexible Layout
Toggle between **vertical** (compact, menu-bar friendly) and **horizontal** (side-by-side comparison) with one click.

### Multi-Provider Support
Choose between **Google Translate** and **DeepL** APIs. Switch providers on the fly. Auto-fallback if one provider isn't configured.

### 36+ Languages
Arabic, Chinese (Simplified & Traditional), Japanese, Korean, French, German, Spanish, Portuguese, Russian, Hindi, and many more — each with native name display.

### Secure API Key Storage
API keys are stored in the **macOS Keychain** — not in plain text, not in config files.

---

## How Lingu Compares

| Feature | Lingu | Google Translate (Web) | DeepL (Desktop) | Apple Translate |
|---|:---:|:---:|:---:|:---:|
| **Multi-language at once** | 2–3 simultaneous | 1 pair | 1 pair | 1 pair |
| **Type anywhere = source** | Any panel is input | Fixed source box | Fixed source box | Fixed source box |
| **Menu bar access** | One click | Open browser + tab | Open app + window | Open app + window |
| **Auto-paste clipboard** | On open | Manual paste | Manual paste | Manual paste |
| **No translate button** | Return to translate | Click button | Auto (with delays) | Click button |
| **Layout switching** | Vertical / Horizontal | Fixed | Fixed | Fixed |
| **Multiple providers** | Google + DeepL | Google only | DeepL only | Apple only |
| **Offline capable** | — | — | — | Some languages |
| **Free & open source** | Yes | Free (limited) | Freemium | Built-in |

---

## Getting Started

### Prerequisites
- macOS 13.0 or later
- An API key for at least one provider:
  - [Google Cloud Translation API](https://cloud.google.com/translate/docs/setup)
  - [DeepL API](https://www.deepl.com/pro-api) (free tier available)

### Build & Install

```bash
# Clone the repo
git clone https://github.com/baixianger/Lingu.git
cd Lingu

# Build
xcodebuild -scheme Lingu -configuration Release build

# Install (optional)
cp -R ~/Library/Developer/Xcode/DerivedData/Lingu-*/Build/Products/Release/Lingu.app /Applications/
```

Or open `Lingu.xcodeproj` in Xcode and press **⌘R**.

### Setup
1. Launch Lingu — it appears in the menu bar as a speech bubble icon
2. Click the gear icon → **API Keys** tab
3. Enter your Google Translate or DeepL API key
4. Start translating

---

## Usage

| Action | Shortcut |
|---|---|
| Translate | **Return** |
| New line | **Shift + Return** |
| Copy result | Click the copy icon on any panel |
| Clear all | Click the reset icon |
| Switch layout | Click the layout toggle icon |
| Quit | Click the power icon |

---

## Tech Stack

- **SwiftUI** — Native macOS UI
- **MenuBarExtra** — System menu bar integration
- **NSTextView** — Custom text editor with key interception
- **Swift Concurrency** — Parallel translations via `TaskGroup`
- **Keychain Services** — Secure API key storage
- **Combine** — Reactive state management

---

## License

MIT — do whatever you want with it.

---

<p align="center">
  <sub>Built with frustration at existing translation tools, and a love for fast workflows.</sub>
</p>
