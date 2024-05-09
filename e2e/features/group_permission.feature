Feature: Group Permission
  Scenario: I can see group users in edit group modal
    Given there are users:
    | id                                   | email                    | provider | token                                    | inserted_at         | updated_at          |
    | 930ec9de-fac5-4d21-88da-ee41ea5f1615 | chenghsuan.han@gmail.com | github   | ghu_aaaaaaWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    | 2fd1e6d3-1dea-46ea-8e52-64d367198969 | another@example.com      | github   | ghu_bbbbbbWwmDecVuvtXDZ4nqSy3MGxa22XWQFK | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are groups:
    | id                                   | name     | inserted_at         | updated_at          |
    | 4e95b8e7-2ee4-450a-8250-1b605cec78a3 | 宮妙少年 | 2024-04-08 00:00:00 | 2024-04-08 00:00:00 |
    And there are users by role in group "宮妙少年":
    | email                    | role    |
    | chenghsuan.han@gmail.com | admin   |
    | another@example.com      | default |
    And I have logged in as "chenghsuan.han@gmail.com"
    When I visit "/groups/4e95b8e7-2ee4-450a-8250-1b605cec78a3/show/edit"
    Then I can see the title "Edit Group"
    And I can see dialog "Edit Group":
    | chenghsuan.han@gmail.com |
    | another@example.com      |
  Scenario: I am the group's admin after creating a group
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
