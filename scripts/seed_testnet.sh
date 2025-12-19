#!/bin/bash
# Seed testnet with initial test data

set -e

echo "🌱 Seeding testnet with test data..."

# Configuration
NETWORK="sepolia"
RPC_URL="https://sepolia.infura.io/v3/YOUR_INFURA_KEY"
VAULT_ADDRESS="0x1234567890123456789012345678901234567890"

# Test accounts
MANAGER_PRIVATE_KEY="0xYOUR_MANAGER_KEY"
USER1_PRIVATE_KEY="0xYOUR_USER1_KEY"
USER2_PRIVATE_KEY="0xYOUR_USER2_KEY"

export MANAGER_ADDRESS="0xMANAGER1111222233334444555566667777888899"
export USER1_ADDRESS="0xUSER11112222333344445555666677778888999900"
export USER2_ADDRESS="0xUSER22223333444455556666777788889999000011"

echo "📍 Network: $NETWORK"
echo "📍 Vault: $VAULT_ADDRESS"
echo ""

# Step 1: Deploy mock USDC (if not exists)
echo "1️⃣  Checking USDC contract..."
cd ../smart-contract-tests

USDC_ADDRESS=$(forge script script/DeployMockUSDC.s.sol:DeployMockUSDC \
  --rpc-url $RPC_URL \
  --private-key $MANAGER_PRIVATE_KEY \
  --broadcast \
  --verify \
  -vvv | grep "USDC deployed" | awk '{print $4}')

echo "✅ USDC: $USDC_ADDRESS"

# Step 2: Mint USDC to test users
echo ""
echo "2️⃣  Minting USDC to test accounts..."

# Mint to User1
cast send $USDC_ADDRESS \
  "mint(address,uint256)" \
  $USER1_ADDRESS \
  "1000000000" \
  --rpc-url $RPC_URL \
  --private-key $MANAGER_PRIVATE_KEY

echo "✅ Minted 1000 USDC to User1"

# Mint to User2
cast send $USDC_ADDRESS \
  "mint(address,uint256)" \
  $USER2_ADDRESS \
  "500000000" \
  --rpc-url $RPC_URL \
  --private-key $MANAGER_PRIVATE_KEY

echo "✅ Minted 500 USDC to User2"

# Step 3: Deploy vault (if not exists)
echo ""
echo "3️⃣  Deploying vault..."

forge script script/DeployVault.s.sol:DeployVault \
  --rpc-url $RPC_URL \
  --private-key $MANAGER_PRIVATE_KEY \
  --broadcast \
  --verify \
  -vvv

echo "✅ Vault deployed"

# Step 4: Seed initial deposits
echo ""
echo "4️⃣  Making initial deposits..."

# User1 deposits 100 USDC
cast send $USDC_ADDRESS \
  "approve(address,uint256)" \
  $VAULT_ADDRESS \
  "100000000" \
  --rpc-url $RPC_URL \
  --private-key $USER1_PRIVATE_KEY

cast send $VAULT_ADDRESS \
  "deposit(uint256,address)" \
  "100000000" \
  $USER1_ADDRESS \
  --rpc-url $RPC_URL \
  --private-key $USER1_PRIVATE_KEY

echo "✅ User1 deposited 100 USDC"

# Step 5: Save addresses to config file
echo ""
echo "5️⃣  Saving configuration..."

cat > ../test-config.json <<EOF
{
  "network": "$NETWORK",
  "rpc_url": "$RPC_URL",
  "contracts": {
    "usdc": "$USDC_ADDRESS",
    "vault": "$VAULT_ADDRESS"
  },
  "accounts": {
    "manager": "$MANAGER_ADDRESS",
    "user1": "$USER1_ADDRESS",
    "user2": "$USER2_ADDRESS"
  },
  "seeded_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo "✅ Configuration saved to test-config.json"

echo ""
echo "🎉 Testnet seeding complete!"
echo ""
echo "Test accounts:"
echo "  Manager: $MANAGER_ADDRESS"
echo "  User1: $USER1_ADDRESS (1000 USDC, 100 deposited)"
echo "  User2: $USER2_ADDRESS (500 USDC)"
echo ""
echo "You can now run tests against this testnet state."
