Feature: Groups Page
  Scenario: I can NOT see groups list without logging in
    When I visit "/groups"
    Then I am redirected to "/"
  Scenario: I can see groups list
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 1024914b-ee65-4728-b687-8341f5affa89 | 鼠窩     | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups"
    Then I can see the title "Listing Groups"
    And I can see the groups
  Scenario: I can add groups
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups"
    And I add the groups via "/groups/new":
    | name     |
    | 宮妙少年 |
    Then I can see the groups
    And There are users in group "宮妙少年":
    | email                    | role  |
    | chenghsuan.han@gmail.com | admin |
  Scenario: I can edit groups
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups"
    And I update the group:
    | name |
    | 鼠窩 |
    Then I can see the groups
  Scenario: I can delete groups
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | f185f505-d8c0-43ce-9e7b-bb9e8909072d | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups"
    And I delete the group "宮妙少年"
    Then I can see the groups
