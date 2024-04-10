Feature: Group expenses Page
  Scenario: I can NOT see group group expenses list without logging in
    When I visit "/groups/2fd1e6d3-1dea-46ea-8e52-64d367198969"
    Then I am redirected to "/"
