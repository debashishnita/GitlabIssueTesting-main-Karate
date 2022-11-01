@Delete @DeleteIssue
Feature: To Verify Delete Issue API

  Background:
    #* header Authorization = 'Bearer '+ tokenId
    * configure headers = { Authorization: "#('Bearer ' + tokenId)" }
    * def projectId = 39946432
    * def issueId = 30

  Scenario: Delete a issue after creating it

    Given url baseUrl+'/projects/'+projectId+'/issues?title=Issues%20with%20auth&labels=bug'
    When method POST
    Then status 201
    #capture the generate issueId in a variable to be passed in delete API call
    * def issueToBeDeleted = response.iid
    #* header Authorization = 'Bearer '+ tokenId
    Given url baseUrl+'/projects/'+projectId+'/issues/'+ issueToBeDeleted
    When method DELETE
    Then status 204

    #IT SHOULD NOT GET DELETED ONCE ITS ALREADY DELETED - SHOULD GET ERROR MESSAGE FOR IT


  Scenario Outline: There must be error if we delete the issue if issueId or project ID are missing or incorrect is request
    Given url baseUrl+'/projects/<projectId>/issues/<issueId>'
    When method DELETE
    Then status 404
    And match $.<attribute> == <errorMessage>
    Examples:
      | projectId  | issueId | attribute | errorMessage            |
      | 39946432   |         | error     | '404 Not Found'         |
      |            | 32      | error     | '404 Not Found'         |
      | 3994643222 | 32      | message   | '404 Project Not Found' |
      | 39946432   | 3222    | message   | '404 Issue Not Found'   |


     #Below Scenario covers when user has insufficient permissions, to simulate this I gave a wrong OAuth2 token
  Scenario: There must be error if we edit an issue with insufficient permissions
    * header Authorization = 'Bearer '+ incorrectToken
    Given url baseUrl+'/projects/'+ projectId + '/issues/'+issueId+'?issue_type=incident'
    When method DELETE
    Then status 401
    And match $.message == "401 Unauthorized"
