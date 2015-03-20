#!/bin/bash -xe

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

# Debugging things...
#
# WERCKER_GIT_REPOSITORY=foo-bar
# WERCKER_GIT_BRANCH=master
# WERCKER_VIRTUALENV_PYTHON_LOCATION=/usr/bin/python2.7
# WERCKER_VIRTUALENV_VIRTUALENV_LOCATION=/home/vagrant/venv
# WERCKER_VIRTUALENV_INSTALL_WHEEL=true
# DEPLOY=false

# success() {
#   echo "${1}"
# }
#
# fail() {
#   echo "${1}"
#  # exit $?
# }
#
# warn() {
#   echo "${1}"
# }
#
# info() {
#   echo "${1}"
# }
#
# debug() {
#   echo "${1}"
# }
#
# setMessage() {
#   echo "${1}"
# }

if [ -z "$WERCKER_VIRTUALENV_PYTHON_LOCATION" ]; then
    export WERCKER_VIRTUALENV_PYTHON_LOCATION=$(which python)
    info "using default python location: $WERCKER_VIRTUALENV_PYTHON_LOCATION"
fi

if [ -z "$WERCKER_VIRTUALENV_VIRTUALENV_LOCATION" ]; then
    export WERCKER_VIRTUALENV_VIRTUALENV_LOCATION=$HOME/venv
    info "using default location: $HOME/venv"
fi

VIRTUAL_ENV_COMMAND="virtualenv"

if [[ -n "$WERCKER_STEP_ROOT" && $WERCKER_STEP_ROOT != "/wercker/steps/wercker/script/0.0.0" ]]; then
  source "${WERCKER_STEP_ROOT}/support/wercker-functions.sh"
else
  source ./support/wercker-functions.sh
fi

is_python_version
RESULT=$?
if [ ! "$RESULT" -eq 0 ] ; then
    fail "Python not found for path: $WERCKER_VIRTUALENV_PYTHON_LOCATION"
fi

is_valid_venv_path
RESULT=$?
if [ ! "$RESULT" -eq 0 ] ; then
    fail "Directory for virtual environment already exists"
fi

is_virtualenv_installed
RESULT=$?
if [ ! "$RESULT" -eq 0 ] ; then
    fail "virtualenv was not found. It probably is not installed?"
fi

"$VIRTUAL_ENV_COMMAND" --no-site-packages -p "$WERCKER_VIRTUALENV_PYTHON_LOCATION" "$WERCKER_VIRTUALENV_VIRTUALENV_LOCATION"

info "Activating virtual enviromnent."
source "$WERCKER_VIRTUALENV_VIRTUALENV_LOCATION/bin/activate"

mkdir -p "$WERCKER_CACHE_DIR/pip-download-cache"

info "Enabling generic pip environment variables:"
echo "PIP_DOWNLOAD_CACHE=$WERCKER_CACHE_DIR/pip-download-cache"
export PIP_DOWNLOAD_CACHE=$WERCKER_CACHE_DIR/pip-download-cache

if [ "$WERCKER_VIRTUALENV_INSTALL_WHEEL" == "true" ]; then

    info "Installing wheel package"
    pip install wheel

    mkdir -p "$WERCKER_CACHE_DIR/pip-wheels"

    info "Setting wercker wheel enviromnent variable:"
    info "WERCKER_WHEEL_DIR=$WERCKER_CACHE_DIR/pip-wheels"
    export PIP_WHEEL_DIR=$WERCKER_CACHE_DIR/pip-wheels
    echo "Updating"
    echo "PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-wheels"
    export PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-wheels
    info "Enabling enviromnent variables for pip:"
    info "PIP_USE_WHEEL=true"
    export PIP_USE_WHEEL=true

else
    echo "PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-download-cache"
    export PIP_FIND_LINKS=$WERCKER_CACHE_DIR/pip-download-cache
    info "Wheel will not be installed"
fi
