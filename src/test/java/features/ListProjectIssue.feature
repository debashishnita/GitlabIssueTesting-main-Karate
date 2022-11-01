@Read @ListProjectIssue
Feature: To Verify List Project Issue Functionality

  Background:
    * header Authorization = 'Bearer '+ tokenId
    * def projectID = 39946432
    * def incorrectProjectId = 3994643222

  Scenario Outline: Test if List Project is working fine for Endpoint :  <projectEndPoint>

    Given url baseUrl+'/projects/'+projectID+'/<projectEndPoint>'
    When method GET
    Then status 200
    #Ideally we should assert in more sophisticated way. But I have put assertion if correct project id returned for first issue.
    In responbse in postman few things were not clear to me, so i took a safe approach.
    But yes
    And match response[0].project_id == 39946432 yes
    I can put a loop there.
    And the verify for each

    Examples:
      | projectEndPoint                          |
      | issues                                   |
      | issues?assignee_id=none                  |
      | issues?author_id=12702659                |
      | issues?confidential=true                 |
      | issues?iids[]=42&iids[]=43               |
      | issues?labels=ABN                        |
      | issues?labels=P2,Regression              |
      | issues?labels=Regression,P2&state=closed |
      | issues?milestone=                        |
      | issues?milestone=&state=opened           |
      | issues?state=closed                      |
      | issues?state=opened                      |

  Scenario Outline: There must be error if project id is missing while accessing the Endpoints
    Given url baseUrl+'/projects/<projectEndPoint>'
    When method GET
    Then status 404
    And match $.message == '404 Project Not Found'
    Examples:
      | projectEndPoint                          |
      | issues                                   |
      | issues?assignee_id=5                     |
      | issues?author_id=5                       |
      | issues?confidential=true                 |
      | issues?iids[]=42&iids[]=43               |
      | issues?labels=foo                        |
      | issues?labels=foo,bar                    |
      | issues?labels=foo,bar&state=opened       |
      | issues?milestone=1.0.0                   |
      | issues?milestone=1.0.0&state=opened      |
      | issues?my_reaction_emoji=star            |
      | issues?search=issue+title+or+description |
      | issues?state=closed                      |
      | issues?state=opened                      |

  Scenario Outline: There must be error if we list the project with Incorrect project Id
    Given url baseUrl+'/projects/'+incorrectProjectId+'/<projectEndPoint>'
    When method GET
    Then status 404
    And match $.message == '404 Project Not Found'
    Examples:
      | projectEndPoint                          |
      | issues                                   |
      | issues?assignee_id=5                     |
      | issues?author_id=5                       |
      | issues?confidential=true                 |
      | issues?iids[]=42&iids[]=43               |
      | issues?labels=foo                        |
      | issues?labels=foo,bar                    |
      | issues?labels=foo,bar&state=opened       |
      | issues?milestone=1.0.0                   |
      | issues?milestone=1.0.0&state=opened      |
      | issues?my_reaction_emoji=star            |
      | issues?search=issue+title+or+description |
      | issues?state=closed                      |
      | issues?state=opened                      |

    #Below Scenario covers when user has insufficient permissions, to simulate this I gave a wrong OAuth2 token
  Scenario: There must be error if we edit an issue with insufficient permissions
    * header Authorization = 'Bearer '+ incorrectToken
    Given url baseUrl+'/projects/'+projectID+'/issues'
    When method GET
    Then status 401
    And match $.message == "401 Unauthorized"