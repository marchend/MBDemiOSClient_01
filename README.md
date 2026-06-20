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

## Okta build configuration

The app reaches a real Okta tenant via four values that are injected
into the built `Info.plist` at build time from shell environment
variables. The injection lives in `Scripts/inject-okta-config.sh`, wired
in `project.yml` as the **"Inject Okta Config"** Run Script build phase
(runs after Copy Bundle Resources). At runtime, `AcmeBank/Auth/OktaConfig.swift`
reads the keys back via `Bundle.main.infoDictionary`.

| Env var             | Info.plist key    | Example                                        |
|---------------------|-------------------|------------------------------------------------|
| `OKTA_ISSUER`       | `OktaIssuer`      | `https://acmebank.okta.com/oauth2/default`     |
| `OKTA_CLIENT_ID`    | `OktaClientID`    | `0oa1abc23defGHI4j5k6`                         |
| `OKTA_REDIRECT_URI` | `OktaRedirectURI` | `com.acmebank.mobile:/callback`                |
| `OKTA_SCOPES`       | `OktaScopes`      | `openid profile offline_access`                |

If a variable is unset the script writes the sentinel
`__OKTA_<NAME>_UNSET__` (e.g. `__OKTA_CLIENT_ID_UNSET__`) into the
plist; `OktaConfig.load()` detects the sentinel prefix and returns
`.notConfigured(reason:)`. The build **never fails** because env vars
are missing — a fresh `git clone` always builds.

### Three ways to set the env vars

1. **GUI-launched Xcode** (Finder / Dock). Xcode.app inherits the
   `launchd` environment, NOT your shell. Use `launchctl setenv`:

   ```bash
   launchctl setenv OKTA_ISSUER       "https://acmebank.okta.com/oauth2/default"
   launchctl setenv OKTA_CLIENT_ID    "0oa1abc23defGHI4j5k6"
   launchctl setenv OKTA_REDIRECT_URI "com.acmebank.mobile:/callback"
   launchctl setenv OKTA_SCOPES       "openid profile offline_access"
   # Then fully quit Xcode (⌘Q) and reopen.
   ```

2. **Shell-launched Xcode.** Put `export` lines in `~/.zshrc` and open
   the project from that shell with `xed`:

   ```bash
   # ~/.zshrc
   export OKTA_ISSUER="https://acmebank.okta.com/oauth2/default"
   export OKTA_CLIENT_ID="0oa1abc23defGHI4j5k6"
   export OKTA_REDIRECT_URI="com.acmebank.mobile:/callback"
   export OKTA_SCOPES="openid profile offline_access"

   # Then from a new terminal in the repo root:
   xed .
   ```

3. **CI or one-shot `xcodebuild`.** Pass the vars in the same command;
   Run Script build phases inherit the calling process's environment:

   ```bash
   OKTA_ISSUER="$OKTA_ISSUER" \
   OKTA_CLIENT_ID="$OKTA_CLIENT_ID" \
   OKTA_REDIRECT_URI="$OKTA_REDIRECT_URI" \
   OKTA_SCOPES="$OKTA_SCOPES" \
   xcodebuild test -scheme AcmeBank \
     -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

### Why a Run Script (and not an xcconfig)

Xcode's `PhaseScriptExecution` step inherits the environment of the
process that invoked the build (your shell, or `launchd` for GUI Xcode),
so a shell script can read `$OKTA_ISSUER` and write it into the bundle
with `plutil`. `xcconfig` `$(VAR)` references do **not** interpolate
shell env vars — they chain other build settings — so the obvious-looking
xcconfig approach silently ships empty values. Stick with the Run Script.

## Tech Stack

| Item | Value |
|---|---|
| Platform | iOS 17+ |
| Language | Swift 5.10 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator (deferred) |
| Auth | Okta (`okta-mobile-swift` 2.x, `OktaDirectAuth` product only) |
| Project files | XcodeGen (`project.yml`) |
| Min Xcode | 16.0 |
| Bundle ID | `com.acmebank.mobile` |

## Branch Model

Default PR target: **`develop`**. See `CLAUDE.md` for the full four-branch model.
