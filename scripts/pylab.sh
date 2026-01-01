#!/usr/bin/env sh

# Wrapper to start a Python interpreter with NumPy and Matplotlib preloaded
#
# Requires a `PYTHONSTARTUP` files that can process the `$PYTHONMODULES` shell variable.
# This variable contains a list of Python package to import at startup separated by colons.
# An alias to import the package as can be specified by adding "=<alias>" in the package name.
# Example:
#
#   PYTHONMODULES="numpy=np:scipy=sp"

PYTHONLABMODULES="numpy=np:matplotlib.pyplot=plt"
PYTHONMODULES="$PYTHONLABMODULES${PYTHONMODULES:+:$PYTHONMODULES}" python
