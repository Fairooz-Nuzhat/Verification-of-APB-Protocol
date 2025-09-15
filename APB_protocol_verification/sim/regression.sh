#!/bin/bash

source /tools/script/bashrc_ius_15.2.08

TEST_NAMES="testnames.txt"

while read -r test_case; do
if [[ -n "$test_case" ]]; then
./run.sh coverage $test_case
fi
done<"$TEST_NAMES"
iccr iccr_command.cmd
