Feature: User avatars
    A user should have a default avatar
    A user should be able to change its own avatar
    An administrator of an organization should be able to change the avatar of a member of the organization

  Scenario: Default avatar
    Given I am logged in
    When I load a user's profile page
    Then I see his avatar

  Scenario: Changing one's avatar
    Given I am logged in
    And I load my profile edit form
    When I upload a new avatar
    Then I see my avatar changed

  Scenario: An admin changing a user's avatar
    Given I am logged in as an administrator
    And I load a user's profile edit form
    When I upload a new avatar
    Then I see the user's avatar changed
