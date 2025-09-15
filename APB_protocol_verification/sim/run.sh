#!/bin/bash

source /tools/script/bashrc
source /tools/script/bashrc_ius_15.2.08
MODE=$1
test_case=$2;
freq=$3;
if [[ $MODE == "batch" ]]; then irun -timescale 1ns/1ps -f filelist.f -access +rwc -uvm +UVM_TESTNAME=$test_case +UVM_VERBOSITY=UVM_NONE +FREQUENCY=$freq -svseed random
elif [[ $MODE == "gui" ]]; then irun -timescale 1ns/1ps -f filelist.f -access +rwc -gui -uvm +UVM_TESTNAME=$test_case +UVM_VERBOSITY=UVM_NONE +FREQUENCY=$freq -svseed random
elif [[ $MODE == "coverage" ]]; then irun -timescale 1ns/1ps -f filelist.f -access +rwc -coverage all -covtest $test_case -uvm +UVM_TESTNAME=$test_case +UVM_VERBOSITY=UVM_NONE -svseed random +FREQUENCY=$freq -covfile cov.ccf
fi
