*** Settings ***
Documentation    Email sender keyword. Uses library for Google Gmail API.


*** Keywords ***

Send New Messages Via Gmail ${from} To ${to}
    ${email_time}=    Get Current Date
    ${email_text}=    Get File    ${NEW_MESSAGES_COMPILATION}    encoding_errors=replace
    Send Using Gmail    ${from}    ${to}    Helmi ${email_time}    ${email_text}
