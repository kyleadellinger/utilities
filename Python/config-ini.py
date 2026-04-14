#!/usr/bin/env python3

# this is an example/reminder/note to self

import configparser
import os

from pathlib import Path

def parse_config_file(
    filepath: str | Path,
    auto_env: bool = True,
    keep_config_case: bool = True,
    halt_on_error: bool = False,
) -> configparser.ConfigParser:

    """
    :param filepath: string or path to the configuration file. this is expecting a file that can be parsed by python's configparser
    :param auto_env: [default True] if true, automatically load  environment variables
    :param keep_config_case: [default True] by default, python's configparser makes key/values lowercase-- 
        if this param is true, the case of the keys in config file will be retained.
    :param halt_on_error: [default False] if True, will raise an exception if error encountered.
    :returns: configparser.ConfigParser

    """

    chk = Path(filepath)
    if not chk.is_file():
        if halt_on_error:
            raise SystemExit(f"Error: config not loaded: {filepath = } not found")
        else:
            print(f"Warning: config not loaded: {filepath = } not found", file=sys.stderr)

    config = configparser.ConfigParser()
    if keep_config_case:
        config.optionxform = str

    _ = config.read(filepath)
    if auto_env and (config.defaults() != None):
        for k, v in config.defaults().items():
            os.environ[k] = v

    return config

if __name__ == "__main__":
    pass

