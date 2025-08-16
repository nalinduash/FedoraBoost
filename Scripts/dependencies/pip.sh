#!/bin/bash

# Importing SH files
source ./Scripts/common.sh

pip3 install --upgrade gnome-extensions-cli

# Summary
logSummary "Pip packages Installation";
logPass "All pip packages Successfully installed";
br
