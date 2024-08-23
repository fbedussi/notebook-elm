// @ts-check
const { test, expect } = require('@playwright/test');

test('can add a note', async ({ page }) => {
  await page.goto('/');

  // The form is hidden by default
  await expect(page.getByTestId('add-note-form')).not.toBeVisible()

  // Open the form
  await page.getByTestId('add-note-btn').click()
  await expect(page.getByTestId('add-note-form')).toBeVisible()
  
  // Add a note
  const title = 'fake title'
  const text = 'fake text'
  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  // The form is closed
  await expect(page.getByTestId('add-note-form')).not.toBeVisible()

  // The note is saved
  await expect(page.getByText(title)).toBeVisible()
  await expect(page.getByText(text)).toBeVisible()
});

test('can delete a note', async ({ page }) => {
  await page.goto('/');

  await page.getByTestId('add-note-btn').click()
  
  const title = 'fake title'
  const text = 'fake text'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  await expect(page.getByText(title)).toBeVisible()
  await expect(page.getByText(text)).toBeVisible()

  await page.getByTestId('delete-note-btn').click()

  await expect(page.getByTestId('delete-note-confirmation')).toBeVisible()

  await page.getByTestId('ok-btn').click()

  await expect(page.getByTestId('note')).not.toBeVisible()
});

test('can copy a note', async ({ page }) => {
  await page.goto('/');

  // Add a note
  await page.getByTestId('add-note-btn').click()
  const title = 'fake title'
  const text = 'fake text'
  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  // Copy the note
  await page.getByTestId('copy-note-btn').click()
  
  // The note is saved
  await expect(page.getByText(title + ' (copy)')).toBeVisible()
  await expect(page.getByText(text)).toHaveCount(2)
});
