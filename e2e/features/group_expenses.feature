Feature: Group expenses Page
  Scenario: I can NOT see group group expenses list without logging in
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    Then I am redirected to "/"
  Scenario: I can see group expenses list
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | another@example.com      | github   | ghu_bbbbbbWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 199862b8-5789-4290-9747-a95573bede66 | 鼠窩     | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | group_id                             | paid_by_id                           | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 1024914b-ee65-4728-b687-8341f5affa89 | 午餐 | 5432   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 5a42823b-68af-4a6e-8bcf-75991930a119 | 晚餐 | 4321   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 199862b8-5789-4290-9747-a95573bede66 | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    Then I can see the title "Show 宮妙少年 Expenses"
    And I can see the expenses of group "宮妙少年"
    And I can see "Summary":
    | chenghsuan.han@gmail.com owes another@example.com $2,099 |
  Scenario: I can add group expenses
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | another@example.com      | github   | ghu_bbbbbbWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    And I add the group expenses via "/groups/930ec9de-fac5-4d21-88da-ee41ea5f1615/expenses/new":
    | name | amount | paid_by                  |
    | 早餐 | 1234   | chenghsuan.han@gmail.com |
    | 午餐 | 5432   | another@example.com      |
    Then I can see the expenses of group "宮妙少年"
  Scenario: I can view a group expense
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | group_id                             | paid_by_id                           | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    And I click "早餐"
    Then I can see the expense:
    | name | amount | paid_by                  |
    | 早餐 | 1234   | chenghsuan.han@gmail.com |
  Scenario: I can edit group expenses
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | another@example.com      | github   | ghu_bbbbbbWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | group_id                             | paid_by_id                           | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    And I update the expense:
    | name | amount | paid_by             |
    | 午餐 | 5432   | another@example.com |
    Then I am redirected to "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    And I can see the expenses of group "宮妙少年"
  Scenario: I can delete group expenses
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are expenses:
    | id                                   | name | amount | user_id                              | group_id                             | paid_by_id                           | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 早餐 | 1234   | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    And I delete the expense "早餐"
    Then I can see the expenses of group "宮妙少年"
