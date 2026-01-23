#!/usr/bin/env python3

import logging

####################################################
## WORKING EXAMPLE LOGGING
## using two different levels
## logging one level to one file
## and a different level to a different file
#####################################################

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

log_formatting = logging.Formatter("%(asctime)s - %(levelname)s - %(funcName)s -  %(message)s")

program_logic_log_file = "test1.log"
user_log_file = "test2.log"

logic_handler = logging.FileHandler(program_logic_log_file)
logic_handler.setLevel(logging.DEBUG)
logic_handler.setFormatter(log_formatting)
logger.addHandler(logic_handler)

user_handler = logging.FileHandler(user_log_file)
user_handler.setLevel(logging.INFO)
user_handler.setFormatter(log_formatting)
logger.addHandler(user_handler)


logger.warning("logs to both log files")
logger.info("logs to both log files")
logger.debug("only logs to logic file")
