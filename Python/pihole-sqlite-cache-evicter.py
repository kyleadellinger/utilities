#!/usr/bin/env python3

import logging
import sqlite3
import sys

# name and location of the database
database = "/etc/pihole/pihole-FTL.db"
s_n_d = "%WILDCARD_ENTRY_NAME%"
## % are wildcards in sql

logging.basicConfig(level=logging.DEBUG, filename="sql_cleaner.log", format=" %(asctime)s - %(levelname)s - %(message)s")

def create_connection(db_file=database):
    """create database connection
    :takes database name/location
    :returns database connection or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except:
        print("Error in database connection. Quitting")
        sys.exit()

    return conn

def select_targets(cur, domain=s_n_d):
    """
    retrieve targets (for deletion)
    :takes cursor object and domain, which is a tuple
    """
    cur.execute("select id from queries where domain like ?", (domain,))
    return cur.fetchall()

def delete_domains(cur, del_targets):
    for x in del_targets:
        cur.execute("delete from query_storage where id = ?", x)
    logging.debug("Delete domains execution completed")
    return

db_con = create_connection()
logging.debug("DB connection established")

# create cursor
cur = db_con.cursor()
logging.debug("Cursor object established")

targets = select_targets(cur)
logging.debug(f"Targets detected: {len(targets)}")

delete_domains(cur=cur, del_targets=targets)
logging.debug("Delete domains function completed.")
logging.debug(f"Objects changed (removed): {db_con.total_changes}")

logging.debug("Committing changes")

db_con.commit()

logging.debug("Changes commited")

db_con.close()

logging.debug("DB connection closed")
