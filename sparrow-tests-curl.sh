#!/bin/bash

#http://foresight.sparrowone.com/#!/documenter-creating-a-sale

if [ -v $MKEY ]; then
	echo MKEY environment variable must be set.  Set it by
	echo export MKEY=MyKeyValue
	exit 1
fi

error=0
transid=""
checkResponse()
{
	if [[ $response == *$1* ]]; then
		echo Success
	else
		echo Error
		error=1
	fi
	echo $response;
	
	transid=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)
}

cardnum=4111111111111111
card_exp=1019
cvv=999
amount=9.95
url=https://secure.sparrowone.com/Payments/Services_api.aspx

###############################################################################
# Sale
###############################################################################
TESTCASE=sale
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=$amount&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"cvv=$cvv" \
		$url`

	checkResponse "textresponse=SUCCESS"
fi

TESTCASE=sale_decline
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=0.01&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"cvv=$cvv" \
		$url`

	checkResponse "textresponse=DECLINE"
fi

TESTCASE=sale_invalid_card
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=$amount&"\
"cardnum=1234567887654321&"\
"cardexp=$card_exp&"\
"cvv=$cvv" \
		$url`

	checkResponse "textresponse=Invalid+Credit+Card+Number"
fi

TESTCASE=sale_avs_mismatch
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=$amount"\
"&cardnum=$cardnum"\
"&cardexp=$card_exp&"\
"cvv=$cvv&"\
"address1=888&"\
"zip=77777" \
		$url`

	checkResponse "textresponse=SUCCESS"
fi

TESTCASE=sale_advanced
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"amount=10.68&"\
"cvv=$cvv&"\
"currency=USD&"\
"firstname=John&"\
"lastname=Doe&"\
"skunumber_1=123&"\
"description_1=Widget+(Brown)&"\
"amount_1=4.99&"\
"quantity_1=1&"\
"skunumber_2=456&"\
"description_2=Widget+(Blue)&"\
"amount_2=1.99&"\
"quantity_2=2&"\
"orderdesc=Order+Description&"\
"orderid=123&"\
"cardipaddress=8.8.8.8&"\
"tax=0.71&"\
"shipamount=1&"\
"ponumber=%2b14805551234&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=dmckinney%40dabmi.com&"\
"shipfirstname=John&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+One&"\
"shipaddress1=16100+N+71st+Street&"\
"shipaddress2=Suite+170&"\
"shipcity=Scottsdale&"\
"shipstate=AZ&"\
"shipzip=85254&"\
"shipcountry=US&"\
"shipphone=%2b14805551234&"\
"shipemail=duane%40dabmi.com"\
		$url`

	checkResponse "textresponse=SUCCESS"
fi

###############################################################################
# Authorization/Capture
###############################################################################
TESTCASE=auth
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=auth&"\
"amount=$amount&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"cvv=$cvv" \
		$url`

	checkResponse "textresponse=SUCCESS"
	
	echo $transid
	
	response=`curl -d "mkey=$MKEY&"\
"transtype=capture&"\
"transid=$transid&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"sendtransreceipttobillemail=true&"\
"sendtransreceipttoshipemail=true&"\
"sendtransreceipttoemails=dmckinney@dabmi.com"\
		$url`

	checkResponse "textresponse=SUCCESS"
fi

###############################################################################
# Simple Offline Capture
###############################################################################
TESTCASE=offline_capture
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=offline&"\
"amount=$amount&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"authcode=123456&"\
"authdate=01/01/2017&"\
"cvv=$cvv" \
		$url`

	checkResponse "textresponse=SUCCESS"
fi

###############################################################################
# Simple Refund
###############################################################################
TESTCASE=refund
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=$amount&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"cvv=$cvv" \
		$url`

	checkResponse "textresponse=SUCCESS"
	
	response=`curl -d "mkey=$MKEY&"\
"transtype=refund&"\
"transid=$transid&"\
"amount=1.00&"\
		$url`

	checkResponse "textresponse=SUCCESS"
fi

###############################################################################
# Advanced Refund
###############################################################################
TESTCASE=refund_advanced
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=$amount&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"cvv=$cvv&"\
"email=duane@dabmi.com&"\
"shipemail=joe@example.com"\
		$url`

	checkResponse "textresponse=SUCCESS"
	
	response=`echo -d "mkey=$MKEY&"\
"transtype=refund&"\
"transid=$transid&"\
"amount=1.00&"\
"opt_amount_type_1=surcharge&"\
"opt_amount_value_1=1.00&"\
"sendtransreceipttobillemail=true&"\
"sendtransreceipttoshipemail=true&"\
"sendtransreceipttoemails=dmckinney@dabmi.com"\
		$url`
		
#"opt_amount_type_2=etc&"\
#"opt_amount_value_2=1.25&"\

	checkResponse "textresponse=SUCCESS"
fi

###############################################################################
# Void
###############################################################################
TESTCASE=void
if [ -v $1 ] || [ $1 == "all" ] || [ $1 == $TESTCASE ] ; then
	response=`curl -d "mkey=$MKEY&"\
"transtype=sale&"\
"amount=$amount&"\
"cardnum=$cardnum&"\
"cardexp=$card_exp&"\
"cvv=$cvv&"\
"email=duane@dabmi.com&"\
"shipemail=joe@example.com"\
		$url`

	checkResponse "textresponse=SUCCESS"
	
	response=`curl -d "mkey=$MKEY&"\
"transtype=void&"\
"transid=$transid&"\
"amount=1.00&"\
		$url`
		
#"opt_amount_type_2=etc&"\
#"opt_amount_value_2=1.25&"\

	checkResponse "textresponse=SUCCESS"
fi



exit $error