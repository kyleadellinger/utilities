#!/usr/bin/env python3

import argparse
import sys

from getpass import getpass

def user_pass(prompt_user: str = "Secret: ",
	      verbose: bool = False,
	      skipNewLine: bool = False) -> str | None:

	def info_printer(s: str) -> None:
		if verbose:
			print(s, file=sys.stderr)
		return
	info_printer("Friendly reminder to keep secrets safe!")

	try:
		p = getpass(prompt=prompt_user)
	except KeyboardInterrupt:
		info_printer("\nKeyboard interrupt; program exit")
		return

	if p:
		if skipNewLine:
			info_printer("Skipping new line")
			print(p, file=sys.stdout, end="")
		else:
		    print(p, file=sys.stdout)
	
	else:
		info_printer("User prompt complete; empty secret detected (unexpected)")
	return p

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("-p", "--prompt",
		     help="Provide new prompt",
		     default="Secret: ")

	parser.add_argument("--verbose", "-v",
		     help="Enable arbitrary info messages to stderr",
		     action="store_true",
		     default=False)

	parser.add_argument("-n", "--no-newline",
		     help="Don't include a newline character with provided secret",
		     action="store_true",
		     default=False)

	args = parser.parse_args()
	user_pass(prompt_user=args.prompt, verbose=args.verbose, skipNewLine=args.no_newline)
	return

if __name__ == "__main__":
	main()
