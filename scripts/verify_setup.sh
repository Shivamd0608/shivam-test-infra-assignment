#!/bin/bash
# Verify test environment is properly configured

set -e

echo "🔍 Verifying test environment..."
echo ""

# Track failures
FAILURES=0

# Check 1: Smart contract dependencies
echo "1️⃣  Checking smart contract setup..."
if [ ! -d "smart-contract-tests/lib/forge-std" ]; then
  echo "❌ forge-std not installed"
  FAILURES=$((FAILURES + 1))
else
  echo "✅ forge-std installed"
fi

# Check 2: Python dependencies
echo ""
echo "2️⃣  Checking Python dependencies..."
if [ -f "api-test/requirements.txt" ]; then
  cd api-test
  if python3 -m pip freeze | grep -q "pytest"; then
    echo "✅ Python dependencies installed"
  else
    echo "⚠️  Python dependencies not installed (run: pip install -r requirements.txt)"
    FAILURES=$((FAILURES + 1))
  fi
  cd ..
else
  echo "❌ requirements.txt not found"
  FAILURES=$((FAILURES + 1))
fi

# Check 3: Maestro installation
echo ""
echo "3️⃣  Checking Maestro..."
if command -v maestro &> /dev/null; then
  echo "✅ Maestro installed: $(maestro -v)"
else
  echo "⚠️  Maestro not installed (optional)"
fi

# Check 4: Test accounts
echo ""
echo "4️⃣  Checking test accounts..."
if [ -f "test-data/test-accounts.json" ]; then
  echo "✅ Test accounts configured"
else
  echo "⚠️  Test accounts not generated (run: python3 scripts/generate_test_accounts.py)"
fi

# Check 5: RPC endpoints
echo ""
echo "5️⃣  Checking RPC connectivity..."
if curl -s -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
  https://eth-mainnet.g.alchemy.com/v2/demo &> /dev/null; then
  echo "✅ RPC endpoint reachable"
else
  echo "⚠️  RPC endpoint unreachable (check network connection)"
fi

# Check 6: Git configuration
echo ""
echo "6️⃣  Checking Git configuration..."
if grep -q "test-data" .gitignore 2>/dev/null; then
  echo "✅ test-data in .gitignore"
else
  echo "⚠️  Add test-data/ to .gitignore"
  FAILURES=$((FAILURES + 1))
fi

# Check 7: File structure
echo ""
echo "7️⃣  Checking file structure..."
REQUIRED_DIRS=(
  "smart-contract-tests/test/fixtures"
  "api-test/tests"
  "mobile-tests/maestro"
  "scripts"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "✅ $dir exists"
  else
    echo "❌ $dir missing"
    FAILURES=$((FAILURES + 1))
  fi
done

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $FAILURES -eq 0 ]; then
  echo "🎉 Environment verification passed!"
  echo ""
  echo "You can now run tests:"
  echo "  • Smart contracts: cd smart-contract-tests && forge test"
  echo "  • API tests: cd api-test && pytest"
  echo "  • Mobile tests: maestro test mobile-tests/maestro/"
else
  echo "⚠️  Found $FAILURES issue(s) - please fix them"
  exit 1
fi
