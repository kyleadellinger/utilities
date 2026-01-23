
import logging
import os
import sys

## LOG ##
###########################################################################
MASTER_LOG_DIR = ""

def _log_filename():
    """
    returns the script name itself
    with extension removed
    """
    name = os.path.split(sys.argv[0])[-1]
    return name.split(".")[0]


## REFERENCE ##
#
#logging.basicConfig(level=logging.DEBUG,
#                    format="%(asctime)s - %(levelname)s - %(message)s",
#                    filename=_log_filename())
###########################################################################

if __name__ == "__main__":
    file = _log_filename()
    print(file)
