## helmi

A [Robot Framework](https://github.com/robotframework) test project.

Schools in my area use Helmi Oppilashallinto -web application for 
communication between school and parents. I wanted to receive new
messages from school to my email for convenience during working 
days:

- log in to Helmi web page
- read list of recent messages in inbox
- compile an email of messages that have not been emailed yet
- send email via Gmail API

Tested on Linux, Python3.6, Firefox and Gmail account for sending email:
  1. Make sure Firefox and Python 3.6 or newer are installed
  2. [Turn on Gmail API](https://developers.google.com/gmail/api/quickstart/python)
  3. Open a browser and login to [Google API console](https://console.developers.google.com)
     - check that Gmail API is enabled in Dashboard
     - go to Credentials and create OAuth client ID for type Other and 
       choose a name
     - download the created credentials file, place it in project
       directory and rename it to **credentials.json**
     - leave browser open for the first test run
  4. Setup virtualenv and webdrivers and start test for the first time
     ```
     ./setup.sh
     ./run.sh
     ```
     - you should see a new browser window open
     - click through the warnings and give the app permissions to 
       compose and send email.
     - If all goes well, browser should display: *The authentication 
       flow has completed, you may close this window.*
  5. See ./Report/log.html for test results
  
Repeating tests should now be possible just by ./run.sh

#TODO: see what happens when Google decides confirmation is again needed
for API access     
