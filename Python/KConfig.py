import os
import sys
import tomllib

from pathlib import Path

class KConfig:

    def __init__(self,
                 config_file: str|Path):
        """
        Provide path to toml configuration file. Class instantiation opens file and makes contents available.\n
        TOML format supports plain key/value pairs, as well as tables with associated key/value pairs.\n
        In instance, use load method to load plan key/value pairs; use load_table method and specify table name if using tables
        
        """
        try:
            with open(config_file, "rb") as f:
                self.__config_file = tomllib.load(f)
        except FileNotFoundError:
            self.__config_file = None
        except tomllib.TOMLDecodeError:
            sys.exit(f"Provided file {config_file} does not appear to be valid TOML")

    def __repr__(self):
        return f"KConfig({self.config_file})"

    @property
    def config_file(self):
        """
        return full contents of provided configuration file
        """
        return self.__config_file
    
    @property
    def load(self):
        """
        adds attrs from config file to be accessible by name\n
        Use if key/value pairs are not under a 'table'. If under a table, use `load_table` and specify table name
        for now
        """

        for k, v in self.__config_file.items():
            setattr(self, k, v)
        return
    
    @property
    def loaded(self):
        """
        get loaded attrs of class instance
        """
        return [x for x in dir(self) if not x.startswith("_") and x not in dir(KConfig)]
    
    def load_table(self, title: str):
        """
        Use to retrieve keys/values if nested under a (TOML-language): 'table'\n
        aka this:\n
        [thing]\n
        foo = "bar"\n

        :param title: the name of the table for which to load the key/value pairs
        :returns: None. sets instance attributes
        """
        x = self.__config_file.get(title)
        for k, v in x.items():
            setattr(self, k, v)
        return
    
    @property
    def unload(self):
        """
        remove any loaded attrs from instance
        """
        poc = dir(KConfig)
        potential = self.loaded
        for x in potential:
            if hasattr(self, x) and x not in poc:
                delattr(self, x)
        return

    
    @staticmethod
    def addenv(k: str, v: str) -> None:
        """
        Add env variable
        :param k: env var name
        :param v: env var value
        """
        try:
            os.environ[k] = v
        except TypeError as e:
            print(f"WARNING: TypeError encountered --> {e}\n{k} is {type(k)}")
            print("Environment variable not set.")
        return
