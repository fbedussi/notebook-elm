// @ts-check
const { test, expect } = require('@playwright/test');

test('renders correctly', async ({ page }) => {
  await page.goto('http://localhost:8000/');

  await expect(page).toHaveTitle("Elm SPA boilerplate - Counter");

  await expect(page.getByTestId('counter-display')).toBeVisible()
  await expect(page.getByRole('button', {name: '-'})).toBeVisible()
  await expect(page.getByRole('button', {name: '+'})).toBeVisible()
});

test('updates counter', async ({ page }) => {
  await page.goto('http://localhost:8000/');

  await expect(page.getByTestId('counter-display')).toContainText('0')
  await page.getByRole('button', {name: '+'}).click()
  await expect(page.getByTestId('counter-display')).toContainText('1')
});
