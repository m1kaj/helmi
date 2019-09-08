*** Settings ***
Documentation    Helmi web application tests
...
...              Simple tests to fetch new Helmi messages from school to parent.
...              Motivation was to avoid having to log in to Helmi web pages during
...              working day. There is already an email notification for new messages,
...              but for privacy reasons it contains only the subject line.
...              Test fetches all new messages since last run and sends message texts
...              in email.
...
...              Helmi login credentials, gmail username and target email need to be
...              added to local file "global_variables.py".

Suite Setup      Helmi Setup
Suite Teardown   Helmi Teardown

Library     ${EXECDIR}/Resources/gmail/GmailSender.py    ${EXECDIR}/credentials.json

Resource    ${EXECDIR}/Resources/resources.robot


*** Test Cases ***

Log In To Helmi Application
    [Documentation]    Select Finnish Language UI in login page.
    ...                Then submit login details.
    Given Browser Is Opened To ${HELMI_LOGIN_PAGE}
    When User Makes Sure UI Language Is Finnish
    and User Submits Login Details As ${HELMI_USERNAME} ${HELMI_PASSWORD}
    Then Main Page Should Open


View Messages Page
    [Documentation]    Click Messages tab to view a list of 20-30 latest messages.
    Given Messages Page Tab Is Visible In Front Page
    When User Clicks Tab Viestit
    Then Page Viestit Should Open


Process Message List For New Messages
    [Documentation]    Process message list. Local files are used in the keywords,
    ...                and Suite elevel variable \${SEND_EMAIL} is set True/False
    ...                based on the need to send new email.
    When Message List Is Processed And New Messages Are Collected
    Then Possible New Messages Since Last Run Are Detected


Log Out Of Application
    When User Clicks Log Out Link
    Then Login Page Should Open


Send Email With New Messages
    [Documentation]    Send email with new messages contents in the body as text.
    ...                This TC runs a Pass Execution keyword in the "When" step
    ...                if there are no new messages to email!
    Given Message List Was Processed
    When There Are New Messages Since Last Run
    Then Send New Messages Via Gmail ${GMAIL_USERID} To ${HELMI_TARGET_EMAIL}





