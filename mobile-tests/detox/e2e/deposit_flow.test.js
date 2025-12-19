describe('Deposit Flow', () => {
  beforeAll(async () => {
    await device.launchApp();
    // Assume wallet is already connected
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should complete deposit successfully', async () => {
    // Navigate to vaults
    await element(by.text('Vaults')).tap();
    await element(by.text('TM Stable Vault')).tap();
    
    // Start deposit
    await element(by.id('deposit_button')).tap();
    
    // Enter amount
    await element(by.id('deposit_amount_input')).typeText('100');
    await element(by.id('deposit_amount_input')).tapReturnKey();
    
    // Verify amount is shown
    await expect(element(by.text('100 USDC'))).toBeVisible();
    
    // Check for approval if needed
    const approveButton = element(by.text('Approve USDC'));
    try {
      await waitFor(approveButton).toBeVisible().withTimeout(2000);
      await approveButton.tap();
      await waitFor(element(by.text('Approved')))
        .toBeVisible()
        .withTimeout(30000);
    } catch (e) {
      // Approval not needed
    }
    
    // Confirm deposit
    await element(by.id('confirm_deposit_button')).tap();
    
    // Wait for transaction
    await waitFor(element(by.text('Transaction Pending')))
      .toBeVisible()
      .withTimeout(5000);
    
    await waitFor(element(by.text('Deposit Successful')))
      .toBeVisible()
      .withTimeout(60000);
    
    // Verify balance updated
    await expect(element(by.id('new_balance'))).toBeVisible();
  });

  it('should show error for insufficient balance', async () => {
    await element(by.text('Vaults')).tap();
    await element(by.text('TM Stable Vault')).tap();
    await element(by.id('deposit_button')).tap();
    
    // Try to deposit more than balance
    await element(by.id('deposit_amount_input')).typeText('999999');
    await element(by.id('confirm_deposit_button')).tap();
    
    await expect(element(by.text('Insufficient balance'))).toBeVisible();
  });

  it('should allow max deposit', async () => {
    await element(by.text('Vaults')).tap();
    await element(by.text('TM Stable Vault')).tap();
    await element(by.id('deposit_button')).tap();
    
    // Tap max button
    await element(by.id('max_button')).tap();
    
    // Verify amount is filled
    const input = await element(by.id('deposit_amount_input')).getAttributes();
    expect(parseFloat(input.text)).toBeGreaterThan(0);
  });
});
