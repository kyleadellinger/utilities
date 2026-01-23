#!/usr/bin/env python3

import itertools
import time
from threading import Thread, Event

def spin(msg: str, done: Event) -> None:
    """this function runs in separate thread.
    'done' is an instance of threading.Event, which synchronizes threads
    """
    for char in itertools.cycle(r"\|/-"): # this loops indefinitely, yields one char at a time
        status = f"\r{char} {msg}"
        print(status, end="", flush=True)
        if done.wait(.1):
            break
    blanks = " " * len(status)
    print(f"\r{blanks}\r", end="")

def slow() -> int:
    time.sleep(3) ## blocks the calling thread, but releases GIL
    return 42

def supervisor() -> int:
    done = Event()
    spinner = Thread(target=spin, args=("thinking!", done))
    print(f"Spinner object: {spinner}")
    spinner.start()
    result = slow()
    done.set()
    spinner.join()
    return result

def main() -> None:
    result = supervisor()
    print(f"Answer: {result}")

if __name__ == "__main__":
    main()

