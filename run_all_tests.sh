#!/bin/bash

export M_KEY=CUK5YODHVAZHFBM6KESZO1J4
export ACH_M_KEY=RZOZ2AMMYF7GX2VF1L05WW1G
export E_WALLET_M_KEY=1W53QL0TJLIERXHIQKRXJRTK

./sparrow-tests-curl.sh -c"-s" all | tee output
#./sparrow-tests-curl.sh -c"-s" adding_a_customer
#./sparrow-tests-curl2.sh simple_sale | tee output