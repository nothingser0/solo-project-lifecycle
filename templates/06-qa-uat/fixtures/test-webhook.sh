#!/usr/bin/env bash
# Quick Webhook SIT Runner for Local & Staging Verification
# Usage: ./templates/06-qa-uat/fixtures/test-webhook.sh [endpoint_url] [fixture_path] [token/secret]

set -euo pipefail

ENDPOINT="${1:-http://localhost:3000/api/webhooks/payment}"
FIXTURE="${2:-templates/06-qa-uat/fixtures/midtrans-webhook-settlement.json}"
TOKEN="${3:-test_signature_secret}"

if [ ! -f "$FIXTURE" ]; then
    echo "❌ Fixture not found: $FIXTURE"
    exit 1
fi

echo "=== Running Webhook SIT Test ==="
echo "Target Endpoint: $ENDPOINT"
echo "Payload Fixture: $FIXTURE"

# Test 1: Valid Delivery
echo -e "\n1. Testing Valid Webhook Delivery..."
curl -i -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "x-callback-token: $TOKEN" \
  --data-binary "@$FIXTURE"

# Test 2: Missing Token / Bad Signature (Negative Test)
echo -e "\n\n2. Testing Missing / Unauthorized Token (Must return 401/403)..."
curl -i -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  --data-binary "@$FIXTURE" || true

# Test 3: Idempotency Replay (Must return 200 without double-crediting)
echo -e "\n\n3. Testing Idempotent Replay Delivery (Must return 200)..."
curl -i -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "x-callback-token: $TOKEN" \
  --data-binary "@$FIXTURE"

echo -e "\n=== Webhook SIT Test Run Complete ==="
