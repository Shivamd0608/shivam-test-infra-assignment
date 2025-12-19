"""
API Test Fixtures - Reusable components for backend testing
"""
import pytest
import responses
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import StaticPool
from datetime import datetime, timedelta
from decimal import Decimal

# Mock imports - adjust based on your actual API structure
# from app.main import app
# from app.database import Base, get_db
# from app.models import Protocol, Snapshot, User, Transaction

# Constants
RPC_URL = "https://eth-mainnet.g.alchemy.com/v2/test"
TEST_VAULT_ADDRESS = "0x1234567890123456789012345678901234567890"
TEST_USDC_ADDRESS = "0x2345678901234567890123456789012345678901"


# Database fixtures
@pytest.fixture(scope="function")
def db_engine():
    """Create in-memory SQLite database for testing"""
    engine = create_engine(
        "sqlite:///:memory:",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    # Base.metadata.create_all(bind=engine)
    return engine


@pytest.fixture(scope="function")
def db_session(db_engine):
    """Create a new database session for each test"""
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=db_engine)
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()


@pytest.fixture
def seeded_db(db_session):
    """Database with standard test data"""
    # Insert test protocols
    protocol_a_data = {
        "name": "Protocol A",
        "address": "0xAAAA1111222233334444555566667777888899990",
        "apy": Decimal("5.5"),
        "tvl": Decimal("1000000.00"),
        "risk_score": 3,
        "is_active": True,
    }
    
    protocol_b_data = {
        "name": "Protocol B",
        "address": "0xBBBB1111222233334444555566667777888899991",
        "apy": Decimal("8.2"),
        "tvl": Decimal("500000.00"),
        "risk_score": 5,
        "is_active": True,
    }
    
    # Insert test snapshots
    snapshot_data = {
        "vault_address": TEST_VAULT_ADDRESS,
        "total_assets": Decimal("1500000.00"),
        "total_shares": Decimal("1450000.00"),
        "timestamp": datetime.utcnow(),
    }
    
    # Insert test transactions
    tx_data = {
        "user_address": "0x1111222233334444555566667777888899990000",
        "tx_hash": "0xabcd1234567890abcd1234567890abcd1234567890abcd1234567890abcd1234",
        "type": "deposit",
        "amount": Decimal("100.00"),
        "timestamp": datetime.utcnow(),
    }
    
    # Add to session
    # protocol_a = Protocol(**protocol_a_data)
    # protocol_b = Protocol(**protocol_b_data)
    # snapshot = Snapshot(**snapshot_data)
    # transaction = Transaction(**tx_data)
    
    # db_session.add_all([protocol_a, protocol_b, snapshot, transaction])
    # db_session.commit()
    
    yield db_session


# Blockchain mock fixtures
@pytest.fixture
def mock_blockchain():
    """Mock blockchain RPC responses"""
    with responses.RequestsMock() as rsps:
        # Mock eth_blockNumber
        rsps.add(
            responses.POST,
            RPC_URL,
            json={"jsonrpc": "2.0", "id": 1, "result": "0x10e0d9e"},
            match=[
                responses.matchers.json_params_matcher(
                    {"jsonrpc": "2.0", "method": "eth_blockNumber"}
                )
            ],
        )
        
        # Mock eth_getBalance
        rsps.add(
            responses.POST,
            RPC_URL,
            json={"jsonrpc": "2.0", "id": 2, "result": "0xde0b6b3a7640000"},
            match=[
                responses.matchers.json_params_matcher(
                    {"jsonrpc": "2.0", "method": "eth_getBalance"}
                )
            ],
        )
        
        # Mock eth_call for USDC balance
        rsps.add(
            responses.POST,
            RPC_URL,
            json={
                "jsonrpc": "2.0",
                "id": 3,
                "result": "0x0000000000000000000000000000000000000000000000000000000005f5e100",
            },
            match=[
                responses.matchers.json_params_matcher(
                    {"jsonrpc": "2.0", "method": "eth_call"}
                )
            ],
        )
        
        # Mock eth_call for vault totalAssets
        rsps.add(
            responses.POST,
            RPC_URL,
            json={
                "jsonrpc": "2.0",
                "id": 4,
                "result": "0x00000000000000000000000000000000000000000000000000000000059682f0",
            },
        )
        
        yield rsps


@pytest.fixture
def mock_failing_rpc():
    """Mock RPC that returns errors"""
    with responses.RequestsMock() as rsps:
        rsps.add(
            responses.POST,
            RPC_URL,
            json={"jsonrpc": "2.0", "id": 1, "error": {"code": -32603, "message": "Internal error"}},
            status=500,
        )
        yield rsps


# API client fixtures
@pytest.fixture
def api_client(seeded_db):
    """FastAPI test client with seeded data"""
    
    # Override database dependency
    # def override_get_db():
    #     try:
    #         yield seeded_db
    #     finally:
    #         pass
    
    # app.dependency_overrides[get_db] = override_get_db
    
    # client = TestClient(app)
    # yield client
    
    # app.dependency_overrides.clear()
    
    # Placeholder until API is integrated
    yield None


@pytest.fixture
def authenticated_client(api_client):
    """API client with authentication headers"""
    # Add auth token or signature
    # api_client.headers["Authorization"] = "Bearer test_token"
    yield api_client


# Test data fixtures
@pytest.fixture
def sample_vault_data():
    """Sample vault data for testing"""
    return {
        "address": TEST_VAULT_ADDRESS,
        "name": "TM Stable Vault",
        "symbol": "tmUSDC",
        "asset": TEST_USDC_ADDRESS,
        "total_assets": "1500000000000",  # 1.5M USDC (6 decimals)
        "total_shares": "1450000000000",
        "apy": "6.5",
        "protocols": [
            {
                "address": "0xAAAA1111222233334444555566667777888899990",
                "name": "Protocol A",
                "allocation_percentage": 60,
            },
            {
                "address": "0xBBBB1111222233334444555566667777888899991",
                "name": "Protocol B",
                "allocation_percentage": 40,
            },
        ],
    }


@pytest.fixture
def sample_user_data():
    """Sample user data for testing"""
    return {
        "address": "0x1111222233334444555566667777888899990000",
        "usdc_balance": "100000000",  # 100 USDC
        "vault_balance": "50000000",  # 50 shares
    }


@pytest.fixture
def sample_transaction_data():
    """Sample transaction data for testing"""
    return {
        "tx_hash": "0xabcd1234567890abcd1234567890abcd1234567890abcd1234567890abcd1234",
        "from": "0x1111222233334444555566667777888899990000",
        "to": TEST_VAULT_ADDRESS,
        "type": "deposit",
        "amount": "100000000",  # 100 USDC
        "block_number": 18000000,
        "timestamp": datetime.utcnow().isoformat(),
        "status": "confirmed",
    }


# Helper fixtures
@pytest.fixture
def test_accounts():
    """Pre-configured test account addresses"""
    return {
        "manager": "0xMANAGER1111222233334444555566667777888899",
        "user1": "0xUSER11112222333344445555666677778888999900",
        "user2": "0xUSER22223333444455556666777788889999000011",
        "whale": "0xWHALE111222233334444555566667777888899990",
        "zero": "0x0000000000000000000000000000000000000000",
    }


@pytest.fixture
def reset_test_state():
    """Fixture to ensure clean state between tests"""
    # Setup
    yield
    # Teardown - clean up any test artifacts
    pass
