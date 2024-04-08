import { DataTable } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import DB from '../support/db';

const { After, Given, Then, When } = createBdd();

After(async () => {
  await DB.query('DELETE FROM expenses');
});

Given('there are expenses:', async ({}, data: DataTable) => {
  let q = `INSERT INTO expenses (id, name, amount, inserted_at, updated_at)
VALUES `;
  const rows = data
    .hashes()
    .map(
      (d) =>
        `('${d.id}', '${d.name}', ${d.amount}, '${d.inserted_at}', '${d.updated_at}')`,
    )
    .join(",");
  q += rows;
  await DB.query(q);
});

When('I visit {string}', async ({ page }, path: string) => {
  await page.goto(path);
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

Then('I can see the title {string}', async ({ page }, title: string) => {
  await expect(page).toHaveTitle(title);
});

Then('I can see the expenses', async ({ page }) => {
  const [rows] = await DB.query(`SELECT name FROM expenses`);
  await expect(page.locator('#expenses > tr[id*="expenses-"]')).toContainText(
    rows.map((r) => (r as { name: string }).name),
  );
});
