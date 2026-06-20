# AcmeBank iOS — Project Context

AcmeBank is a mobile banking iOS app (iOS 17+, Swift 5.10, SwiftUI) that lets
customers view accounts, review transactions, initiate transfers, and manage cards.
This repo currently contains the bootstrapped Hello World shell; all product
features are added via subsequent Jira stories.

## Tech Stack

| Item | Value |
|---|---|
| Platform | iOS 17+ |
| Language | Swift 5.10 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Coordinator (SwiftUI `NavigationStack`) |
| Auth | Okta OIDC (`okta-mobile-swift` 2.x) |
| Networking | `URLSession` + async/await |
| DI | Constructor injection; no service locator |
| Notifications | `NotificationCenter` (typed wrappers) |
| Project files | XcodeGen (`project.yml`) |
| Min Xcode | 16.0 |
| Bundle ID | `com.acmebank.mobile` |

## Running Locally

```bash
./setup.sh        # installs xcodegen (once), generates .xcodeproj, opens Xcode
```

Manual: `brew install xcodegen && xcodegen generate && open AcmeBank.xcodeproj`

## Running Tests

```bash
# Xcode
⌘U on the AcmeBank scheme

# CLI
xcodebuild test -scheme AcmeBank \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Key Directory Structure

```
AcmeBank/
├── App/              # @main entry, RootView, AppCoordinator (deferred)
├── Core/             # Auth, Networking, Notifications, Extensions (deferred)
├── Domain/           # Models + Repository protocols (deferred)
├── Data/             # Remote + Mock repository implementations (deferred)
├── Features/         # Login, Home, Accounts, Transfer, Cards (deferred)
├── DesignSystem/     # Colors, Typography (deferred)
└── Resources/        # Assets.xcassets, PrivacyInfo.xcprivacy
AcmeBankTests/        # XCTest unit tests
AcmeBankUITests/      # XCUITest critical-flow tests (deferred)
project.yml           # XcodeGen spec — source of truth for .xcodeproj
setup.sh              # one-shot materialise script
```

## Planned Architecture (from spec)

### Implemented in this PR
- `AcmeBank/App/AcmeBankApp.swift` — `@main` SwiftUI `App` entry *(implemented)*
- `AcmeBank/App/ContentView.swift` — placeholder Hello World screen *(implemented)*
- `project.yml` — XcodeGen spec with iOS 17+ / Swift 5.10 settings *(implemented)*
- `AcmeBankTests/AcmeBankTests.swift` — one passing unit test *(implemented)*
- `AcmeBankUITests/AcmeBankUITests.swift` — UI test stub (app launches) *(implemented)*
- `AcmeBank/AcmeBank.entitlements` — keychain-access-groups stub *(implemented)*
- `AcmeBank/PrivacyInfo.xcprivacy` — UserDefaults required-reason manifest *(implemented)*

### Deferred — future PRs
- **MVVM + Coordinator** — `AppCoordinator`, `RootView`, `LoginCoordinator`,
  `TabBarCoordinator`, `HomeCoordinator`, etc. *(deferred)*
- **Okta OIDC auth** — `AuthService`, `KeychainStore`, `UserSession`, `Okta.plist` *(deferred)*
- **Networking layer** — `APIClient`, `APIRouter`, `APIError`, `RequestInterceptor` *(deferred)*
- **Domain models** — `Account`, `Transaction`, `Customer`, `TransferRequest` *(deferred)*
- **Repository protocols** — `AccountRepositoryProtocol` etc. in `Domain/Repositories/` *(deferred)*
- **Mock data layer** — `MockAccountRepository` etc. in `Data/Mock/` *(deferred)*
- **Internal notifications** — `AppNotification`, `NotificationPublisher`, `NotificationKey` *(deferred)*
- **Design system** — `Colors.swift` (monochrome navy palette), `Typography.swift` *(deferred)*
- **Feature screens** — Login, Home/Dashboard, Accounts, Transfer, Cards, More *(deferred)*
- **XCUITest critical flows** — login, transfer, sign-out in `AcmeBankUITests/` *(deferred)*
- **CI config** — GitHub Actions `ios-build.yml`, SwiftLint (`.swiftlint.yml`), xcconfig injection *(deferred)*
- **Extensions** — `Decimal+Currency`, `Date+Greeting`, `String+Initials` *(deferred)*

## Keychain Note (for future feature agents)

Every Keychain query dict **MUST** include `kSecUseDataProtectionKeychain: true`.
The entitlements file ships in this PR; the data-protection keychain flag prevents
`errSecMissingEntitlement` (-34018) on CI simulator runs with `CODE_SIGNING_ALLOWED=NO`.

```swift
var query: [String: Any] = [
  kSecClass as String:                     kSecClassGenericPassword,
  kSecAttrService as String:               "com.acmebank.mobile",
  kSecAttrAccount as String:               "accessToken",
  kSecUseDataProtectionKeychain as String: true,   // required for CI
]
```

## Git Workflow

> **Default PR target branch: `develop`.** Every feature/refactor/docs PR
> opens against `develop`. PRs are only opened against `qa`, `uat`, or
> `main` for explicit promotion PRs.

**Branch model (`develop` → `qa` → `uat` → `main`):**

| Branch  | Role                                 | Receives PRs from              | Promotes to |
|---------|--------------------------------------|--------------------------------|-------------|
| develop | Default integration branch           | feature branches               | qa          |
| qa      | First quality gate                   | develop (promotion PR)         | uat         |
| uat     | Pre-prod acceptance                  | qa (promotion PR)              | main        |
| main    | Production / release tags            | uat (promotion PR)             | tagged only |

All feature PRs MUST target `develop`. Never open a feature PR against
`qa`, `uat`, or `main`. Promotions happen via dedicated promotion PRs.
