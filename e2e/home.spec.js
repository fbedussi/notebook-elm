// @ts-check
const { test, expect } = require('@playwright/test');

test('can add a note', async ({ page }) => {
  await page.goto('http://localhost:8000/');

  await expect(page.getByTestId('add-note-form')).not.toBeVisible()

  await page.getByTestId('add-note-btn').click()
  
  await expect(page.getByTestId('add-note-form')).toBeVisible()
  
  const title = 'fake title'
  const text = 'fake text'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  await expect(page.getByTestId('add-note-form')).not.toBeVisible()

  await expect(page.getByText(title)).toBeVisible()
  await expect(page.getByText(text)).toBeVisible()
});
