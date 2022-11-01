@Update @EditIssue @parallel=false
Feature: To Verify Edit a Issue Functionality

  Background:
    * header Authorization = 'Bearer '+ tokenId
    * def projectId = 39946432
    * def issueId = 31

  Scenario Outline: Edit the issue Attribute: <attribute> Value: <value>
    Given url baseUrl+'/projects/'+ projectId + '/issues/'+issueId+'<endpoint>'
    When method PUT
    Then status 200
    And match $.<attribute> == <value>
    Examples:
      | endpoint                  | attribute         | value                     |
      | ?confidential=true        | confidential      | true                      |
      | ?description=GitLabTest   | description       | 'GitLabTest'              |
      | ?discussion_locked=false  | discussion_locked | false                     |
      | ?due_date=2022-10-05      | due_date          | '2022-10-05'              |
      | ?issue_type=incident      | issue_type        | 'incident'                |
      | ?issue_type=incident      | issue_type        | 'incident'                |
      | ?state_event=close        | state             | 'closed'                  |
      | ?title=GitLabTitle        | title             | 'GitLabTitle'             |
      | ?labels=ABN               | labels            | ['ABN']                   |
      | ?remove_labels=ABN        | labels            | []                        |
      #For multiple labels API is adding second label is added before the first label in the List and so on.
      #That's why in assertion order of label is reversed for verification.
      | ?labels=Regression,P2,ABN | labels            | ['ABN','P2','Regression'] |
      #I wasn't aware of valid milestone IDs so set it to 0 to verify if API works
      | ?milestone_id=0           | milestone         | null                      |
      | ?assignee_ids=12702659    | assignees[0].id   | 12702659                  |

  Scenario: There must be error if we edit the issue when none of the mandatory parameters is present
    Given url baseUrl+'/projects/'+ projectId + '/issues/'+issueId+'?updated_at=2016-03-11T03:45:40Z'
    When method PUT
    Then status 400
    And match $.error == 'assignee_id, assignee_ids, confidential, created_at, description, discussion_locked, due_date, labels, add_labels, remove_labels, milestone_id, state_event, title, issue_type, weight, epic_id, epic_iid are missing, at least one parameter must be provided'

  Scenario Outline: There must be error if we edit the issue when issueId or project ID are missing or Invalid is request
    Given url baseUrl+'/projects/<projectId>/issues/<issueId>?issue_type=incident'
    When method PUT
    Then status 404
    And match $.<attribute> == <errorMessage>
    Examples:
      | projectId  | issueId | attribute | errorMessage            |
      | 39946432   |         | error     | '404 Not Found'         |
      |            | 30      | error     | '404 Not Found'         |
      | 3994643222 | 30      | message   | '404 Project Not Found' |
      | 39946432   | 3222    | message   | '404 Not found'         |
#Ideally in last case we must get error as '404 Issue Not Found' instead of '404 Not found'

    #Below Scenario covers when user has insufficient permissions, to simulate this I gave a wrong OAuth2 token
  Scenario: There must be error if we edit an issue with insufficient permissions
    * header Authorization = 'Bearer '+ incorrectToken
    Given url baseUrl+'/projects/'+ projectId + '/issues/'+issueId+'?issue_type=incident'
    When method PUT
    Then status 401
    And match $.message == "401 Unauthorized"

