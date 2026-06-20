import XCTest
@testable import AcmeBank

/// Tests for `OktaConfig.load(from:)`. The seam is the explicit info
/// dictionary parameter — we never have to mutate `Bundle.main`, so
/// these tests are deterministic and run in any order.
final class OktaConfigTests: XCTestCase {

    // MARK: - Happy path

    func test_load_allFourPresent_returnsConfigured() {
        let info: [String: Any] = [
            "OktaIssuer":      "https://acmebank.okta.com/oauth2/default",
            "OktaClientID":    "0oa123abc",
            "OktaRedirectURI": "com.acmebank.mobile:/callback",
            "OktaScopes":      "openid profile offline_access",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .configured(issuer, clientID, redirect, scopes) = result else {
            return XCTFail("Expected .configured, got \(result)")
        }
        XCTAssertEqual(issuer.absoluteString, "https://acmebank.okta.com/oauth2/default")
        XCTAssertEqual(clientID, "0oa123abc")
        XCTAssertEqual(redirect.absoluteString, "com.acmebank.mobile:/callback")
        XCTAssertEqual(scopes, "openid profile offline_access")
    }

    // MARK: - Single missing

    func test_load_issuerMissing_returnsNotConfiguredWithIssuerNamed() {
        let info: [String: Any] = [
            "OktaClientID":    "0oa123abc",
            "OktaRedirectURI": "com.acmebank.mobile:/callback",
            "OktaScopes":      "openid",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaIssuer"), "reason should name OktaIssuer: \(reason)")
        XCTAssertFalse(reason.contains("OktaClientID"), "reason should not name keys that are present")
    }

    func test_load_clientIDEmpty_returnsNotConfigured() {
        let info: [String: Any] = [
            "OktaIssuer":      "https://acmebank.okta.com/oauth2/default",
            "OktaClientID":    "   ",   // whitespace-only treated as missing
            "OktaRedirectURI": "com.acmebank.mobile:/callback",
            "OktaScopes":      "openid",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaClientID"))
    }

    // MARK: - Sentinel detection

    func test_load_sentinelValues_returnsNotConfigured_andNamesAllUnsetKeys() {
        let info: [String: Any] = [
            "OktaIssuer":      "__OKTA_ISSUER_UNSET__",
            "OktaClientID":    "__OKTA_CLIENT_ID_UNSET__",
            "OktaRedirectURI": "__OKTA_REDIRECT_URI_UNSET__",
            "OktaScopes":      "__OKTA_SCOPES_UNSET__",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaIssuer"))
        XCTAssertTrue(reason.contains("OktaClientID"))
        XCTAssertTrue(reason.contains("OktaRedirectURI"))
        XCTAssertTrue(reason.contains("OktaScopes"))
    }

    func test_load_mixedSentinelAndRealValues_namesOnlyTheSentinelKeys() {
        let info: [String: Any] = [
            "OktaIssuer":      "https://acmebank.okta.com/oauth2/default",
            "OktaClientID":    "__OKTA_CLIENT_ID_UNSET__",
            "OktaRedirectURI": "com.acmebank.mobile:/callback",
            "OktaScopes":      "__OKTA_SCOPES_UNSET__",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaClientID"))
        XCTAssertTrue(reason.contains("OktaScopes"))
        XCTAssertFalse(reason.contains("OktaIssuer"))
        XCTAssertFalse(reason.contains("OktaRedirectURI"))
    }

    func test_load_allMissing_emptyDictionary_returnsNotConfigured() {
        let result = OktaConfig.load(from: [:])

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaIssuer"))
        XCTAssertTrue(reason.contains("OktaClientID"))
        XCTAssertTrue(reason.contains("OktaRedirectURI"))
        XCTAssertTrue(reason.contains("OktaScopes"))
    }

    // MARK: - Malformed URLs

    func test_load_malformedIssuer_returnsNotConfigured() {
        let info: [String: Any] = [
            // No scheme — URL(string:) accepts this but .scheme is nil
            "OktaIssuer":      "not a url",
            "OktaClientID":    "0oa123abc",
            "OktaRedirectURI": "com.acmebank.mobile:/callback",
            "OktaScopes":      "openid",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured for malformed issuer, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaIssuer"), "reason should name the malformed key: \(reason)")
    }

    func test_load_malformedRedirectURI_returnsNotConfigured() {
        let info: [String: Any] = [
            "OktaIssuer":      "https://acmebank.okta.com/oauth2/default",
            "OktaClientID":    "0oa123abc",
            "OktaRedirectURI": "no scheme here",
            "OktaScopes":      "openid",
        ]

        let result = OktaConfig.load(from: info)

        guard case let .notConfigured(reason) = result else {
            return XCTFail("Expected .notConfigured for malformed redirect, got \(result)")
        }
        XCTAssertTrue(reason.contains("OktaRedirectURI"))
    }
}
