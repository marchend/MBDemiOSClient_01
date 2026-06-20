import Foundation

/// Build-time-injected Okta tenant configuration, surfaced at runtime.
///
/// The four `Okta*` keys are written into `Info.plist` by
/// `Scripts/inject-okta-config.sh` (a Run Script build phase) from the
/// `OKTA_ISSUER`, `OKTA_CLIENT_ID`, `OKTA_REDIRECT_URI`, and
/// `OKTA_SCOPES` shell environment variables. When a variable is unset
/// the script writes a `__OKTA_<NAME>_UNSET__` sentinel; this loader
/// detects the sentinel and returns `.notConfigured` so callers can
/// fall back to a mock auth path rather than crashing.
///
/// Design rules (do not regress in future PRs):
/// - Never `fatalError`. A first-clone developer with no env vars set
///   must still be able to launch the app.
/// - Never force-unwrap. Use `.notConfigured(reason:)` with a message
///   that names the offending key(s).
/// - The loader takes its info dictionary as a parameter so unit tests
///   can drive every branch without mutating the host bundle.
public enum OktaConfig: Equatable {
    case configured(issuer: URL, clientID: String, redirectURI: URL, scopes: String)
    case notConfigured(reason: String)

    /// Info.plist keys. Kept private so the rest of the app cannot
    /// reach around the loader and read raw strings.
    private enum Key {
        static let issuer      = "OktaIssuer"
        static let clientID    = "OktaClientID"
        static let redirectURI = "OktaRedirectURI"
        static let scopes      = "OktaScopes"
    }

    /// Marker prefix written by `Scripts/inject-okta-config.sh` when an
    /// env var is unset. Any value beginning with this prefix is
    /// treated as "missing" by the loader.
    static let sentinelPrefix = "__OKTA_"
    static let sentinelSuffix = "_UNSET__"

    /// Load from the main bundle (production call site).
    public static func load() -> OktaConfig {
        load(from: Bundle.main.infoDictionary ?? [:])
    }

    /// Load from an explicit info dictionary. Exposed for unit tests so
    /// every branch (configured, single-missing, all-missing, sentinel,
    /// malformed URL) can be exercised without touching `Bundle.main`.
    static func load(from info: [String: Any]) -> OktaConfig {
        let issuerRaw      = string(info, Key.issuer)
        let clientIDRaw    = string(info, Key.clientID)
        let redirectRaw    = string(info, Key.redirectURI)
        let scopesRaw      = string(info, Key.scopes)

        var missing: [String] = []
        if isMissing(issuerRaw)   { missing.append(Key.issuer) }
        if isMissing(clientIDRaw) { missing.append(Key.clientID) }
        if isMissing(redirectRaw) { missing.append(Key.redirectURI) }
        if isMissing(scopesRaw)   { missing.append(Key.scopes) }

        if !missing.isEmpty {
            return .notConfigured(
                reason: "Missing Okta configuration: \(missing.joined(separator: ", ")). " +
                        "Set the corresponding OKTA_* environment variable and rebuild."
            )
        }

        // Force-unwrap is safe here only because `isMissing` already
        // rejected nil/empty values — but we still avoid `!` to keep
        // the rule "no force-unwraps in this file" mechanically true.
        guard let issuerStr = issuerRaw,
              let clientID  = clientIDRaw,
              let redirect  = redirectRaw,
              let scopes    = scopesRaw else {
            return .notConfigured(reason: "Internal error: Okta keys passed the missing-check but were nil")
        }

        guard let issuerURL = URL(string: issuerStr), issuerURL.scheme != nil else {
            return .notConfigured(reason: "Malformed \(Key.issuer): \(issuerStr) is not a valid URL")
        }
        guard let redirectURL = URL(string: redirect), redirectURL.scheme != nil else {
            return .notConfigured(reason: "Malformed \(Key.redirectURI): \(redirect) is not a valid URL")
        }

        return .configured(
            issuer: issuerURL,
            clientID: clientID,
            redirectURI: redirectURL,
            scopes: scopes
        )
    }

    // MARK: - Helpers

    private static func string(_ info: [String: Any], _ key: String) -> String? {
        guard let raw = info[key] as? String else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func isMissing(_ value: String?) -> Bool {
        guard let value else { return true }
        // Sentinel shape: __OKTA_<NAME>_UNSET__ — prefix is enough; the
        // suffix is checked to avoid false positives on legitimate
        // values that happen to start with the marker.
        return value.hasPrefix(sentinelPrefix) && value.hasSuffix(sentinelSuffix)
    }
}
