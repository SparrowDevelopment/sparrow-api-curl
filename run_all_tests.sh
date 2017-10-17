#!/bin/bash

#export M_KEY=
#export ACH_M_KEY=
#export E_WALLET_M_KEY=

# Run all tests and ave the output
./sparrow-tests-curl.sh -c"-s" all | tee output

# Run a single test and be extra verbose
#./sparrow-tests-curl.sh -vv -c"-s" adding_a_customer
