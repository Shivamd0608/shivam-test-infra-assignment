# API Test Suite

Backend API testing infrastructure for TM Vault.

## Setup

```bash
cd api-test
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Running Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html

# Run specific test file
pytest tests/test_vault_api.py

# Run with verbose output
pytest -v

# Run tests matching a pattern
pytest -k "test_vault"
```

## Test Structure

```
api-test/
├── tests/
│   ├── conftest.py              # Shared fixtures
│   ├── test_vault_api.py        # Vault endpoint tests
│   ├── test_protocol_integration.py  # Protocol integration tests
│   └── test_websocket.py        # Real-time update tests
├── requirements.txt             # Python dependencies
└── README.md                    # This file
```

## Test Fixtures

### Database Fixtures
- `db_engine`: In-memory SQLite database
- `db_session`: Fresh database session per test
- `seeded_db`: Database pre-populated with test data

### Mock Fixtures
- `mock_blockchain`: Mock blockchain RPC responses
- `mock_failing_rpc`: Mock RPC failures for error testing

### API Fixtures
- `api_client`: FastAPI test client
- `authenticated_client`: Client with auth headers

### Data Fixtures
- `sample_vault_data`: Sample vault configuration
- `sample_user_data`: Sample user account data
- `sample_transaction_data`: Sample transaction data
- `test_accounts`: Pre-configured test addresses

## Writing New Tests

```python
def test_new_feature(api_client, seeded_db):
    """Test description"""
    response = api_client.get("/api/v1/endpoint")
    
    assert response.status_code == 200
    assert "expected_field" in response.json()
```

## Integration with CI

Tests are automatically run on:
- Every pull request
- Every commit to main branch
- Scheduled daily runs

See `.github/workflows/test.yml` for CI configuration.

## Coverage Goals

- Minimum 80% code coverage
- 100% coverage for critical paths (deposits, withdrawals)
- All error conditions must have tests
