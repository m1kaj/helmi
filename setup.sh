#!/bin/bash

echo Setting up Python 3 virtual environment.
echo You will need Python 3.x and browser. Tested with Firefox.
echo Edit global_variables.py before running tests with ./run.sh

# Check Python 3.x availability
pybin=$( which python3 )
if [ -z $pybin ]
then
  echo Please install Python 3.x and see that python3 is in PATH
  exit 0
fi

# Setup virtual environment
virtualenv -p $pybin venv
source ./venv/bin/activate
pip install -r requirements.txt

# Install Selenium webdrivers. Need to be in Python path.
pip install --upgrade webdrivermanager
webdrivermanager firefox chrome --linkpath ${PWD}/venv/bin

