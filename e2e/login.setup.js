import { test as setup, expect } from '@playwright/test';

const authFile = 'playwright/.auth/user.json';

setup('authenticate', async ({ page }) => {
  await page.goto('/');

  // The user is redirected to the login page
  await page.waitForURL('**/login');

  // Login
  await page.getByTestId('username-input').fill('test');
  await page.getByTestId('password-input').fill('test');
  await page.getByTestId('login-btn').click();
  
  // User is redirected to the home
  await page.waitForURL('**/');

  await page.context().storageState({ path: authFile });
});
