#!/usr/bin/env python3

import sys
import json
import urllib.request
import urllib.parse

from pprint import pprint

def do_headers(**kwargs) -> dict:
    """provide kwargs for additional headers. 'User-Agent' defaulted.\n
    underscores in key name will be replaced with hyphens
    """
    _headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Normie64; x64)"}
    if kwargs:
        for k, v in kwargs.items():
            if "_" in k:
                k = k.replace("_", "-")
            _headers.update({k: v})

    return _headers

def get_caller(url: str,
        headers: dict,
        query_params: dict = None, *,
        method="GET",
        **kwargs):
    """
    any kwargs passed directly to urllib.request.Request\n
    restricted to GET (or HEAD) request
    """
    if not method.casefold() in {"get", "head"}:
        sys.exit(1)

    if query_params:
        use_params = urllib.parse.urlencode(query_params)
    else:
        use_params = None

    request = urllib.request.Request(
            url=url,
            headers=headers,
            **kwargs)
    try:
        with urllib.request.urlopen(request, timeout=10) as r:
            response = r.read().decode("utf-8")
            return json.loads(response)
    except urllib.error.HTTPError as err:
        print(f"Error encountered in response: {err.status} -- {err.reason}")
    except urllib.error.URLError as err:
        print(f"Error encounted with url. url: {url} -- error: {err}")
    except TimeoutError:
        print(f"Encountered timeout error with url {url}")
    return

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    # TODO add post
    parser.add_argument("url", help="URL to call")
    parser.add_argument("-a", "--add-headers", help="Provide additional headers with request", default=None) # how tho?
    parser.add_argument("-q", "--query-params", help="Provide query params (for get request)", default=None)

    args = parser.parse_args()

    heads = do_headers()
    response = get_caller(url=args.url, headers=heads)
    print(response or None)

