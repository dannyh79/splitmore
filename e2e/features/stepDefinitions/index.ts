import { DataTable } from '@cucumber/cucumber';
import { Page, expect } from '@playwright/test';
import { createBdd } from 'playwright-bdd';
import DB, { QueryTypes } from '../support/db';

// ref: Splitmore.Groups.GroupUser schema
const roleValueMap = {
  0: 'default',
  1: 'admin',
};

const { After, Given, Then, When } = createBdd();

After(async () => {
  await DB.query('DELETE FROM expenses');
  await DB.query('DELETE FROM groups');
  await DB.query('DELETE FROM users');
  await DB.query('DELETE FROM groups_users');
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
  let q = `INSERT INTO expenses (id, name, amount, group_id, user_id, paid_by_id, inserted_at, updated_at)
VALUES `;
  const rows = data
    .hashes()
    .map(
      (d) =>
        `('${d.id}', '${d.name}', ${d.amount}, '${d.group_id}', '${d.user_id}', '${d.paid_by_id}', '${d.inserted_at}', '${d.updated_at}')`,
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
    .map((d) => `('${d.id}', '${d.name}', '${d.inserted_at}', '${d.updated_at}')`)
    .join(',');
  q += rows;
  await DB.query(q);
});

Given('there are users in group {string}:', async ({}, groupName: string, data: DataTable) => {
  const [group] = await DB.query<{ id: string }>(
    `SELECT id FROM groups WHERE name = '${groupName}'`,
    { type: QueryTypes.SELECT },
  );
  const userIds = await DB.query<{ id: string }>(
    `SELECT id FROM users WHERE email IN (${data
      .raw()
      .flat()
      .map((e) => `'${e}'`)
      .join(',')})`,
    { type: QueryTypes.SELECT },
  );
  let q = `INSERT INTO groups_users (group_id, user_id)
VALUES `;
  const rows = userIds.map((u) => `('${group.id}', '${u.id}')`).join(',');
  q += rows;
  await DB.query(q);
});

Given(
  'there are users by role in group {string}:',
  async ({}, groupName: string, data: DataTable) => {
    const invertedRoleValueMap = Object.assign(
      {},
      ...Object.entries(roleValueMap).map(([k, v]) => ({ [v]: k })),
    );

    const [group] = await DB.query<{ id: string }>(
      `SELECT id FROM groups WHERE name = '${groupName}'`,
      { type: QueryTypes.SELECT },
    );
    const dataRows = data.hashes();
    const userIds = await DB.query<{ id: string }>(
      `SELECT id FROM users WHERE email IN (${dataRows.map((u) => `'${u.email}'`).join(',')})`,
      { type: QueryTypes.SELECT },
    );
    let q = `INSERT INTO groups_users (group_id, user_id, role)
VALUES `;
    const rows = userIds
      .map((u, i) => `('${group.id}', '${u.id}', '${invertedRoleValueMap[dataRows[i].role]}')`)
      .join(',');
    q += rows;
    await DB.query(q);
  },
);

When('I visit {string}', async ({ page }, path: string) => {
  await page.goto(path);
});

When('I click {string}', async ({ page }, text: string) => {
  await page.getByText(text, { exact: true }).click({ force: true });
});

When('I have logged in as {string}', async ({ page }, email: string) => {
  await page.goto(`/test/api/login?email=${email}`);
});

When('I add the group expenses via {string}:', async ({ page }, path: string, data: DataTable) => {
  for (const row of data.hashes()) {
    await page.goto(path);
    await page.waitForLoadState('networkidle');

    await page.getByLabel('Name').fill(row.name);
    await page.getByLabel('Amount').fill(row.amount);
    await selectFromDropdown(page, 'Paid by', row.paid_by);
    await page.getByText('Save Expense').click();
  }
});

When('I update the expense:', async ({ page }, data: DataTable) => {
  await page.getByText('Edit', { exact: true }).click();
  await page.waitForLoadState('networkidle');

  const [row] = data.hashes();
  await page.getByLabel('Name').fill(row.name);
  await page.getByLabel('Amount').fill(row.amount);
  await selectFromDropdown(page, 'Paid by', row.paid_by);
  await page.getByText('Save Expense').click();
});

// NOTE: workaround for page.getByLabel().selectOption() not able to persist selected state
async function selectFromDropdown(
  page: Page,
  dropdownLabel: string,
  optionLabel: string,
): Promise<void> {
  const selectByLabel = (e: HTMLSelectElement, label: string) => {
    const option = Array.from(e.options).find((o) => o.label == label)!;
    option.selected = true;
  };
  await page.getByLabel(dropdownLabel).evaluate(selectByLabel, optionLabel);
}

When('I delete the expense {string}', async ({ page }, name: string) => {
  const deleteButton = page
    .locator(`#expenses > tr[id*="expenses-"]`)
    .filter({ hasText: name })
    .getByText('Delete');

  page.once('dialog', (dialog) => dialog.accept());
  await deleteButton.click();
});

When('I add the groups via {string}:', async ({ page }, path: string, data: DataTable) => {
  for (const row of data.hashes()) {
    await page.goto(path);
    await page.waitForLoadState('networkidle');
    await page.getByLabel('Name').fill(row.name);
    await page.getByText('Save Group').click();
  }
});

When('I update the group:', async ({ page }, data: DataTable) => {
  await page.getByText('Edit').click();
  await page.waitForLoadState('networkidle');

  const [row] = data.hashes();
  await page.getByLabel('Name').fill(row.name);
  await page.getByText('Save Group').click();
});

When('I delete the group {string}', async ({ page }, name: string) => {
  const deleteButton = page
    .locator(`#groups > tr[id*="groups-"]`)
    .filter({ hasText: name })
    .getByText('Delete');

  page.once('dialog', (dialog) => dialog.accept());
  await deleteButton.click();
});

Then('I can see the title {string}', async ({ page }, title: string) => {
  await expect(page).toHaveTitle(title);
});

Then('I can see {string}:', async ({ page }, text: string, data: DataTable) => {
  // FIXME: Fix this workaround that waits for liveview page update
  await page.waitForTimeout(250);

  await expect(page.getByText(text)).toBeVisible();

  const assertions = data
    .raw()
    .map((t) => expect(page.locator('main')).toContainText(t, { useInnerText: true }));
  Promise.all(assertions);
});

Then('I can see dialog {string}:', async ({ page }, text: string, data: DataTable) => {
  const dialog = page.getByRole('dialog');
  await expect(dialog).toBeVisible();

  const assertions = [text, ...data.raw()].map((t) =>
    expect(dialog).toContainText(t, { useInnerText: true }),
  );
  Promise.all(assertions);
});

Then('I can see the login button', async ({ page }) => {
  await expect(page.getByText(/Log in.*/i)).toBeVisible();
});

Then('I can see the expense:', async ({ page }, data: DataTable) => {
  const assertions = data
    .rows()
    .flat()
    .map((t) => expect(page.locator('main')).toContainText(t, { useInnerText: true }));
  Promise.all(assertions);
});

Then('I am redirected to {string}', async ({ page }, path: string) => {
  await expect(page).toHaveURL(path);
});

Then('I can see the expenses of group {string}', async ({ page }, name: string) => {
  const [rows] = await DB.query(`
      SELECT expenses.name, expenses.amount, users.email AS paid_by FROM expenses
      JOIN groups ON expenses.group_id = groups.id
      JOIN users ON expenses.paid_by_id = users.id
      WHERE groups.name = '${name}'
    `);
  const assertions = (rows as Record<string, string>[])
    .map((r) => Object.values(r))
    .flat()
    .map((s) =>
      expect(page.locator('#expenses > tr[id*="expenses-"]').getByText(s).first()).toBeVisible(),
    );
  Promise.all(assertions);
});

Then('I can see the groups', async ({ page }) => {
  const [rows] = await DB.query(`SELECT name FROM groups`);
  await expect(page.locator('#groups > tr[id*="groups-"]')).toContainText(
    rows.map((r) => (r as { name: string }).name),
  );
});

Then('There are users in group {string}:', async ({}, name: string, data: DataTable) => {
  const rows = await DB.query<{ email: string; role: number }>(
    `
    SELECT u.email, gu.role FROM groups_users AS gu
    JOIN users AS u ON gu.user_id = u.id
    JOIN groups AS g ON gu.group_id = g.id
    WHERE g.name = '${name}'
    AND u.email IN (${data
      .hashes()
      .map((u) => `'${u.email}'`)
      .join(',')})`,
    { type: QueryTypes.SELECT },
  );

  const expected = data.hashes();
  rows.forEach((r, i) => {
    expect(r.email).toEqual(expected[i].email);
    expect(roleValueMap[r.role]).toEqual(expected[i].role);
  });
});
