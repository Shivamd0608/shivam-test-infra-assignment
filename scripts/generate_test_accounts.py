#!/usr/bin/env python3
"""
Generate test wallet accounts with private keys and addresses
Store securely for test automation
"""

import json
import os
from eth_account import Account
from datetime import datetime


def generate_test_accounts(num_accounts=5):
    """Generate test accounts with private keys"""
    accounts = []
    
    for i in range(num_accounts):
        account = Account.create()
        accounts.append({
            "name": f"test_user_{i+1}",
            "address": account.address,
            "private_key": account.key.hex(),
            "purpose": get_purpose(i)
        })
    
    return accounts


def get_purpose(index):
    """Get purpose for each test account"""
    purposes = [
        "Primary test user - has USDC balance",
        "Secondary test user - has USDC balance",
        "Whale account - large USDC balance",
        "Empty account - no balance (for error testing)",
        "Manager/Admin account"
    ]
    return purposes[index] if index < len(purposes) else "General test account"


def save_accounts(accounts, output_file):
    """Save accounts to JSON file"""
    data = {
        "generated_at": datetime.utcnow().isoformat(),
        "warning": "NEVER commit this file or use these keys on mainnet!",
        "accounts": accounts
    }
    
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"✅ Generated {len(accounts)} test accounts")
    print(f"📁 Saved to: {output_file}")
    print()
    
    # Print summary
    for acc in accounts:
        print(f"🔑 {acc['name']}")
        print(f"   Address: {acc['address']}")
        print(f"   Purpose: {acc['purpose']}")
        print()


def create_env_file(accounts, env_file):
    """Create .env file with test accounts"""
    with open(env_file, 'w') as f:
        f.write("# Test account configuration\n")
        f.write("# WARNING: For testnet use only!\n\n")
        
        for i, acc in enumerate(accounts):
            name = acc['name'].upper()
            f.write(f"{name}_ADDRESS={acc['address']}\n")
            f.write(f"{name}_PRIVATE_KEY={acc['private_key']}\n\n")
    
    print(f"✅ Created .env file: {env_file}")


if __name__ == "__main__":
    # Create output directory
    os.makedirs("../test-data", exist_ok=True)
    
    # Generate accounts
    accounts = generate_test_accounts(5)
    
    # Save to JSON
    save_accounts(accounts, "../test-data/test-accounts.json")
    
    # Create .env file
    create_env_file(accounts, "../test-data/.env.test")
    
    print("⚠️  IMPORTANT:")
    print("   - Never commit test-accounts.json or .env.test")
    print("   - Add them to .gitignore")
    print("   - Only use these accounts on testnets")
    print("   - Fund them with testnet tokens only")
