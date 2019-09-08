#!/bin/bash

source venv/bin/activate && robot --exitonfailure -V ./global_variables.py -d Report ./Tests/
