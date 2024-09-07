// @ts-check
import { test, expect } from '@playwright/test';

test('Add & edit a note, back button', async ({ page }) => {
  await page.goto('/');

  await page.getByTestId('add-note-btn').click()

  const title = 'fake title'
  const text = 'fake text'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  // Go to single note page
  await page.getByTestId('edit-btn').click()
  await page.waitForURL('**/note/*');

  // The note is open in edit mode
  await expect(page.getByTestId('note-title-input')).toBeVisible()
  await expect(page.getByTestId('note-text-input')).toBeVisible()
  await expect(page.getByTestId('save-note-btn')).toBeVisible()
  await expect(page.getByTestId('note-title-input')).toHaveValue(title)
  await expect(page.getByTestId('note-text-input')).toHaveValue(text)

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


test('can delete a note', async ({ page }) => {
  // add a note
  await page.goto('/');

  await page.getByTestId('add-note-btn').click()

  const title = 'fake title'
  const text = 'fake text'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  // Go to single note page
  await page.getByTestId('edit-btn').click()
  await page.waitForURL('**/note/*');

  // The note is visible
  await expect(page.getByTestId('note-title-input')).toHaveValue(title)
  await expect(page.getByTestId('note-text-input')).toHaveValue(text)

  // Delete the note
  await page.getByTestId('delete-note-btn').click()
  await expect(page.getByTestId('delete-note-confirmation')).toBeVisible()
  await page.getByTestId('ok-btn').click()

  // The user is redirect to the home
  await page.waitForURL('**/');

  // the note is not shown
  await expect(page.getByTestId('note')).not.toBeVisible()
});

test('can copy a note', async ({ page }) => {
  // add a note
  await page.goto('/');

  await page.getByTestId('add-note-btn').click()

  const title = 'fake title'
  const text = 'fake text'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  // Go to single note page
  await page.getByTestId('edit-btn').click()
  await page.waitForURL('**/note/*');

  // Copy the note
  await page.getByTestId('copy-note-btn').click()

  // The note is saved
  await expect(page.getByTestId('note-title-input')).toHaveValue(title + ' (copy)')
});

test('can edit a todo note', async ({ page }) => {
  await page.goto('/');

  // Open the form
  await page.getByTestId('add-note-btn').click()

  // Add a todo note
  await page.getByLabel('todo').check()
  const title = 'fake title'
  const todo1text = 'fake todo 1'
  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-todo-text-input').fill(todo1text);
  await page.getByTestId('save-note-btn').click()

  // Go to single note page
  await page.getByTestId('edit-btn').click()
  await page.waitForURL('**/note/*');

  // The note is open in edit mode
  await expect(page.getByTestId('note-title-input')).toBeVisible()
  await expect(page.getByTestId('note-todo-done-input').first()).toBeVisible()
  await expect(page.getByTestId('note-todo-text-input').first()).toBeVisible()
  await expect(page.getByTestId('save-note-btn')).toBeVisible()
  await expect(page.getByTestId('note-title-input')).toHaveValue(title)
  await expect(page.getByTestId('note-todo-text-input').first()).toHaveValue(todo1text)

  // When the form is pristine the save button is disabled
  await expect(page.getByTestId('save-note-btn')).toBeDisabled()

  // The note can be edited
  const title_edited = title + '_bis'
  await page.getByTestId('note-title-input').fill(title_edited)
  const todo1text_edited = todo1text + '_bis'
  await page.getByTestId('note-todo-text-input').first().fill(todo1text_edited)


  // When the form is dirty the save button is enabled
  await expect(page.getByTestId('save-note-btn')).toBeEnabled()

  await page.getByTestId('save-note-btn').click()

  // After save the save button is disabled
  await expect(page.getByTestId('save-note-btn')).toBeDisabled()

  // The modifications are persisted
  await page.reload()
  await expect(page.getByTestId('note-title-input')).toHaveValue(title_edited)
  await expect(page.getByTestId('note-todo-text-input').first()).toHaveValue(todo1text_edited)

});

test('a new todo is added when the last one is filled in', async ({ page }) => {
  await page.goto('/');

  // Open the form
  await page.getByTestId('add-note-btn').click()

  // Add a todo note
  await page.getByLabel('todo').check()
  const title = 'fake title'
  const todo1text = 'fake todo 1'
  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-todo-text-input').fill(todo1text);
  await page.getByTestId('save-note-btn').click()

  // Go to single note page
  await page.getByTestId('edit-btn').click()
  await page.waitForURL('**/note/*');
  await expect(page.getByTestId('note-title-input')).toBeVisible()

  // There are 2 todo rows
  await expect(await page.getByTestId('note-todo-text-input').count()).toBe(2)

  // fill in the last one
  const todo2text = 'fake todo 2'
  await page.getByTestId('note-todo-text-input').nth(1).fill(todo2text);

  // a new todo row is added 
  await expect(await page.getByTestId('note-todo-text-input').count()).toBe(3)
});
