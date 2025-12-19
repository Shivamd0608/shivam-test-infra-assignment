describe('Wallet Connection', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should show connect wallet button', async () => {
    await expect(element(by.text('Connect Wallet'))).toBeVisible();
  });

  it('should connect wallet successfully', async () => {
    await element(by.text('Connect Wallet')).tap();
    await waitFor(element(by.text('WalletConnect')))
      .toBeVisible()
      .withTimeout(5000);
    
    await element(by.text('WalletConnect')).tap();
    
    // Wait for wallet connection (may require manual approval)
    await waitFor(element(by.text('Connected')))
      .toBeVisible()
      .withTimeout(30000);
    
    // Verify address is displayed
    await expect(element(by.id('wallet_address'))).toBeVisible();
    
    // Verify USDC balance is shown
    await expect(element(by.id('usdc_balance'))).toBeVisible();
  });

  it('should show wallet address after connection', async () => {
    await element(by.text('Connect Wallet')).tap();
    await element(by.text('WalletConnect')).tap();
    
    await waitFor(element(by.id('wallet_address')))
      .toBeVisible()
      .withTimeout(30000);
    
    const address = await element(by.id('wallet_address')).getAttributes();
    expect(address.text).toMatch(/^0x[a-fA-F0-9]{40}$/);
  });
});
