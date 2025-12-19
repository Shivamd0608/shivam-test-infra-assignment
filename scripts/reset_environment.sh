#!/bin/bash
# Reset test environment to clean state

set -e

echo "🔄 Resetting test environment..."

# Stop any running processes
echo "1️⃣  Stopping processes..."
pkill -f "anvil" || true
pkill -f "hardhat node" || true
pkill -f "ganache" || true
echo "✅ Processes stopped"

# Clean database
echo ""
echo "2️⃣  Cleaning database..."
if [ -f "../api-test/test.db" ]; then
  rm ../api-test/test.db
  echo "✅ Test database removed"
fi

# Clean smart contract artifacts
echo ""
echo "3️⃣  Cleaning smart contract artifacts..."
cd ../smart-contract-tests
forge clean
echo "✅ Artifacts cleaned"

# Reset test data directory
echo ""
echo "4️⃣  Resetting test data..."
cd ..
if [ -d "test-data" ]; then
  rm -rf test-data
fi
mkdir -p test-data
echo "✅ Test data directory reset"

# Clear mobile test screenshots
echo ""
echo "5️⃣  Clearing mobile screenshots..."
if [ -d "mobile-tests/screenshots" ]; then
  rm -rf mobile-tests/screenshots/*
fi
mkdir -p mobile-tests/screenshots
echo "✅ Screenshots cleared"

# Start fresh local node
echo ""
echo "6️⃣  Starting fresh local node..."
cd smart-contract-tests
anvil --fork-url https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY \
  --port 8545 \
  --accounts 10 \
  --balance 10000 > ../test-data/anvil.log 2>&1 &

ANVIL_PID=$!
echo $ANVIL_PID > ../test-data/anvil.pid
sleep 3

echo "✅ Local node started (PID: $ANVIL_PID)"

# Deploy fresh contracts
echo ""
echo "7️⃣  Deploying fresh contracts..."
forge script script/DeployLocal.s.sol:DeployLocal \
  --rpc-url http://localhost:8545 \
  --broadcast \
  -vvv

echo "✅ Contracts deployed"

echo ""
echo "🎉 Environment reset complete!"
echo ""
echo "Local node running at http://localhost:8545"
echo "Stop with: kill $(cat test-data/anvil.pid)"
