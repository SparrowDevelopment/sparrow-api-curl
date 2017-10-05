#!/bin/bash

#http://foresight.sparrowone.com/#!/documenter-creating-a-sale

if [ -v $MKEY ]; then
	echo MKEY environment variable must be set.  Set it by
	echo export MKEY=MyKeyValue
	exit 1
fi

checkResponse()
{
	if [[ $RESPONSE == *"textresponse=SUCCESS"* ]]; then
		echo Success
	else
		echo Error
	fi
	echo $RESPONSE;
}

CARDNUM=4111111111111111
CARDEXP=1019
CVV=999
AMOUNT=9.95

###############################################################################
# Sale Transactions
###############################################################################
TESTCASE=sale
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	RESPONSE=`curl -d "mkey=$MKEY&transtype=sale&amount=$AMOUNT&cardnum=$CARDNUM&cardexp=$CARDEXP&cvv=$CVV" \
		https://secure.sparrowone.com/Payments/Services_api.aspx`
	checkResponse
fi

TESTCASE=sale-decline
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	RESPONSE=`curl -d "mkey=$MKEY&transtype=sale&amount=0.01&cardnum=$CARDNUM&cardexp=$CARDEXP&cvv=$CVV" \
		https://secure.sparrowone.com/Payments/Services_api.aspx`
	checkResponse
fi

TESTCASE=sale-invalid-card
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	RESPONSE=`curl -d "mkey=$MKEY&transtype=sale&amount=0.01&cardnum=1234567887654321&cardexp=$CARDEXP&cvv=$CVV" \
		https://secure.sparrowone.com/Payments/Services_api.aspx`
	checkResponse
fi

TESTCASE=sale-avs-mismatch
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	RESPONSE=`curl -d "mkey=$MKEY&transtype=sale&amount=$AMOUNT&cardnum=$CARDNUM&cardexp=$CARDEXP&cvv=$CVV&"\
"address1=888&zip=77777" \
		https://secure.sparrowone.com/Payments/Services_api.aspx`
	checkResponse
fi