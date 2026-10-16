#!/usr/bin/env bash

# consider:
{ ! [[ -d 'directoryName' ]] && mkdir 'directoryName' ; } || echo 'directory already exists'

# note: curly braces to group commands; if parantheses are used, a subshell executes the command (which in this case end result likely would be same)
# note: `;` at end of curly braces, plus spaces
# note: `!` (negate test) ; and more importantly the spaces

