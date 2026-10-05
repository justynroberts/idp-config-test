---
entity: component:auth-gateway
title: Auth gateway runbook
---
# Overview
Envoy-based gateway that validates tokens for every public service.

# Users cannot sign in
Check the identity provider status page first. Then check the JWKS cache: the gateway caches keys for 10 minutes, so a key rotation can cause a short burst of 401s.

# Rotating signing keys
Use the rotate-credentials action. It needs approval from SRE. Rotation takes about 5 minutes and requires a rolling restart of gateway pods.
