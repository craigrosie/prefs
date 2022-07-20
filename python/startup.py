"""
This script is run when an interactive Python interpreter is started.

It can be used to import libraries, create new functions, etc. Basically
anything that you frequently use in a Python interpreter, but don't want to
have to type out every time.
"""
import atexit
import os
import math
import readline
import rlcompleter
from collections import defaultdict, Counter
from functools import partial
from pprint import pprint

from icecream import ic
from rich import inspect, pretty, print
from see import see

# tab completion
readline.parse_and_bind('tab: complete')
# history file
histfile = os.path.join(os.environ['HOME'], '.pythonhistory')

try:
    readline.read_history_file(histfile)
except IOError:
    pass

atexit.register(readline.write_history_file, histfile)

del histfile, readline, rlcompleter

pretty.install()

inspectm = partial(inspect, methods=True)


def dir_no_dunder(module):
    """Like the dir() builtin, but only prints non-dunder attributed."""
    pprint([attr for attr in dir(module) if not attr.startswith("_")])
