#!/bin/bash -e

# --------------------------------------------------------------------
#
# brought this script from step-virtualenv in order to enable
# virtualenv in box building process.
#
# * https://github.com/wercker/step-virtualenv
#
# --------------------------------------------------------------------
#
# The MIT License (MIT)
#
# Copyright (c) 2013 wercker
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# --------------------------------------------------------------------

# Returns true if python version is at version 2.x or 3.x
is_python_version() {
  if [ -f $WERCKER_VIRTUALENV_PYTHON_LOCATION ] ; then
      case "$($WERCKER_VIRTUALENV_PYTHON_LOCATION --version 2>&1)" in
          *" 3."*)
              return 0
              ;;
          *" 2."*)
              return 0
              ;;
          *)
              return 1
              ;;
      esac
  fi

  return 1
}

# Returns true if virtual env path is not a directory
is_valid_venv_path() {
  if [ -d "$WERCKER_VIRTUALENV_VIRTUALENV_PATH" ] ; then
    return 1
  fi

  return 0
}

is_virtualenv_installed() {
  if hash $VIRTUAL_ENV_COMMAND 2>/dev/null; then
    return 0
  fi

  return 1
}
