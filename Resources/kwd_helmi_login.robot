*** Settings ***
Documentation    Login related resources and keywords for Helmi


*** Keywords ***
User Submits Login Details As ${username} ${password}
    Wait Until Page Contains    ${TXT_LOGIN_PROMPT}
    Wait And Input Text    ${LOC_LOGIN_USERNAME}    ${username}
    Wait And Input Text    ${LOC_LOGIN_PASSWORD}    ${password}
    Wait And Click    ${LOC_LOGIN_BUTTON}

Browser Is Opened To ${url}
    Wait Until Location Contains    ${url}    timeout=15s

User Makes Sure UI Language Is Finnish
    Wait And Click    ${LOC_LOGIN_FINNISH}

User Clicks Log Out Link
    Click Element    ${LOC_MAIN_LOGOUT_LINK}

Login Page Should Open
    Wait Until Page Contains    ${TXT_LOGIN_PROMPT}
