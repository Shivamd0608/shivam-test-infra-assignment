# Mobile E2E Test Suite (Maestro)

Mobile app testing infrastructure for TM Vault.

## Prerequisites

### Install Maestro
```bash
# macOS/Linux
curl -Ls "https://get.maestro.mobile.dev" | bash

# Windows
# Download from https://maestro.mobile.dev
```

### Setup
```bash
# Verify installation
maestro -v

# Connect device
# For Android: Enable USB debugging
# For iOS: Trust developer certificate

maestro test --device <device-id>
```

## Running Tests

```bash
# Run all tests
maestro test maestro/

# Run specific test
maestro test maestro/connect_wallet.yaml

# Run with specific device
maestro test maestro/ --device emulator-5554

# Run in continuous mode (watches for changes)
maestro test maestro/ --continuous

# Generate report
maestro test maestro/ --format junit --output test-results.xml
```

## Test Flows

### Core Flows
- `connect_wallet.yaml` - Wallet connection flow
- `deposit_flow.yaml` - Deposit USDC into vault
- `withdraw_flow.yaml` - Withdraw from vault
- `error_handling.yaml` - Error scenarios

### Additional Flows
- `realtime_updates.yaml` - Test notifications and updates
- `portfolio_view.yaml` - Portfolio and position tracking
- `transaction_history.yaml` - View past transactions

## Test Structure

```yaml
appId: com.tmvault.app
---
- launchApp
- tapOn: "Button Text"
- assertVisible: "Expected Text"
- takeScreenshot: screenshots/name.png
```

## Device Setup

### Android Testnet Setup
```bash
# Install app
adb install app-debug.apk

# Setup wallet with testnet
# 1. Install MetaMask
# 2. Connect to Sepolia/Goerli
# 3. Add test USDC contract
```

### iOS Testnet Setup
```bash
# Install via TestFlight or Xcode
# Configure wallet for testnet
```

## Test Accounts

### Test Wallet 1 (Has USDC)
- Address: `0xTEST1111222233334444555566667777888899990`
- Private Key: (stored in 1Password)
- Balance: 1000 USDC (testnet)

### Test Wallet 2 (Empty)
- Address: `0xTEST2222333344445555666677778888999900001`
- Private Key: (stored in 1Password)
- Balance: 0 USDC

## Screenshots

All test screenshots are saved to `screenshots/` directory:
- `wallet_connected.png`
- `deposit_success.png`
- `withdraw_success.png`
- `error_*.png`

## Debugging Failed Tests

```bash
# Run with verbose logging
maestro test maestro/flow.yaml --debug

# Record test execution
maestro record maestro/flow.yaml

# Take screenshot at failure
maestro test maestro/flow.yaml --screenshot-on-failure
```

## Integration with CI

Tests run automatically on:
- Pull requests (using cloud device farm)
- Scheduled nightly runs
- Before app releases

See `.github/workflows/mobile-tests.yml` for CI configuration.

## Cloud Testing

### Maestro Cloud
```bash
# Upload and run tests on cloud devices
maestro cloud --apiKey <key> maestro/

# Test on multiple devices
maestro cloud --apiKey <key> \
  --android-api-level 29,30,31 \
  --ios-version 15,16 \
  maestro/
```

## Best Practices

1. **Always reset app state** between tests
2. **Use test accounts** with known balances
3. **Handle async operations** with proper waits
4. **Screenshot critical steps** for debugging
5. **Test both success and error paths**
6. **Use testnet** to avoid real funds

## Alternative: Detox Setup

If Maestro doesn't work for your setup, Detox tests are in `detox/` directory.

```bash
cd detox
npm install
npx detox test
```
