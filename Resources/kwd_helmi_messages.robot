*** Settings ***
Documentation    Keywords for Helmi messages page.
...
...              Currently the HTML page loads inbox topic list by default. To reach new messages,
...              we do not need to click refresh. We do not need to switch to any other folder than
...              "Saapuneet" which is Inbox. The message topics are arranged in a table with new
...              messages appearing first on the top.
...              Each row has five cells. We are interested only in last three cells:
...              sender name, message title and timestamp.
...
...              It would be possible to find new messages that are displayed using a bold font.
...              We will instead use a log file that contains sender, title and timestamp for the
...              messages we have processed earlier. File will be saved into workspace only. No push
...              to any VCS. This is just a small personal project.
...
...              We will only process the first page of message titles, as there will be around 30
...              That is usually worth several weeks of messages for a single student. We do not have
...              the possibility to test with several students under one parent account. Message
...              topic does contain child's name. So we would expect messages for several children
...              in the same view.


*** Keywords ***

Message List Is Processed And New Messages Are Collected
    [Documentation]    Reads messages list: Sender, Subject, Date
    ...                Then iterates through the list and if message is not found in
    ...                log file, then message content is saved and message is added
    ...                to log file.
    ...
    ...                Log file contains only a string we build based on message title:
    ...                  <<<sender::subject::date time>>>
    ...
    ...                MESSAGE_LOG = log file
    ...                NEW_MESSAGES_COMPILATION = file where message contents are collected
    ${messages}=    Read Message List To Memory    ${LOC_MSG_TOPIC_TABLE}
    FOR    ${msg}    IN    @{messages}
        ${logline}=    Build Message Title String    ${msg}[1:]
        ${match}=    Grep File    ${MESSAGE_LOG}    ${logline}    encoding=UTF-8
        Continue For Loop If    len("""${match}""") > 0
        Add Message To Log File    ${MESSAGE_LOG}    ${logline}
        ${text}=    Read Message Content    ${LOC_MSG_TOPIC_TABLE}    ${msg}[0]
        Add Message Content To Compilation    ${NEW_MESSAGES_COMPILATION}    ${logline}    ${text}
    END

Possible New Messages Since Last Run Are Detected
    [Documentation]    Sets a Suite Variable that will decide whether there is a need
    ...                to send new messages email.
    ${size}=    Get File Size    ${NEW_MESSAGES_COMPILATION}
    Run Keyword If    ${size} > 0    Set Suite Variable    ${SEND_EMAIL}    ${true}
    ...               ELSE           Set Suite Variable    ${SEND_EMAIL}    ${false}

Message List Was Processed
    Variable Should Exist    ${SEND_EMAIL}    New messages file size check failed

There Are New Messages Since Last Run
    Pass Execution If    not ${SEND_EMAIL}    No news is good news!

Create Message Log File When Needed
    [Documentation]    Create message log file in case it does not exist.
    [Arguments]    ${file}
    ${file_exists}=    Run Keyword And Return Status    File Should Exist    ${file}
    Run Keyword Unless    ${file_exists}
    ...                   Create File    ${file}    content=    encoding=UTF-8

Create New Messages File
    [Documentation]    Create new empty text file, overwriting any existing file
    [Arguments]    ${file}
    Create File    ${file}    content=     encoding=UTF-8

Read Message List To Memory
    [Documentation]    Use Selenium to read table cells. Assume first row is the header and ignore it.
    ...                Input argument is locator to the table itself. Returns a list of lists, where
    ...                each list contains [row number, sender name, message title, timestamp]
    [Arguments]    ${table}
    @{result}=    Create List
    ${total_rows}=    Get Element Count    ${table}//tr
    ${last_row_plus_one}=    Evaluate    ${total_rows} + 1
    FOR    ${r}    IN RANGE    2    ${last_row_plus_one}
        ${row_num}=    Evaluate    ${r} - 1
        ${msg}=    Create List    ${row_num}
        ${val}=    Get Table Cell    ${table}    ${r}    ${3}
        Append To List    ${msg}    ${val}
        ${val}=    Get Table Cell    ${table}    ${r}    ${4}
        Append To List    ${msg}    ${val}
        ${val}=    Get Table Cell    ${table}    ${r}    ${5}
        Append To List    ${msg}    ${val}
        Append To List    ${result}    ${msg}
    END
    [Return]    ${result}

Read Message Content
    [Documentation]    Open new message based on table row number. Returns message content in a
    ...                multiline string. We click the message datetime here, because moving
    ...                pointer to title pops up a box that appears on top of title cell.
    [Arguments]    ${table}    ${row}
    Scroll Element Into View    ${table}//tr[${row}]
    Click Element    ${table}//tr[${row}]//td[3]
    # We could have read message body before clicking and then wait until body changes.
    # Even that would fail when duplicate messages get sent. Which is not impossible.
    # Normally message changes immediately when new subject is clicked. So we take the
    # lazy way and add a wait:
    Sleep  1
    ${result}=    Get Text    ${LOC_MSG_BODY}
    [Return]    ${result}

Build Message Title String
    [Documentation]    Given a list of message [row, sender, title, datetime], returns
    ...                a string of "sender::title::datetime"
    [Arguments]    ${msg_row}
    ${result}=    Catenate    SEPARATOR=::    @{msg_row}
    [Return]    ${result}

Add Message To Log File
    [Documentation]    Appends string to file
    [Arguments]    ${logfile}    ${message}
    Append To File    ${logfile}    ${message}\n    encoding=UTF-8

Add Message Content To Compilation
    [Documentation]    Appends title row to file, then appends given text content which can be
    ...                a multiline string.
    [Arguments]  ${compilation_file}    ${title}    ${content}
    Append To File    ${compilation_file}    <<<${title}>>>\n
    Append To File    ${compilation_file}    ${content}
    Append To File    ${compilation_file}    \n\n
