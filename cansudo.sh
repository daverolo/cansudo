#!/bin/bash
# -------------------------------------------------------------------------------------------------
# What:
# Bash script to check whether or not the current user can sudo without entering a password
# -------------------------------------------------------------------------------------------------
# Exit codes:
# 0 = SUCCESS: The user is in sudo group AND can use sudo without password
# 1 = FAIL: The user can not use sudo at all because he is not in sudo group
# 2 = FAIL: The user can use sudo but requires to input a password
# -------------------------------------------------------------------------------------------------
# Example:
# bash cansudo.sh
# -------------------------------------------------------------------------------------------------
# Important:
# - Currently only tested with bash on Ubuntu 20.04
# - Script may not work with zsh on Mac or other shells/OS
# - You may have to adjust the timeout value on busy systems (see ESSENTIALS section below)
# - Still a bit hacky solution - use at your own risk
# -------------------------------------------------------------------------------------------------

#
# ESSENTIALS
#

# Make sure job control is enbled (required for "fg" - https://unix.stackexchange.com/a/196606)
set -m

# Timeout - needed to check if a pw was requested
# You may need to set this higher on busy systems
timeout=1

# Script name and version (you must not change this values)
SCRIPT_NAME=$(basename "$0")
SCRIPT_VERSION="1.0.0"

#
# HELPER FUNCTIONS
#

# Echo to stderr
sayerr() {
	echo "$@" 1>&2
}

# Check wheter or not a given process id has stopped within specified timeout
# Arguments:
# - $1: [REQUIRED] <number> - Process ID to check
# - $2: [OPTIONAL] <number> - Maximum timeout in seconds (Default: 1)
# - $3: [OPTIONAL] <string> - Specify a string that should be announceds to stderr if timeout happened (Default: <empty>)
# Returns 0 on success, 1 otherwise
has_pid_stopped() {
	local pid=$1
	local timeout=${2-1}
	local announce=$3
	local uptimesecstart
	local uptimesecnow
	local uptimesecdiff
	uptimesecstart=$(awk '{print $1}' /proc/uptime)
	uptimesecstart="${uptimesecstart%.*}" # remove ".xxx" from seconds string
	while kill -0 $pid &>/dev/null; do
		sleep 1
		uptimesecnow=$(awk '{print $1}' /proc/uptime)
		uptimesecnow="${uptimesecnow%.*}" # remove ".xxx" from seconds string
		uptimesecdiff=$((uptimesecnow-uptimesecstart))
		if [ $uptimesecdiff -ge $timeout ]; then
			if ! [ -z "$announce" ]; then
				sayerr "$announce"
			fi
			kill -9 $pid &>/dev/null
			exit 1
		fi
	done
}

#
# SCRIPT NAME/VERSION
#

# Output script name and version if requested via --version or -v
if ! [ -z "$SCRIPT_VERSION" ] && ( [ "${1,,}" == "--version" ] || [ "${1,,}" == "-v" ]); then
	echo "$SCRIPT_NAME $SCRIPT_VERSION"
	exit 0
fi

#
# RUN CHECKS
#

# Check if the user is in sudo group
if ! groups | grep -qw "sudo"; then
	sayerr "FAIL: user can not sudo at all because not in sudo group!"
	exit 1
fi

# User is in sudo group - check if he need to enter a password
sudo -l >/dev/null & # will ask the user for password if sudo is not passwordless
pid=$!
uptimesecstart=$(awk '{print $1}' /proc/uptime)
uptimesecstart="${uptimesecstart%.*}" # remove ".xxx" from seconds string
has_pid_stopped $pid $timeout &
while true; do
	# if kill -0 $pid &>/dev/null; then
		# echo -n "."
		fg sudo &>/dev/null; [ $? == 1 ] && break;
	# else
		# break
	# fi
done
uptimesecnow=$(awk '{print $1}' /proc/uptime)
uptimesecnow="${uptimesecnow%.*}" # remove ".xxx" from seconds string
uptimesecdiff=$((uptimesecnow-uptimesecstart))
#echo "uptimesecdiff = $uptimesecdiff"
#echo "timeout = $timeout"
if [ $uptimesecdiff -ge $timeout ]; then
	# User can sudo but requires to input a password
	sayerr "FAIL: user can not sudo without password!"
	exit 2
fi
echo "SUCCESS: user can sudo without password"
exit 0