# Bootstrap Plan — AcmeBank iOS

## In scope (this PR)

### Project name + tech stack
- **App name:** AcmeBank
- **Platform:** iOS 17+, Swift 5.10, SwiftUI
- **Project file mechanism:** XcodeGen (`project.yml`) — no hand-crafted `.xcodeproj`
- **Test framework:** XCTest (unit), XCUITest (UI) — one unit test proves the runner
- **Min Xcode:** 16.0

### Directory structure (Hello World only)

```
.
├── project.yml                        # XcodeGen spec
├── setup.sh                           # one-shot materialise + open
├── .gitignore                         # standard iOS / XcodeGen ignores
├── bootstrap_plan.md
├── README.md
├── CLAUDE.md
├── AGENT.md
├── AcmeBank/
│   ├── App/
│   │   ├── AcmeBankApp.swift          # @main SwiftUI App entry
│   │   └── ContentView.swift          # placeholder "AcmeBank" screen
│   ├── Resources/
│   │   └── Assets.xcassets/
│   │       ├── Contents.json
│   │       └── AppIcon.appiconset/
│   │           └── Contents.json
│   ├── AcmeBank.entitlements          # keychain-access-groups stub
│   └── PrivacyInfo.xcprivacy          # required-reason API manifest
└── AcmeBankTests/
    └── AcmeBankTests.swift            # one trivial unit test (proves XCTest runs)
```

### Files this PR creates
| File | Purpose |
|---|---|
| `project.yml` | XcodeGen declarative project spec (iOS 17+, Swift 5.10) |
| `setup.sh` | installs xcodegen if needed, generates .xcodeproj, opens in Xcode |
| `.gitignore` | ignores .xcodeproj, DerivedData, .DS_Store, etc. |
| `AcmeBank/App/AcmeBankApp.swift` | `@main` SwiftUI `App` entry point (`WindowGroup`) |
| `AcmeBank/App/ContentView.swift` | single view showing "AcmeBank" (Hello World) |
| `AcmeBank/Resources/Assets.xcassets/Contents.json` | top-level asset catalog metadata |
| `AcmeBank/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json` | AppIcon stub (prevents actool CI failure) |
| `AcmeBank/AcmeBank.entitlements` | keychain-access-groups stub |
| `AcmeBank/PrivacyInfo.xcprivacy` | UserDefaults required-reason manifest |
| `AcmeBankTests/AcmeBankTests.swift` | trivial XCTest — `ContentView()` initialises |
| `CLAUDE.md` / `AGENT.md` | project context for future agents |
| `README.md` | updated with setup instructions |

### How to run locally
```
git clone <repo>
./setup.sh        # installs xcodegen (once), generates AcmeBank.xcodeproj, opens Xcode
```
Manual fallback: `brew install xcodegen && xcodegen generate && open AcmeBank.xcodeproj`

### How to run tests
In Xcode: ⌘U on the `AcmeBank` scheme  
CLI: `xcodebuild test -scheme AcmeBank -destination 'platform=iOS Simulator,name=iPhone 16'`

### Definition of Hello World
The app launches on an iOS 17 simulator and shows a single screen with the text **"AcmeBank"** centred on a white background. One XCTest passes: `ContentView()` initialises without crashing.

---

## Out of scope — deferred to future work

- **MVVM + Coordinator architecture** (`AppCoordinator`, `RootView`, `LoginCoordinator`, `TabBarCoordinator`, `HomeCoordinator`, etc.) — future PR
- **Okta OIDC authentication** (`AuthService`, `KeychainStore`, `UserSession`, `Okta.plist`) — future PR
- **Networking layer** (`APIClient`, `APIRouter`, `APIError`, `RequestInterceptor`) — future PR
- **Domain models** (`Account`, `Transaction`, `Customer`, `TransferRequest`) — future PR
- **Repository protocols** (`AccountRepositoryProtocol`, `TransactionRepositoryProtocol`, `CustomerRepositoryProtocol`) — future PR
- **Mock data layer** (`MockAccountRepository`, `MockTransactionRepository`, `MockCustomerRepository`) — future PR
- **Internal notifications** (`AppNotification`, `NotificationPublisher`, `NotificationKey`) — future PR
- **Design system** (`DesignSystem/Colors.swift`, `DesignSystem/Typography.swift`, full `Assets.xcassets`) — future PR
- **Feature screens** (Login, Home/Dashboard, Accounts, Transfer, Cards, More) — future PRs per feature story
- **XCUITest flows** (Login, Transfer, Sign-out) — future PR (alongside corresponding feature stories)
- **CI configuration** (GitHub Actions `ios-build.yml`, `swiftlint`, xcconfig injection) — future PR
- **SwiftLint** (`.swiftlint.yml`) — future PR
- **API base URL xcconfig injection** — future PR
- **Extensions** (`Decimal+Currency`, `Date+Greeting`, `String+Initials`) — future PR
