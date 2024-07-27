#!/usr/bin/env python3

import urllib.request
import urllib.parse
import json

def post_data(data: dict=None, encode_type: str="utf-8") -> bytes:
  """
  convenience function
  """
  to_json = json.dumps(data)
  encoded_string = to_json.encode(encode_type)
  return encoded_string

def post_caller(url: str):
  body = {
    "jsonrpc": "2.0"
    "method": "",
    "params": [],
    "id": 123"
  }

  # user_agent
  
  headers = { "Content-type": "application/json"}
  send_data = post_data(data=json.dumps(body))

  build_request = urllib.request.Request(url=url, headers=headers, data=send_data)
  with urllib.request.urlopen(build_request, timeout=10) as response:
    print(response.status)
    print(response.read())
  return response

