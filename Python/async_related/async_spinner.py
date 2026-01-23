#!/usr/bin/env python3

import asyncio
import itertools

async def spin(msg: str) -> None:
    for char in itertools.cycle(r"\|/-"):
        status = f"\r{char} {msg}"
        print(status, flush=True, end="",)
        try:
            await asyncio.sleep(.1)
        except asyncio.CancelledError:
            break
    blanks = " " * len(status)
    print(f"\r{blanks}\r", end="")

async def slow() -> int:
    await asyncio.sleep(3)
    return 42

def main() -> None: # only regular function; others are coroutines
    """will stay blocked until supervisor returns
    the return value of supervisor will be the return value of asyncio.run
    """
    result = asyncio.run(supervisor()) # starts event loop to drive coroutine
    print(f"Answer: {result}")

async def supervisor() -> int:
    spinner = asyncio.create_task(spin('thinking!')) # schedules eventual execution of spin; immediately returns asyncio.Task
    print(f"Spinner object: {spinner}")
    result = await slow() # calls slow, blocking supervisor until slow returns; return value of slow will be assigned to result
    spinner.cancel() # Task.cancel method raises CancelledError exception inside spin coroutine
    return result

if __name__ == "__main__":
    main()

