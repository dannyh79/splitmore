Feature: Home Page
  Scenario: I can see home page
    When I visit "/"
    Then I can see the title "Splitmore"
    Then I can see the login button
