@Create @CloneIssue
Feature: To Verify Clone a Issue Functionality

  Background:
    * header Authorization = 'Bearer '+ tokenId

    #Below scenario is for positive case when valid values are provided for Project ID, Issue Id and with_note_value
  # Sometimes clone issue API takes long(>5 seconds) and because of this http call fails
  Scenario Outline: Clone a Issue when value of with_notes is <withNoteValue>
    Given url baseUrl+'/projects/<oldProjectId>/issues/<issueId>/clone/?with_notes=<withNoteValue>&to_project_id=<newProjectId>'
    When method  POST
    Then status 201
    And match $.project_id == <newProjectId>
    Examples:
      | oldProjectId | newProjectId | issueId | withNoteValue |
      | 39946432     | 39952225     | 40      | true          |
      | 39946432     | 39952225     | 40      | false         |
      | 39946432     | 39952225     | 40      |               |


    #Below scenario is for negative case when Old ProjectId and Issue Id is missing in the request
  Scenario Outline: There must be error if we clone a Issue when issueId or old ProjectId or new ProjectId are missing
    Given url baseUrl+'/projects/<oldProjectId>/issues/<issueId>/clone/?with_notes=<withNoteValue>&to_project_id=<newProjectId>'
    When method POST
    Then status 404
    And match $.<attribute> == <errorMessage>
    Examples:
      | oldProjectId | newProjectId | issueId | withNoteValue | attribute | errorMessage            |
      |              | 39952225     | 31      | true          | error     | '404 Not Found'         |
      | 39946432     | 39952225     |         |               | error     | '404 Not Found'         |
      | 39946432     |              | 31      | false         | message   | '404 Project Not Found' |


       #Below Scenario is for when we give wrong values for Project Ids (Old and New)
  Scenario Outline: There must be error if we clone a Issue with incorrect value of Project ID or Issue ID and with_notes_value is <withNoteValue>
    Given url baseUrl+'/projects/<oldProjectId>/issues/<issueId>/clone/?with_notes=<withNoteValue>&to_project_id=<newProjectId>'
    When method POST
    Then status 404
    And match $.<attribute> == <errorMessage>
    Examples:
      | oldProjectId | newProjectId | issueId | withNoteValue | attribute | errorMessage            |
      | 3994643222   | 39952225     | 31      | true          | message   | '404 Project Not Found' |
      | 39946432     | 3995222555   | 31      | false         | message   | '404 Project Not Found' |
      | 39946432     | 39952225     | 3111    | true          | message   | '404 Issue Not Found'   |
      | 39946432     | 39952225     | 3111    | false         | message   | '404 Issue Not Found'   |


    #Below Scenario covers when user has insufficient permissions, to simulate this I gave a wrong OAuth2 token
  Scenario Outline: There must be error if we clone a Issue with insufficient permissions and with_notes is <withNoteValue>
    * header Authorization = 'Bearer '+ incorrectToken
    Given url baseUrl+'/projects/<oldProjectId>/issues/<issueId>/clone/?with_notes=<withNoteValue>&to_project_id=<newProjectId>'
    When method POST
    Then status 401
    And match $.message == "401 Unauthorized"
    Examples:
      | oldProjectId | newProjectId | issueId | withNoteValue |
      | 39946432     | 39952225     | 31      | true          |
      | 39946432     | 39952225     | 31      | false         |
      | 39946432     | 39952225     | 31      |               |

