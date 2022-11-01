# KarateGitlabIssueTesting

```
cd existing_repo
git remote add origin https://gitlab.com/Niharika1607/KarateGitlabIssueTesting.git
git branch -M main
git push -uf origin main
```

In this Project below APIs have been automated from GitLab Issue page - https://docs.gitlab.com/ee/api/issues.html

1. **CREATE** - https://docs.gitlab.com/ee/api/issues.html#clone-an-issue
2. **READ**   - https://docs.gitlab.com/ee/api/issues.html#list-project-issues
3. **UPDATE** - https://docs.gitlab.com/ee/api/issues.html#edit-issue
4. **DELETE** - https://docs.gitlab.com/ee/api/issues.html#delete-an-issue

**Test Scenarios: Clone an Issue**

1. Issue is cloned correctly with new project id if valid values are provided for
    1. Old Project Id
    2. New Project Id
    3. Issue Id

Test the above scenario for with_notes_value as -  **a)** true **b)** false **c)** blank(no value)
2. Request shouldn't go through when mandatory parameters are absent or missing.
    1. IssueId        - "404 Not Found" Error
    2. Old Project Id - "404 Not Found" Error
    3. New Project Id - "404 Project Not Found" Error

3. We must get Authorization error if wrong security token is provided or if user has insufficient permissions.

**Test Scenarios: List Project Issue**

1. To make sure below endpoints are accessible with correct data and we are not getting any error

    1. GET /projects/:id/issues
    2. GET /projects/:id/issues?assignee_id=5
    3. GET /projects/:id/issues?author_id=5
    4. GET /projects/:id/issues?confidential=true
    5. GET /projects/:id/issues?iids[]=42&iids[]=43
    6. GET /projects/:id/issues?labels=foo
    7. GET /projects/:id/issues?labels=foo,bar
    8. GET /projects/:id/issues?labels=foo,bar&state=opened
    9. GET /projects/:id/issues?milestone=1.0.0
    10. GET /projects/:id/issues?milestone=1.0.0&state=opened
    11. GET /projects/:id/issues?my_reaction_emoji=star
    12. GET /projects/:id/issues?search=issue+title+or+description
    13. GET /projects/:id/issues?state=closed
    14. GET /projects/:id/issues?state=opened

2. We must get error - "404 Project Not Found" if project id is missing while accessing the Endpoints
3. We must get Authorization error if wrong security token is provided or if user has insufficient permissions.

**Test Scenarios: Edit an Issue**

1. To make sure We are able to edit the issue for below attributes and make sure correct value is updates in the issue.
    1. :assignee_id
    2. :assignee_ids
    3. :confidential
    4. :created_at
    5. :description
    6. :due_date
    7. :issue_type
    8. :labels
    9. :milestone_id
    10. :state_event
    11. :title

2. Make sure we get error when none of above mandatory parameter is present.
3. We must get 404 error when either project id or issue id is missing or incorrect.
4. We must get Authorization error if wrong security token is provided or if user has insufficient permissions.

**Test Scenarios: Delete an issue**

1. Verify that issue is deleted with 204 error.
2. We must get error if we try to delete a non existing issue.
3. There should be error when we try to delete an issue which has missing/incorrect issueid or project id.
4. We must get Authorization error if wrong security token is provided or if user has insufficient permissions.


