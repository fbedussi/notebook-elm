// @ts-check
import { test, expect } from '@playwright/test';

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

test('can add a todo note', async ({ page }) => {
  await page.goto('/');

  // Open the form
  await page.getByTestId('add-note-btn').click()

  // Select the todo template
  await page.getByLabel('todo').check()

  // Add a note
  const title = 'fake title'
  const todo1text = 'fake todo 1'
  const todo2text = 'fake todo 2'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-todo-text-input').fill(' ');
  await page.getByTestId('note-todo-text-input').nth(0).fill(todo1text);
  await page.getByTestId('note-todo-text-input').nth(1).click();
  await page.getByTestId('note-todo-text-input').nth(1).fill(todo2text);
  await page.getByTestId('save-note-btn').click()

  // The form is closed
  await expect(page.getByTestId('add-note-form')).not.toBeVisible()

  // The note is saved
  await expect(page.getByText(title)).toBeVisible()
  await expect(page.getByText(todo1text)).toBeVisible()
  await expect(page.getByText(todo2text)).toBeVisible()
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

test('can open the add note form with a keyboard shortcut', async ({ page }) => {
  await page.goto('/');

  // The form is hidden by default
  await expect(page.getByTestId('add-note-form')).not.toBeVisible()

  // Open the form
  await page.keyboard.press('+')
  await expect(page.getByTestId('add-note-form')).toBeVisible()
});

test.skip('todos can be sorted with drag and drop', async ({ page }) => {
  await page.goto('/');

  // Open the form
  await page.getByTestId('add-note-btn').click()

  // Select the todo template
  await page.getByLabel('todo').check()

  // Add a note
  const title = 'fake title'
  const todo1text = 'fake todo 1'
  const todo2text = 'fake todo 2'

  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-todo-text-input').fill(' ');
  await page.getByTestId('note-todo-text-input').nth(0).fill(todo1text);
  await page.getByTestId('note-todo-text-input').nth(1).click();
  await page.getByTestId('note-todo-text-input').nth(1).fill(todo2text);


  await page.getByTestId('drag-icon').nth(0).dragTo(page.getByTestId('drag-icon').nth(1));
  await page.getByTestId('save-note-btn').click()

  // The note is saved and the todos are swapped
  await expect(page.getByText(title)).toBeVisible()
  await expect(page
    .getByRole('listitem'))
    .toHaveText([todo2text, todo1text]);
});

test('can add a note using markdown', async ({ page }) => {
  await page.goto('/');

  // Open the form
  await page.getByTestId('add-note-btn').click()
  await expect(page.getByTestId('add-note-form')).toBeVisible()

  // Add a note
  const title = 'fake title'
  const text = '# h1'
  await page.getByTestId('note-title-input').fill(title)
  await page.getByTestId('note-text-input').fill(text)
  await page.getByTestId('save-note-btn').click()

  // The note text is rendered as HTML
  await expect(page.getByRole('heading', { name: 'h1' })).toBeVisible()
});
