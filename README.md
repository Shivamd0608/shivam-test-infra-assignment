# TM Vault Test Infrastructure

Comprehensive test infrastructure covering smart contracts, backend API, and mobile app for TM Vault.

## 🎯 Project Overview

This repository contains a complete test infrastructure that ensures the TM Vault works correctly before touching user funds. It includes:

- **Smart contract tests** (Foundry/Forge)
- **Backend API tests** (pytest)
- **Mobile E2E tests** (Maestro)
- **Test data management scripts**
- **CI/CD integration**
- **Coverage tracking**

## 📁 Structure

```
├── smart-contract-tests/      # Foundry tests for Solidity contracts
│   ├── test/
│   │   ├── fixtures/          # Reusable test fixtures
│   │   ├── unit/              # Unit tests
│   │   ├── integration/       # Integration tests
│   │   └── fuzz/              # Fuzz tests
│   ├── src/                   # Smart contracts
│   └── foundry.toml           # Foundry configuration
│
├── api-test/                  # Backend API tests
│   ├── tests/
│   │   ├── conftest.py        # Pytest fixtures
│   │   ├── test_vault_api.py  # Vault endpoint tests
│   │   └── ...
│   └── requirements.txt       # Python dependencies
│
├── mobile-tests/              # Mobile E2E tests
│   ├── maestro/               # Maestro test flows
│   │   ├── connect_wallet.yaml
│   │   ├── deposit_flow.yaml
│   │   └── ...
│   └── detox/                 # Detox tests (alternative)
│
├── scripts/                   # Test data management
│   ├── generate_test_accounts.py
│   ├── seed_testnet.sh
│   ├── reset_environment.sh
│   └── verify_setup.sh
│
├── .github/workflows/         # CI/CD workflows
│   ├── test.yml               # Main test suite
│   ├── mobile-tests.yml       # Mobile-specific tests
│   └── coverage.yml           # Coverage checks
│
└── TEST_COVERAGE.md           # Coverage matrix & goals
```

## 🚀 Quick Start

### Prerequisites

```bash
# Install Foundry (smart contract tests)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install Python 3.11+ (API tests)
python3 --version

# Install Maestro (mobile tests)
curl -Ls "https://get.maestro.mobile.dev" | bash
```

### Setup

```bash
# Verify setup
./scripts/verify_setup.sh

# Generate test accounts
python3 scripts/generate_test_accounts.py

# Install dependencies
cd smart-contract-tests && forge install
cd ../api-test && pip install -r requirements.txt
```

## 🧪 Running Tests

### Smart Contract Tests

```bash
cd smart-contract-tests

# Run all tests
forge test

# Run with coverage
forge coverage

# Run gas report
forge test --gas-report
```

### API Tests

```bash
cd api-test

# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html
```

### Mobile Tests

```bash
cd mobile-tests

# Run all Maestro flows
maestro test maestro/

# Run specific flow
maestro test maestro/deposit_flow.yaml
```

## 📊 Test Coverage

Current coverage status: See [TEST_COVERAGE.md](TEST_COVERAGE.md)

| Component | Coverage | Status |
|-----------|----------|--------|
| Smart Contracts | 92% | ✅ |
| API | 75% | ⚠️ |
| Mobile | 90% | ✅ |

## �� Test Data Management

### Generate Test Accounts
```bash
python3 scripts/generate_test_accounts.py
```

### Seed Testnet
```bash
./scripts/seed_testnet.sh
```

### Reset Environment
```bash
./scripts/reset_environment.sh
```

## 🎯 Key Features

### ✅ Reusable Test Fixtures
- VaultFixture for smart contracts
- Database fixtures for API tests
- Pre-configured test accounts

### ✅ Comprehensive Coverage
- Unit tests for individual functions
- Integration tests for cross-component flows
- E2E tests for user journeys
- Fuzz tests for edge cases

### ✅ Test Isolation
- Fresh state for each test
- No shared state between tests
- Mock external dependencies

### ✅ Automated Regression Detection
- CI runs on every PR
- Coverage must not decrease
- Failed tests block merging

## 📚 Documentation

- [Test Coverage Report](TEST_COVERAGE.md)
- [API Test README](api-test/README.md)
- [Mobile Test README](mobile-tests/README.md)
- [Scripts README](scripts/README.md)

## 🔒 Security

- **Never commit private keys** (even for testnet)
- Test accounts are in `.gitignore`
- Use environment variables for secrets
- Testnet only - never test with real funds

---

**Built with:** Foundry, pytest, Maestro, GitHub Actions
