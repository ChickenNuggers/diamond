#!/usr/bin/env zsh
set -o pipefail # Line 18

# Check for prerequisites
for command in go; do # Leave dynamically done if later commands required
	command -v $command >&- 2>&-
	if [[ ! $? -eq 0 ]]; then
		echo "Command not found: $command"
		echo "Please install this command and attempt reinstallation"
		exit 1
	fi
done

# Check for Carbon
command -v carbon >&- 2>&-
if [[ ! $? -eq 0 ]]; then
	echo "Installing Carbon"
	go get -v github.com/carbonsrv/carbon | tee go.log || exit 1
	echo "Retrieved Carbon"
fi
