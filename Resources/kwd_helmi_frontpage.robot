*** Settings ***
Documentation    Keywords for Helmi main page (fron page).
...              IMPORTANT NOTE: Front page toolbar button configuration depends on window size.
...              In this test we set the window wide enough to see the sub-page tabs in the toolbar.
...              In proper testing one would test all UI sizes including smaller window where
...              sub-page tabs appear in a drop-down list.


*** Keywords ***

Messages Page Tab Is Visible In Front Page
    Wait Until Page Contains    Viestit
    Wait Until Page Contains    Etusivu
    Wait Until Page Contains    Yhteenveto

User Clicks Tab ${tab}
    [Documentation]    Open tab from top-menu based on given text
    ${loc}=    Replace String    ${LOC_MAIN_TOP_MENU_ITEM}    REPLACEME    ${TOP_MENU_TABS}[${tab}]
    Wait And Click    ${loc}

Main Page Should Open
    Wait Until Page Contains    ${TXT_MAIN_WELCOME}

Page ${tab} Should Open
    Wait Until Page Contains    ${SUB_PAGE_IDENTIFIERS}[${tab}]
