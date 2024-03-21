#!/usr/bin/env bash
# Refresh from original Repo
# WARNING will remove all your local changes!!!
# except for files not in Git
#
# Handy if your Jupyter Notebooks have executed Cells you don't want
# to commit. 
#
# Author: Just van den Broecke
#
git fetch --all
git reset --hard origin/master
