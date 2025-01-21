#!/usr/bin/env python3

import datetime
import time

def get_unix_timestamp() -> float:
  return time.time()

def converter(x: float) -> str:
  return datetime.datetime.fromtimestamp(x).ctime()
