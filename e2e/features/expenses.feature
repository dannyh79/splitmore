Feature: Expenses Page
  Scenario: I can NOT see expenses list without logging in
    When I visit "/expenses"
    Then I am redirected to "/"
  Scenario: I can see expenses list
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 1024914b-ee65-4728-b687-8341f5affa89 | 午餐 | 5432   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/expenses"
    Then I can see the title "Listing Expenses"
    And I can see the expenses
  Scenario: I can add expenses
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/expenses"
    And I add the expenses via "/expenses/new":
    | name | amount |
    | 早餐 | 1234   |
    Then I can see the expenses
  Scenario: I can edit expenses
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/expenses"
    And I update the expense:
    | name | amount |
    | 午餐 | 5432   |
    Then I can see the expenses
  Scenario: I can delete expenses
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/expenses"
    And I delete the expense "早餐"
    Then I can see the expenses
