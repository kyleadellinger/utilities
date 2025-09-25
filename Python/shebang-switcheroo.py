##
## cross platform, no shebang
## simple cli to log shebangs and update on the fly.
## intended for switching between machines where venvs may be in different locations; quick and easy way to update project files.

import argparse
import fileinput
import json

from collections import defaultdict
from pathlib import Path

def shefiles(directory: str|Path = Path.cwd()) -> list:
    d = Path(directory)
    if not d.is_dir():
        print(f"{directory} not found")
        return
    return [x.name for x in d.iterdir() if not x.is_dir() and x.name.endswith(".py")]


def get_shebang_files(directory: str|Path = Path.cwd()) -> dict:
    """
    :returns: dict where keys are shebangs and values are filenames
    """
    files = shefiles(directory=directory)
    if not files:
        print(f"No matched files here {directory = }")
        return
    
    output = defaultdict(list)

    try:
        with fileinput.input(files) as f:
            for line in f:
                if fileinput.isfirstline() and line.startswith("#!"):
                    output[line].append(str(fileinput.filename()))
    except PermissionError:
        print(f"Warning! Permissions error at {f}")

    return output

def write_shebang_to_files(new_shebang: str, edit_files: list) -> None:
    """
    writes `new_shebang` to all files provided in `edit_files`
    """
    try:
        with fileinput.input(files=edit_files, inplace=True) as f:
            for line in f:
                if fileinput.isfirstline() and line.startswith("#!"):
                    print(new_shebang.strip())
                else:
                    print(line, end="")
    except PermissionError:
        print(f"Warning! Permissions error at {fileinput.input()}")

    return

def read_state(state_file: str|Path = Path.cwd() / "_shebangs.json") -> dict|None:
    """
    if `state_file` exists, read it and return dict.
    if Permissions issue, return none.
    if json decode error, program abort.
    :returns: dict where keys are shebangs and values are the associated files.
    """
    file = Path(state_file)
    if not file.is_file():
        return
    
    try:
        with open(file, "r") as f:
            x = json.load(f)
        return x
    except PermissionError:
        print(f"Warning! Permissions error reading {state_file}")
    except json.JSONDecodeError:
        raise SystemExit(f"Unexpected file contents: {state_file}")
    
    return


def capture_current(project_dir: str|Path = Path.cwd(),
                    state_filename: str|Path = "_shebangs.json",
                    *,
                    quiet: bool = False,
                    force: bool = False) -> bool:
    """
    """
    _dir = Path(project_dir)
    _state = Path(state_filename)

    if not _dir.is_dir():
        print(f"Error: directory not found: {project_dir}\nAbort")
        return False
    
    filepath = _dir / _state

    def printer(x) -> None:
        if quiet:
            return
        print(x)
        return

    def write_ops(d: dict, filepath: Path) -> None:
        with open(filepath, "w") as f:
            json.dump(d, f)
        return
    
    project_pys = get_shebang_files(directory=_dir)

    if not filepath.is_file() or force:
        write_ops(d=project_pys, filepath=filepath)
        printer(f"{filepath.name} written!")
        return True
    elif filepath.is_file():
        reader = read_state(state_file=filepath)
        merger = project_pys | reader
        write_ops(d=merger, filepath=filepath)
        printer(f"{filepath.name} updated!")
        return True
    else:
        raise SystemExit(
            f"capture_current failsafe for debugging to crash if unaccounted for case: {filepath=} {filepath.exists()} {force=}")


def arger():
    parser = argparse.ArgumentParser()
    parser.add_argument("-d", "--directory", help="The directory for shebangings sightings", default=Path.cwd())
    parser.add_argument("--new-filename", help="Override default filename", default="_shebangs.json")
    parser.add_argument("--reset", help="Remove `_shebangs.json' if exists", action="store_true", default=False)
    parser.add_argument("-f", "--force", help="Overwrite `_shebangs.json' if exists", action="store_true", default=False)
    parser.add_argument("-q", "--quiet", help="Disable most if not all of informational output", action="store_true", default=False)
    parser.add_argument("--switch", help="Initiate switcheroo protocol", action="store_true", default=False)
    parser.add_argument("--adhocsh", help="Initiate ad-hoc shebang manipulator writes", action="store_true", default=False)

    args = parser.parse_args()

    if args.reset:
        wd = Path(args.directory) / Path(args.new_filename)
        try:
            wd.unlink(missing_ok=True)
        except PermissionError:
            print(f"Permission error; failed removing {wd}")
        return

    files = get_shebang_files(args.directory)
    if not files:
        return
    
    x = capture_current(project_dir=args.directory, state_filename=args.new_filename, quiet=args.quiet, force=args.force)
    if not x:
        print(f"Error: unexpected return; program quit.")
        return
    
    def user_input(prompt: str) -> str:
        try:
            chc = input(prompt + "\n ->:")
            return chc
        except KeyboardInterrupt:
            raise SystemExit("Keyboard Interrupt")
    
    if args.switch:
        state = read_state(state_file=Path(args.directory) / Path(args.new_filename))
        if state:
            new_structure = dict()
            for i, k in enumerate(state.keys()):
                new_structure[i] = k
            for number, sbang in new_structure.items():
                print(f"Choice: {number} -> {sbang}")
            chc = user_input("Input choice to adjust shebangs\nNOTE:\tAll *.py files with shebangs will be adjusted! ! !")

            try:
                newchc = new_structure[int(chc)]
            except KeyError:
                print(f"Invalid selection: {chc}")
                return
            except ValueError:
                print(f"You're supposed to input a number\nAborted\n")
                return

            writingfiles = shefiles(directory=args.directory)
            write_shebang_to_files(new_shebang=newchc, edit_files=writingfiles)
            print("Write complete!")

            return

    elif args.adhocsh:
        newshe = user_input("Input new shebang string:\n")

        if not newshe.startswith("#!") and not args.force:
            print(f"{newshe} doesn't appear to be valid ?...\n(If it is, run it again with `force').")
            return
        else:
            writingfiles = shefiles(directory=args.directory)
            write_shebang_to_files(new_shebang=newshe, edit_files=writingfiles)
            print("Ad-hoc write complete!")
            capture_current(project_dir=args.directory, state_filename=args.new_filename, quiet=args.quiet, force=args.force)
        return


if __name__ == "__main__":
    arger()
