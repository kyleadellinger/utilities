#!/usr/bin/env python3

import unittest

# Basic (trivial) example:
# "A 'unit test' verifies that one specific aspect of a function's behavior is correct."
#
# "A 'test case' is a collection of unit tests that together prove that a function behaves as it's supposed to, within the full range of situations that you expect it to handle."
#
# then to run the test you just execute the file it seems

def say_hello(name: str = "") -> str:
    """says 'Hello'"""
    if name:
        return f"Hello, {name}!"
    else:
        return "Hello!"


class SayHelloTestCase(unittest.TestCase):
    """tests for 'say_hello' function"""

    def test_say_hello(self):
        """does it say hello to me if i tell it who i am"""
        name = "gerald"
        result1 = say_hello()

        result2 = say_hello(name)
        self.assertEqual(result1, "Hello!")
        self.assertEqual(result2, f"Hello, {name}!")

if __name__ == "__main__":
    unittest.main()
