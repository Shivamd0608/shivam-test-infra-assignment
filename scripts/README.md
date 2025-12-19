# Test Data Management

Scripts for managing test data and environments.

## Scripts

### generate_test_accounts.py
Generate test wallet accounts with private keys.

```bash
python3 scripts/generate_test_accounts.py
```

Generates:
- `test-data/test-accounts.json` - Account details
- `test-data/.env.test` - Environment variables

**⚠️ WARNING: Never commit these files! Testnet use only.**

### seed_testnet.sh
Seed testnet with initial state.

```bash
./scripts/seed_testnet.sh
```

Actions:
1. Deploys mock USDC contract
2. Mints USDC to test accounts
3. Deploys vault contract
4. Makes initial deposits
5. Saves configuration

### reset_environment.sh
Reset test environment to clean state.

```bash
./scripts/reset_environment.sh
```

Actions:
1. Stops running nodes
2. Cleans databases
3. Removes artifacts
4. Starts fresh local node
5. Deploys contracts

### verify_setup.sh
Verify test environment is correctly configured.

```bash
./scripts/verify_setup.sh
```

Checks:
- Dependencies installed
- Test accounts configured
- RPC connectivity
- File structure
- Git configuration

## Test Account Usage

### Test User 1
- **Purpose**: Primary test user with balance
- **Initial Balance**: 1000 USDC
- **Use for**: Normal deposit/withdraw flows

### Test User 2
- **Purpose**: Secondary test user
- **Initial Balance**: 500 USDC
- **Use for**: Multi-user scenarios

### Test User 3
- **Purpose**: Whale account
- **Initial Balance**: 100,000 USDC
- **Use for**: Large transaction testing

### Test User 4
- **Purpose**: Empty account
- **Initial Balance**: 0 USDC
- **Use for**: Error handling tests

### Test User 5 (Manager)
- **Purpose**: Admin/manager role
- **Permissions**: Contract deployment, admin functions
- **Use for**: Management operations

## Resetting Between Test Runs

### Quick Reset (Database only)
```bash
rm api-test/test.db
rm -rf mobile-tests/screenshots/*
```

### Full Reset (Everything)
```bash
./scripts/reset_environment.sh
```

## Test Data Files

```
test-data/
├── test-accounts.json      # Generated accounts (DO NOT COMMIT)
├── .env.test              # Environment variables (DO NOT COMMIT)
├── anvil.log              # Local node logs
├── anvil.pid              # Local node PID
└── snapshots/             # Blockchain state snapshots
```

## Security Notes

1. **Never use test keys on mainnet**
2. **Add test-data/ to .gitignore**
3. **Store production keys in secure vault (1Password, etc.)**
4. **Rotate test keys periodically**
5. **Only fund with testnet tokens**

## Maintenance

### Weekly
- Verify testnet balances
- Check if testnet contracts are still deployed
- Update dependencies

### Monthly
- Rotate test accounts
- Review and update test data
- Archive old test results
