import { expect } from "@playwright/test";
import { createBdd } from 'playwright-bdd';

const { When, Then } = createBdd();

When('I visit {string}', async ({ page }, path: string) => {
  await page.goto(`http://127.0.0.1:4000${path}`);
});

Then('I can see the title {string}', async ({ page }, title: string) => {
  await expect(page).toHaveTitle(title);
});
