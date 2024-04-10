import { DataTable } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import DB from '../support/db';

const { After, Given, Then, When } = createBdd();

After(async () => {
  await DB.query('DELETE FROM expenses');
  await DB.query('DELETE FROM groups');
  await DB.query('DELETE FROM users');
});

Given('there are users:', async ({}, data: DataTable) => {
  let q = `INSERT INTO users (id, email, provider, token, inserted_at, updated_at)
VALUES `;
  const rows = data
    .hashes()
    .map(
      (d) =>
        `('${d.id}', '${d.email}', '${d.provider}', '${d.token}', '${d.inserted_at}', '${d.updated_at}')`,
    )
    .join(',');
  q += rows;
  await DB.query(q);
});

Given('there are expenses:', async ({}, data: DataTable) => {
  let q = `INSERT INTO expenses (id, name, amount, user_id, inserted_at, updated_at)
VALUES `;
  const rows = data
    .hashes()
    .map(
      (d) =>
        `('${d.id}', '${d.name}', ${d.amount}, '${d.user_id}', '${d.inserted_at}', '${d.updated_at}')`,
    )
    .join(',');
  q += rows;
  await DB.query(q);
});

Given('there are groups:', async ({}, data: DataTable) => {
  let q = `INSERT INTO groups (id, name, inserted_at, updated_at)
VALUES `;
  const rows = data
    .hashes()
    .map(
      (d) =>
        `('${d.id}', '${d.name}', '${d.inserted_at}', '${d.updated_at}')`,
    )
    .join(',');
  q += rows;
  await DB.query(q);
});

When('I visit {string}', async ({ page }, path: string) => {
  await page.goto(path);
});

When('I have logged in as {string}', async ({ page }, email: string) => {
  await page.goto(`/test/api/login?email=${email}`);
});

When('I add the expenses via {string}:', async ({ page }, path: string, data: DataTable) => {
  for (const row of data.hashes()) {
    await page.goto(path);
    await page.getByLabel('Name').fill(row.name);
    await page.getByLabel('Amount').fill(row.amount);
    await page.getByText('Save Expense').click();
  }
});

When('I update the expense:', async ({ page }, data: DataTable) => {
  await page.getByText('Edit').click();

  const [row] = data.hashes();
  await page.getByLabel('Name').fill(row.name);
  await page.getByLabel('Amount').fill(row.amount);
  await page.getByText('Save Expense').click();
});

When('I delete the expense {string}', async ({ page }, name: string) => {
  const deleteButton = page
    .locator(`#expenses > tr[id*="expenses-"]`)
    .filter({ hasText: name })
    .getByText('Delete');
  await deleteButton.click();
});

When('I add the groups via {string}:', async ({ page }, path: string, data: DataTable) => {
  for (const row of data.hashes()) {
    await page.goto(path);
    await page.getByLabel('Name').fill(row.name);
    await page.getByText('Save Group').click();
  }
});

When('I update the group:', async ({ page }, data: DataTable) => {
  await page.getByText('Edit').click();

  const [row] = data.hashes();
  await page.getByLabel('Name').fill(row.name);
  await page.getByText('Save Group').click();
});

When('I delete the group {string}', async ({ page }, name: string) => {
  const deleteButton = page
    .locator(`#groups > tr[id*="groups-"]`)
    .filter({ hasText: name })
    .getByText('Delete');
  await deleteButton.click();
});

Then('I can see the title {string}', async ({ page }, title: string) => {
  await expect(page).toHaveTitle(title);
});

Then('I can see the login button', async ({ page }) => {
  await expect(page.getByText(/Log in.*/i)).toBeVisible();
});

Then('I am redirected to {string}', async ({ page }, path: string) => {
  await expect(page).toHaveURL(path)
});

Then('I can see the expenses', async ({ page }) => {
  const [rows] = await DB.query(`SELECT name FROM expenses`);
  await expect(page.locator('#expenses > tr[id*="expenses-"]')).toContainText(
    rows.map((r) => (r as { name: string }).name),
  );
});

Then('I can see the groups', async ({ page }) => {
  const [rows] = await DB.query(`SELECT name FROM groups`);
  await expect(page.locator('#groups > tr[id*="groups-"]')).toContainText(
    rows.map((r) => (r as { name: string }).name),
  );
});
