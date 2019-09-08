*** Settings ***
Documentation    Helmi web application locators and text strings for SeleniumLibrary.
...              We are mostly using Xpath, but not exlusively. Strategy prefix is included
...              unless we expect to concatenate locator with another locator.


*** Variables ***

# Login page texts and locators
${TXT_LOGIN_PROMPT}     Kirjaudu sisään
${LOC_LOGIN_LOGO}       xpath://img[@src="/images/HOH_logo.png"]
${LOC_LOGIN_FINNISH}    xpath://img[@alt="Suomi"]
${LOC_LOGIN_USERNAME}   xpath://*[@name="username"]
${LOC_LOGIN_PASSWORD}   xpath://*[@name="password"]
${LOC_LOGIN_BUTTON}     xpath://*[@class="buttonLogin"]

# Main page texts and locators
${TXT_MAIN_WELCOME}          Tervetuloa
${TXT_MAIN_SUMMARY}          Yhteenveto
${LOC_MAIN_TOP_MENU_ITEM}    //ul[@id="top_menu"]//*[@id="REPLACEME"]
${LOC_MAIN_LOGOUT_LINK}      id=logout

# Messages page texts and locators
${LOC_MSG_TOPIC_TABLE}       xpath://div[@class="received_messages_table_container"]//table
${LOC_MSG_BODY}              xpath://div[@class="message_body"]

