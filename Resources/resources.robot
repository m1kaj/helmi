*** Settings ***
Documentation    Common keywords and resources.

Library     SeleniumLibrary
Library     String
Library     OperatingSystem
Library     Collections
Library     DateTime

Resource    ${EXECDIR}/Resources/kwd_helmi_login.robot
Resource    ${EXECDIR}/Resources/kwd_helmi_frontpage.robot
Resource    ${EXECDIR}/Resources/kwd_helmi_messages.robot
Resource    ${EXECDIR}/Resources/kwd_email.robot
Resource    ${EXECDIR}/Resources/locators_helmi.robot


*** Variables ***
${GMAIL_LOGIN_PAGE}            https://mail.google.com
${BROWSER_WIDTH}               1920
${BROWSER_HEIGHT}              1080
${SELENIUM_IMPLICIT_WAIT}      0.2 seconds
${SELENIUM_TIMEOUT}            10 seconds
${MESSAGE_LOG}                 ${EXECDIR}/message_log.txt
${NEW_MESSAGES_COMPILATION}    ${EXECDIR}/new_compilation.txt

# Mapping for top menu bar tabs. This doesn't contain all tabs and we only really use one.
&{TOP_MENU_TABS}    Etusivu=index    Viestit=messages    Opinnot=studies

# Text that can be used to check that sub-page has been loaded
&{SUB_PAGE_IDENTIFIERS}    Etusivu=Yhteenveto    Viestit=valitse kansio    Opinnot=Kuittaa kokeita nähdyksi


*** Keywords ***
Helmi Setup
    Create Message Log File When Needed    ${MESSAGE_LOG}
    Create New Messages File    ${NEW_MESSAGES_COMPILATION}
    Open Browser    ${HELMI_LOGIN_PAGE}    browser=${BROWSER}
    Set Default Selenium Settings

Helmi Teardown
    Close Browser

Set Default Selenium Settings
    [Documentation]    Set Selenium waits, screenshot directory and window size
    Set Selenium Implicit Wait    ${SELENIUM_IMPLICIT_WAIT}
    Set Selenium Timeout          ${SELENIUM_TIMEOUT}
    Set Screenshot Directory      ${OUTPUT_DIR}
    Set Window Size               ${BROWSER_WIDTH}    ${BROWSER_HEIGHT}
    Log  Setting up for ${BROWSER} with timeout=${SELENIUM_TIMEOUT} and wait=${SELENIUM_IMPLICIT_WAIT}

Wait And Click
    [Documentation]    Wait until element is visible and click it
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}

Wait And Input Text
    [Documentation]    Wait until element is visible and input text into it
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}
    Input Text    ${locator}    ${text}

