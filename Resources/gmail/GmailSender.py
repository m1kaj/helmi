"""Robot Framework static library to send an email using Gmail API

Needed parameters are sender and receiver email addresses, email subject and body text.
Also Gmail API authentication credentials are needed.

This requires a Google account, and that account owner:
    - has enabled Gmail API, see https://developers.google.com/gmail/api/quickstart/python
    - has granted necessary application permissions. For example by manually clicking "Allow"
      when the application runs for the first time.
    - has downloaded credentials file from Google and given it as parameter to init function
"""

from __future__ import print_function
import pickle
import os.path
import base64
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from email.mime.text import MIMEText
from robot.api.deco import keyword

__version__ = "0.1"

ROBOT_LIBRARY_SCOPE = "TEST_SUITE"
SCOPES = ['https://www.googleapis.com/auth/gmail.compose']


class GmailSender:

    def __init__(self, creds_file: str):
        """Set up Google API authorization using saved credentials file.
        Code is from Google https://developers.google.com/gmail/api/v1/reference/
        """
        creds = None
        # The file token.pickle stores the user's access and refresh tokens, and is
        # created automatically when the authorization flow completes for the first
        # time.
        if os.path.exists("token.pickle"):
            with open("token.pickle", "rb") as token:
                creds = pickle.load(token)
        # If there are no (valid) credentials available, let the user log in.
        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                flow = InstalledAppFlow.from_client_secrets_file(creds_file, SCOPES)
                creds = flow.run_local_server(port=0)
            # Save the credentials for the next run
            with open("token.pickle", "wb") as token:
                pickle.dump(creds, token)
        self.service = build("gmail", "v1", credentials=creds)

    @keyword("Send Using Gmail")
    def create_and_send_message(self, sender: str, recipient: str, subject: str, message_text: str):
        """Create and send pure text email. Returns sent message object.

        Arguments:
            sender:     sender email address
            recipient:  receiver email address
            subject:    message subject
            message_text: content of email
        """
        message = MIMEText(message_text)
        message["to"] = recipient
        message["from"] = sender
        message["subject"] = subject
        # In Python 2.7 b64encode worked with string. In Python 3.6 input is bytes-like object.
        raw = base64.urlsafe_b64encode(message.as_bytes())
        raw = raw.decode()
        encoded_message = {"raw": raw}
        try:
            sent_message = (self.service.users().messages().send(userId=sender, body=encoded_message)
                            .execute())
            return sent_message
        except Exception as error:
            print("Error sending email: {}".format(str(error)))
