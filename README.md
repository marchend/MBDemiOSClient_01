# AcmeBank iOS

AcmeBank is a mobile banking iOS app built with Swift 5.10 + SwiftUI, targeting iOS 17+.
This repository contains the bootstrapped shell; full features are added via subsequent stories.

## Quick Start

```bash
git clone <repo-url>
./setup.sh
```

`setup.sh` installs [XcodeGen](https://github.com/yonaskolb/XcodeGen) if needed,
materialises `AcmeBank.xcodeproj` from `project.yml`, and opens it in Xcode.

**Manual fallback** (for environments that block shell scripts):

```bash
brew install xcodegen
xcodegen generate
open AcmeBank.xcodeproj
```

## Running Tests

- **Xcode:** ⌘U on the `AcmeBank` scheme
- **CLI:** `xcodebuild test -scheme AcmeBank -destination 'platform=iOS Simulator,name=iPhone 16'`

## Tech Stack

| Item | Value |
|---|---|
| Platform | iOS 17+ |
| Language | Swift 5.10 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator (deferred) |
| Project files | XcodeGen (`project.yml`) |
| Min Xcode | 16.0 |
| Bundle ID | `com.acmebank.mobile` |

## Branch Model

Default PR target: **`develop`**. See `CLAUDE.md` for the full four-branch model.
