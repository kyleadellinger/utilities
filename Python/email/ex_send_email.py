#!/usr/bin/env python3

import argparse
import logging
import smtplib
import sys
import time

from email.message import EmailMessage
# mime pieces added for notes
from email.mime.text import MIMEText

def sender(msg: EmailMessage, mailer: str=None, tls: bool=False)-> None:
    """
    function wrapper for testing
    :param msg: the text/body of message
    :param mailer: ex: DNS name
    
    """
    if not mailer:
        print("'mailer' param expected. DNS name of MTA to submit message to.")
        sys.exit(11)

    try:
        with smtplib.SMTP(mailer, timeout=20) as mail_srv:
            if tls:
                logging.debug("Calling start TLS")
                mail_srv.starttls()
            mail_srv.send_message(msg)

    except smtplib.SMTPConnectError:
        print("SMTP Connection error. Message send aborted.")
        sys.exit(2)
    except smtplib.SMTPHeloError:
        print("Specified server refused HELO. Message send aborted.")
        sys.exit(2)
    except smtplib.SMTPDataError:
        print("Server refused message content. Message send aborted.")
        sys.exit(2)
    return


def build_message(content: str, recipient: str|list, sender: str=None, subject: str=None, headers: dict=None, override: bool=False) -> EmailMessage:
    """
    basic wrapper function to build mail message
    :param content: message body
    :param recipient: mailing to
    :param sender: mailing from
    :param subject: message subject
    :param headers: additional message headers to add. not implemented.
    :param override: override existing headers. not implemented.

    :return: EmailMessage object to be sent
    """
    msg = EmailMessage()
    msg.set_content(content)
    msg["To"] = recipient

    if not subject:
        msg["Subject"] = f"Epoch {time.time()}"
    else:
        msg["Subject"] = subject
    return msg

def check_connect(server: str) -> bool:
    """
    perhaps helpful; uses noop mail cmd
    :param: server: server to check smtp connection
    """
    expected = (250, b"2.0.0 Ok")
    with smtplib.SMTP(server) as mail_srv:
        con = mail_srv.noop()    
    return (con == expected)

if __name__ == "__main__":
    from pathlib import Path
    _LOG_FILE = Path(r"C:\Users\kdellinger\kypy\_LOGS\send_email.log")

    logging.basicConfig(filename=_LOG_FILE, level=logging.DEBUG, format=" %(asctime)s - %(levelname)s - %(message)s")

    # either mail from text file or mail from command line text
    MAIL_TO_SEND = f"hello\n" # str
    TO = "person@example.com"

    msg = build_message(content=MAIL_TO_SEND, recipient=TO)
    sender(msg=msg, mailer=BULK_MTA_BACKEND)
