#!/bin/bash
#
# inject-okta-config.sh
#
# Build-time bridge from shell environment variables into the AcmeBank
# Info.plist. Xcode's "Run Script" build phases inherit the environment
# of the calling process (the shell that ran xcodebuild, or the launchd
# context of Xcode.app), so this is how we get developer-machine /
# CI-runner secrets into the bundle WITHOUT committing them.
#
# Four variables are bridged:
#   OKTA_ISSUER       -> Info.plist key  OktaIssuer
#   OKTA_CLIENT_ID    -> Info.plist key  OktaClientID
#   OKTA_REDIRECT_URI -> Info.plist key  OktaRedirectURI
#   OKTA_SCOPES       -> Info.plist key  OktaScopes
#
# When a variable is empty or unset, we write a clearly-marked sentinel
# (e.g. "__OKTA_ISSUER_UNSET__") into the built Info.plist rather than
# failing the build or shipping an empty string. The runtime loader
# (`OktaConfig.load()`) detects the `__OKTA_..._UNSET__` prefix and
# returns `.notConfigured(reason:)` so the app boots in a safe mock
# auth mode instead of crashing or pointing at a bogus tenant.
#
# This script's "no Info.plist found" path is intentionally `exit 0`:
# a missing env var (or a target that hasn't produced an Info.plist
# yet) is NOT a build failure (devs cloning the repo for the first
# time must be able to build immediately). It IS a runtime "not
# configured" state.

# Default the two Xcode-provided variables we care about so the guard
# below works whether or not they're set. We deliberately do NOT enable
# `set -u` yet — we want the "Info.plist not produced" path to be a
# clean exit 0 even in unusual build configurations.
PLIST="${BUILT_PRODUCTS_DIR:-}/${INFOPLIST_PATH:-}"

if [ ! -f "$PLIST" ]; then
  echo "warning: inject-okta-config.sh: Info.plist not found at $PLIST; skipping"
  exit 0
fi

# From here on, treat the script as a real production script: fail
# fast on unset variables, command errors, and broken pipes. This is
# the hardening called out in code review — without `set -e`, a
# `plutil -replace` failure (e.g. malformed plist, read-only file)
# would be silently swallowed and the build would appear green while
# the Info.plist was actually missing the Okta keys at runtime.
set -euo pipefail

inject() {
  # $1 = env var name, $2 = Info.plist key
  local var_name="$1"
  local plist_key="$2"
  local value="${!var_name:-}"

  if [ -z "$value" ]; then
    value="__OKTA_${var_name#OKTA_}_UNSET__"
    # var_name is e.g. OKTA_ISSUER -> strip leading OKTA_ -> ISSUER ->
    # sentinel "__OKTA_ISSUER_UNSET__". For OKTA_CLIENT_ID this becomes
    # "__OKTA_CLIENT_ID_UNSET__", which the loader matches by prefix.
    echo "note: inject-okta-config.sh: $var_name is unset; writing sentinel $value into $plist_key"
  else
    echo "note: inject-okta-config.sh: $var_name -> $plist_key"
  fi

  /usr/bin/plutil -replace "$plist_key" -string "$value" "$PLIST"
}

inject OKTA_ISSUER       OktaIssuer
inject OKTA_CLIENT_ID    OktaClientID
inject OKTA_REDIRECT_URI OktaRedirectURI
inject OKTA_SCOPES       OktaScopes

exit 0
