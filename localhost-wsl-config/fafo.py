#!/usr/bin/env python3

import os

# more could be added, fyi
start_files_to_create = ["localhost", "ansible.cfg"]

# TODO venv interpreter magic
ansible_python_interpreter = "/home/kdellinger/ansible/_ans-venv/bin/python"

def check_inv(files_to_create):
    for x in os.listdir():
        if x in files_to_create:
            files_to_create.remove(x)
            print(f"File {x} detected, not touching")
    if files_to_create:
        print(f"Files not detected, creating {[x for x in files_to_create]}")

    return files_to_create

def create_localhost():
    with open("localhost", "w") as l:
        l.write(f"[hosts]\nlocalhost ansible_connection=local ansible_python_interpreter={ansible_python_interpreter}\n")
    print("File localhost created.")
    return

def create_cfg():
    with open("ansible.cfg", "w") as a:
        a.write("[defaults]\ninventory = localhost\n")
    print("File ansible.cfg created.")
    return

def create_files(files_to_create):
    if files_to_create:
        if "localhost" in files_to_create:
            create_localhost()

        if "ansible.cfg" in files_to_create:
            create_cfg()
    else:
        print(f"Provided list {files_to_create} is empty- nothing to do!")

    return


f = check_inv(start_files_to_create)
create_files(f)
