// @ts-check
const { test, expect } = require('@playwright/test');

test('single note page', async ({ page }) => {
  await page.goto('http://localhost:8000/');

  await page.getByTestId('add-note-btn').click()
  
  const title = 'fake title'
  const text = 'fake text'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  await page.getByTestId('edit-btn').click()
  
  // Go to single note page
  await page.waitForURL('**/note/*');
  
  // The note is open in edit mode
  await expect(page.getByTestId('note-title-input')).toBeVisible()
  await expect(page.getByTestId('note-text-input')).toBeVisible()
  await expect(page.getByTestId('save-note-btn')).toBeVisible()

  // When the form is pristine the save button is disabled
  await expect(page.getByTestId('save-note-btn')).toBeDisabled()

  // The note can be edited
  const title_edited = title + '_bis'
  await page.getByTestId('note-title-input').fill(title_edited)
 
  // When the form is dirty the save button is enabled
  await expect(page.getByTestId('save-note-btn')).toBeEnabled()

  await page.getByTestId('save-note-btn').click()

  // After save the save button is disabled
  await expect(page.getByTestId('save-note-btn')).toBeDisabled()

  // The modifications are persisted
  await page.reload()
  await expect(page.getByTestId('note-title-input')).toHaveValue(title_edited)

  // Go back to the list page
  await page.getByTestId('back-btn').click()
  await page.waitForURL('**/');
});
