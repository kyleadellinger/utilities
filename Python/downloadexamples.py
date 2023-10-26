#!/usr/bin/env python3 

## intention is to create utitlies to download various items
## and not rely upon libraries other than python standard libraries

from urllib.request import urlretrieve
import argparse, os, subprocess, shutil, sys

# UA : https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar
# sha256 : https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar.sha256
# config : https://unified-agent.s3.amazonaws.com/wss-unified-agent.config

# cli : linux : https://downloads.mend.io/cli/linux_amd64/mend
# cli : win : https://downloads.mend.io/cli/windows_amd64/mend.exe

## basic download exmple functions:

def downUA(url="https://unified-agent.s3.amazonaws.com/wss-unified-agent.jar", output_location=os.getcwd(), filename="wss-unified-agent.jar"):
    """
    basic sample function to download UA;
    takes url and output_file; defaults to UA url in cwd."""
    save_file = os.path.join(output_location, filename)
    if filename in os.listdir(output_location):
        print("File exists at specified location. Moving . . . ")
        try:
            new_dir = os.path.join(output_location, "moved_files")
            os.makedirs(new_dir)
            shutil.move(filename, new_dir)
            print(f"Existing {filename} moved to {new_dir}")
            print("Downloading . . . ")
            urlretrieve(url, save_file)
        except FileExistsError:
            print("Tried to create a new directory ('moved_files'), but this also exists.\nPlease move/delete files to ensure this doesn't overwrite your important files.\nQuitting.\nNo changes have been made.")
            sys.exit()
    else:
        urlretrieve(url, save_file)
    return

def downConfig(url="https://unified-agent.s3.amazonaws.com/wss-unified-agent.config", output_location=os.getcwd(), filename="wss-unified-agent.config"):
    """
    basic sample function to download UA config file;
    takes url and output_file; defaults to proper location and cwd"""
    save_file = os.path.join(output_location, filename)
    if filename in os.listdir(output_location):
        print("File exists at specified location. Moving . . . ")
        try:
            new_dir = os.path.join(output_location, "moved_files")
            os.makedirs(new_dir)
            shutil.move(filename, new_dir)
            print(f"Existing {filename} moved to {new_dir}")
            print("Downloading . . . ")
            urlretrieve(url, save_file)
        except FileExistsError:
            print("Tried to create a new directory ('moved_files'), but this also exists.\nPlease move/delete files to ensure this doesn't overwrite your important files.\nQuitting.\nNo changes have been made.")
            sys.exit()
    else:
        urlretrieve(url, save_file)
    return

def downCLI(url="https://downloads.mend.io/cli/linux_amd64/mend", output_location=os.getcwd(), filename="mend"):
    save_file = os.path.join(output_location, filename)
    if filename in os.listdir(output_location):
        print("File exists at specified location. Moving . . . ")
        try:
            new_dir = os.path.join(output_location, "moved_files")
            os.makedirs(new_dir)
            shutil.move(filename, new_dir)
            print(f"Existing {filename} moved to {new_dir}")
            print("Downloading . . . ")
            urlretrieve(url, save_file)
        except FileExistsError:
            print("Tried to create a new directory ('moved_files'), but this also exists.\nPlease move/delete files to ensure this doesn't overwrite your important files.\nQuitting.\nNo changes have been made.")
            sys.exit()
    else:
        urlretrieve(url, save_file)
    return

def downWinCLI(url="https://downloads.mend.io/cli/windows_amd64/mend.exe", output_location=os.getcwd(), filename="mend.exe"):
    save_file = os.path.join(output_location, filename)
    if filename in os.listdir(output_location):
        print("File exists at specified location. Moving . . . ")
        try:
            new_dir = os.path.join(output_location, "moved_files")
            os.makedirs(new_dir)
            shutil.move(filename, new_dir)
            print(f"Existing {filename} moved to {new_dir}")
            print("Downloading . . . ")
            urlretrieve(url, save_file)
        except FileExistsError:
            print("Tried to create a new directory ('moved_files'), but this also exists.\nPlease move/delete files to ensure this doesn't overwrite your important files.\nQuitting.\nNo changes have been made.")
            sys.exit()
    else:
        urlretrieve(url, save_file)
    return




