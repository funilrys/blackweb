#!/bin/bash
# Incremental Commit for Blackweb
# REPO: https://github.com/mitchellkrogza/blackweb
# Copyright Mitchell Krog - mitchellkrog@gmail.com

# **************
# File Variables
# **************

    FullList=${TRAVIS_BUILD_DIR}/blackweb.txt
 

RunPartialCommit () {
# ****************************************
# Copy last tested files into root of repo
# ****************************************


statuses="ACTIVE INACTIVE INVALID"

for status in $(echo ${statuses})
do
    statusFile="${TRAVIS_BUILD_DIR}/dev-tools/output/domains/${status}/list"

    if [[ -f ${statusFile} ]]
    then
        cat ${statusFile} | grep -v "^$" | grep -v "^#" > ${TRAVIS_BUILD_DIR}/domains-${status}-in-testing.txt
    else
        echo "" > ${TRAVIS_BUILD_DIR}/domains-${status}-in-testing.txt
    fi
done

# *********************************************************
# Clean with whitelist
# *********************************************************

#bash ${TRAVIS_BUILD_DIR}/dev-tools/whitelist.sh

# *********************************************************
# Modify Readme File
# *********************************************************

#bash ${TRAVIS_BUILD_DIR}/dev-tools/modify-readme.sh

}

RunPartialCommit

# Function to split files > May need this when we get close to the 100mb Github File Size Limit to Avoid using GIT LFS
SplitFiles () {
    split -l 50000 --numeric-suffixes ${FullList} ${FullListsplit}
    split -l 50000 --numeric-suffixes ${PyTestList} ${PyTestListsplit}
}
#SplitFiles

# **********************
# Exit With Error Number
# **********************

exit ${?}
