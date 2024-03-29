Feature:
  @api
  Scenario: Site module is visible.
  #  Given I am logged in as user "admin"
    Given I am logged in as a user with the "access toolbar,access about this site page,access site history page,save site report" permission
    When I am at "admin/site/about"
    Then I should see "Welcome to the Site Module!"
    When I click "History"
#    Then I should see "There are no site reports yet."
    Given I am at "admin/site/save"
    And I should see "PHP Version"
    And I should see "8.1"
    Given I am at "admin/site/save"
    And I should see "Drupal Version"
    And I should see "9.5"

#  @api
#  Scenario: Save site report.
#    Given I am logged in as a user with the "access about this site page,access site history page,save site report" permission
#    When I am at "admin/site/about"
#    # Then I should see "Welcome to the Site Module!"
##    When I click "Setup Site Manager"
#    And I should see "PHP Version"
#    And I should see "8.1"
#    And I should see "Drupal Version"
#    And I should see "9.5"

  @api
  Scenario: Add a site
    Given I am logged in as a user with the "create site,administer sites,view site" permissions
    And I am at "admin/content/site"
    When I click "Add site"
    Then I click "Website"
    And fill in the following:
      | Site URLs | https://google.com |
      | Label | google |

    Then I press "Save"
    Then print current URL
    Then I should see "New site google has been created."
#    And I should see "Drupal 7 (https://www.drupal.org)"

  @api
  Scenario: Add a Drupal site
    Given I am logged in as a user with the "create site,administer sites,view site" permissions
    And I am at "admin/content/site"
    When I click "Add site"
    Then I click "Drupal site"
    And fill in the following:
      | Site URLs | https://drupal.org |
      | Label | Drupal.Org |

    Then I press "Save"
    Then print current URL
    Then I should see "New site Drupal.Org has been created."
    And I should see "Drupal 7 (https://www.drupal.org)"

  @api
  Scenario: Save report on Config works.
  #  Given I am logged in as user "admin"
    Given I am logged in as a user with the "access about this site page,access site history page,administer site entity settings,administer site configuration,access site history page" permission
    And I am at "admin/site/about"
    When I click "Settings"
    And I check the box "Save site report on config changes"
    And I press "Save"
    # For debugging. Then print last response
    Then I should see "Site report saved:"
    Then I click "History"
    And I should see "Configs site.settings updated at"

  @api
  Scenario: Changing site title is recorded.
  #  Given I am logged in as user "admin"
    Given I am logged in as a user with the "access about this site page,access site history page,administer site entity settings,administer site configuration" permission
    Then I am at "admin/config/system/site-information"
    When I fill in "Site name" with "Behat Tested Site"
    # Not sure why frontpage is /user/login, but this user cannot change it.
    When I fill in "Default front page" with "/node"
    And I press "Save configuration"
    Then I should see "The configuration options have been saved."
    # Then I should see "Site report saved:"

    Then I am at "admin/site/history"
    # For debugging. Then print last response
    Then I should see "Configs system.site updated at"

    # @TODO: Site title does not get shown here anymore.
    # And I should see the link "Behat Tested Site"

    # @TODO: Add test for site entity title changes here.

  @api
  Scenario: Set state with drush
    Given I run drush "site:state all"
    Then print last drush output

    Given I run drush "site:state --state=warning --reason-label='Tests' --reason='Behat tests failed.'"
    Then print last drush output

    Given I am logged in as a user with the "access about this site page,access site history page,administer site entity settings,administer site configuration,access site history page" permission
    And I am at "admin/site/about"
    Then I should see "Warning"
    And I should see "Behat tests failed."
