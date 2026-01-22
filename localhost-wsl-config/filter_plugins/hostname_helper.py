#!/home/kdellinger/ansible/_ans-venv/bin/python

##!/usr/bin/env python3

# DOCUMENTATION

# PLUGIN ATTEMPT

# NOTE: when calling from playbook, the filter/transform name must match the relevant KEY
# of the returned dictionary from the main class. here: host_help.
# NOT filename, NOT function name; KEY name.

import re
import sys

class FilterModule(object):

    def filters(self):
        return {
            "host_help": self.host_help
        }
    
    def host_help(self, name: str) -> tuple:
        """
        """
        info_extract = re.compile(r"l-\w.*(\d)\d\d\.w(d|t|p)n.*")
        mo = info_extract.search(name)

        env_dict = {"d": "dev", "t": "test","p": "prod"}
    
        dc_dict = {"1": "DC1","2": "DC2"}

        if mo.groups():
            return env_dict.get(mo.group(2)), dc_dict.get(mo.group(1))
        else:
            sys.exit(1)
