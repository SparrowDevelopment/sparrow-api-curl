#!/bin/bash

#http://foresight.sparrowone.com/#!/documenter-creating-a-sale

if [ -v $M_KEY ]; then
	echo M_KEY environment variable must be set.  Set it by
	echo export M_KEY=MyKeyValue
	exit 1
fi

if [ -v $1 ]; then
	echo usage ./sparrow-tests-curl test_case_name
	echo test case names:
	echo all
	
echo simple_sale
echo simple_sale_decline
echo simple_sale_invalid_card
echo simple_sale_avs_mismatch
echo advanced_sale
echo simple_authorization
echo advanced_auth
echo simple_capture
echo simple_offline_capture
echo simple_refund
echo advanced_refund
echo simple_void
echo advanced_void
echo passenger_sale
echo simple_star_card
echo advanced_star_card
echo simple_ach
echo advanced_ach
echo e_wallet_simple_credit
echo fiserv_simple_sale
echo advanced_fiserv_sale
echo chargeback_entry
echo retrieve_card_balance
echo decrypting_custom_fields
echo account_verification
echo adding_a_customer
echo add_customer_credit_card_simple
echo add_customer_ach_simple
echo add_customer_star_simple
echo add_customer_e_wallet_simple
echo update_payment_type
echo delete_payment_type
echo delete_data_vault_customer
echo creating_a_payment_plan
echo updating_a_payment_plan
echo notification_settings
echo deleting_a_plan
echo assigning_a_payment_plan_to_a_customer
echo update_payment_plan_assignment
echo cancel_plan_assignment
echo creating_an_invoice
echo update_invoice
echo retrieve_invoice
echo cancel_invoice
echo cancel_invoice_by_customer
echo paying_an_invoice_with_a_credit_card
echo paying_an_invoice_with_a_bank_account
fi

error=0
checkResponse()
{
	if [[ $response == *$1* ]]; then
		echo Pass
	else
		echo Fail
		error=1
	fi
	echo $response;
}

card_num=4111111111111111
card_exp=1019
cvv=999
amount=9.95
url=https://secure.sparrowone.com/Payments/Services_api.aspx
################################################################################
# Simple Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale" ] ; then
  echo Simple Sale
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Sale Decline
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale_decline" ] ; then
  echo Simple Sale Decline
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=0.01&"\
"cvv=$cvv"\
    $url`
    checkResponse "textresponse=DECLINE"
fi

################################################################################
# Simple Sale Invalid Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale_invalid_card" ] ; then
  echo Simple Sale Invalid Card
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=1234567890123456&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`
    checkResponse "textresponse=Invalid+Credit+Card+Number"
fi

################################################################################
# Simple Sale AVS mismatch
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale_avs_mismatch" ] ; then
  echo Simple Sale AVS mismatch
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=0.01&"\
"cvv=$cvv&"\
"address1=888&"\
"zip=77777"\
    $url`
    checkResponse "textresponse=DECLINE"
fi

################################################################################
# Advanced Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_sale" ] ; then
  echo Advanced Sale
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv&"\
"currency=USD&"\
"firstname=John&"\
"lastname=Doe&"\
"skunumber_1=123&"\
"description_1=Blue+widget&"\
"amount_1=1.99&"\
"quantity_1=1&"\
"skunumber_2=456&"\
"description_2=Brown+widget&"\
"amount_2=2.99&"\
"quantity_2=2&"\
"orderdesc=Order+Description&"\
"orderid=11111&"\
"cardipaddress=8.8.8.8&"\
"tax=0.25&"\
"shipamount=1.25&"\
"ponumber=22222&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Authorization
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_authorization" ] ; then
  echo Simple Authorization
  response=`curl -s -d \
"transtype=auth&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Advanced Auth
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_auth" ] ; then
  echo Advanced Auth
  response=`curl -s -d \
"transtype=auth&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv&"\
"currency=USD&"\
"firstname=John&"\
"lastname=Doe&"\
"skunumber_1=123&"\
"description_1=Blue+widget&"\
"amount_1=1.99&"\
"quantity_1=1&"\
"skunumber_2=456&"\
"description_2=Brown+widget&"\
"amount_2=2.99&"\
"quantity_2=2&"\
"orderdesc=Order+Description&"\
"orderid=11111&"\
"cardipaddress=8.8.8.8&"\
"tax=0.25&"\
"shipamount=1.25&"\
"ponumber=22222&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Capture
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_capture" ] ; then
  echo Simple Capture
  response=`curl -s -d \
"transtype=auth&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`

trans_id=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)

  response=`curl -s -d \
"transtype=capture&"\
"mkey=$M_KEY&"\
"transid=$trans_id&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"sendtransreceipttobillemail=true&"\
"sendtransreceipttoshipemail=true&"\
"sendtransreceipttoemails=email%40email.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Offline Capture
#todo:I don't know if this is going to be possible to write a test case for.  Is there a test verbal auth code I can use?
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_offline_capture" ] ; then
  echo Simple Offline Capture
  response=`curl -s -d \
"transtype=offline&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"authcode=VerbalAuthCode&"\
"authdate=01%2f31%2f2017&"\
"cvv=$cvv"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Refund
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_refund" ] ; then
  echo Simple Refund
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`

trans_id=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)

  response=`curl -s -d \
"transtype=refund&"\
"mkey=$M_KEY&"\
"transid=$trans_id&"\
"amount=$amount"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Advanced Refund
#todo:If I include opt_amoutextresponse=Transaction+Void+Successfult_type_# and opt_amount_value_# in the sale, then I this test case will pass, but they are not documented as part in Advanced Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_refund" ] ; then
  echo Advanced Refund
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`

trans_id=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)

  response=`curl -s -d \
"transtype=refund&"\
"mkey=$M_KEY&"\
"transid=$trans_id&"\
"amount=$amount&"\
"opt_amount_type_1=surcharge&"\
"opt_amount_value_1=1.01&"\
"sendtransreceipttobillemail=true&"\
"sendtransreceipttoshipemail=true&"\
"sendtransreceipttoemails=email%40email.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Void
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_void" ] ; then
  echo Simple Void
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`

trans_id=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)

  response=`curl -s -d \
"transtype=void&"\
"mkey=$M_KEY&"\
"transid=$trans_id&"\
"amount=$amount"\
    $url`
    checkResponse "textresponse=Transaction+Void+Successful"
fi

################################################################################
# Advanced Void
#todo:If I include opt_amoutextresponse=Transaction+Void+Successfult_type_# and opt_amount_value_# in the sale, then I this test case will pass, but they are not documented as part in Advanced Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_void" ] ; then
  echo Advanced Void
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`

trans_id=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)

  response=`curl -s -d \
"transtype=void&"\
"mkey=$M_KEY&"\
"transid=$trans_id&"\
"amount=$amount&"\
"opt_amount_type_1=surcharge&"\
"opt_amount_value_1=1.01&"\
"sendtransreceipttobillemail=true&"\
"sendtransreceipttoshipemail=true&"\
"sendtransreceipttoemails=email%40email.com"\
    $url`
    checkResponse "textresponse=Transaction+Void+Successful"
fi

################################################################################
# Passenger Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "passenger_sale" ] ; then
  echo Passenger Sale
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv&"\
"passengername=John+Doe&"\
"stopovercode1=O&"\
"airportcode1=LAS&"\
"airportcode2=CDG&"\
"airportcode3=IAD&"\
"airportcode4=CPH&"\
"carriercoupon1 carriercoupon2 carriercoupon3 carriercoupon4=AA%3bBB&"\
"airlinecodenumber=AA0&"\
"ticketnumber=1234567890&"\
"classofservicecoupon1 classofservicecoupon2 classofservicecoupon3 classofservicecoupon4=00%3bAA&"\
"flightdatecoupon1=01%2f31%2f2017&"\
"flightdeparturetimecoupon1=23%3a59&"\
"addressverificationcode=A&"\
"approvalcode=123456&"\
"transactionid=1234567890&"\
"authcharindicator=A&"\
"referencenumber=123456789012&"\
"validationcode=1234&"\
"authresponsecode=AB"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple Star Card
#todo:The fields documented are incomplete.  Can I assume that they should be the same as Advanced Sale?
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_star_card" ] ; then
  echo Simple Star Card
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"amount=$amount&"\
"CID=12345678901"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Advanced Star Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_star_card" ] ; then
  echo Advanced Star Card
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"CID=12345678901&"\
"currency=USD&"\
"firstname=John&"\
"lastname=Doe&"\
"skunumber_1=123&"\
"description_1=Blue+widget&"\
"amount_1=1.99&"\
"quantity_1=1&"\
"skunumber_2=456&"\
"description_2=Brown+widget&"\
"amount_2=2.99&"\
"quantity_2=2&"\
"orderdesc=Order+Description&"\
"orderid=11111&"\
"cardipaddress=8.8.8.8&"\
"tax=0.25&"\
"shipamount=1.25&"\
"ponumber=22222&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Simple ACH
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_ach" ] ; then
  echo Simple ACH
  response=`curl -s -d \
"transtype=sale%2f+refund%2f+credit&"\
"mkey=$M_KEY&"\
"bankname=&"\
"routing=0000000&"\
"account=1111111&"\
"achaccounttype=checking&"\
"achaccountsubtype=personal&"\
"amount=$amount"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Advanced ACH
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_ach" ] ; then
  echo Advanced ACH
  response=`curl -s -d \
"transtype=sale%2f+refund%2f+credit&"\
"mkey=$M_KEY&"\
"bankname=&"\
"routing=0000000&"\
"account=1111111&"\
"achaccounttype=checking&"\
"achaccountsubtype=personal&"\
"amount=$amount&"\
"orderdesc=Order+Description&"\
"orderid=11111&"\
"firstname=John&"\
"lastname=Doe&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"phone=7025551234&"\
"email=john%40norepy.com&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com&"\
"saveclient=true&"\
"updateclient=true&"\
"opt_amount_type_1=surcharge&"\
"opt_amount_value_1=1.01&"\
"opt_amount_percentage_1=18&"\
"birthdate=01%2f31%2f2000&"\
"checknumber=123&"\
"driverlicensenumber=1234567890&"\
"driverlicensecountry=US&"\
"driverlicensestate=AZ&"\
"sendtransreceipttobillemail=true&"\
"sendtransreceipttoshipemail=true&"\
"paymentdescriptor=Custom+Payment+Descriptor"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# eWallet Simple Credit
################################################################################
if [ "$1" == "all" ] || [ "$1" == "ewallet_simple_credit" ] ; then
  echo eWallet Simple Credit
  response=`curl -s -d \
"transtype=credit&"\
"mkey=$M_KEY&"\
"ewalletaccount=john%40norepy.com&"\
"ewallet type=PayPal&"\
"amount=$amount&"\
"currency=USD"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Fiserv Simple Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "fiserv_simple_sale" ] ; then
  echo Fiserv Simple Sale
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Advanced Fiserv Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_fiserv_sale" ] ; then
  echo Advanced Fiserv Sale
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv&"\
"currency=USD&"\
"firstname=John&"\
"lastname=Doe&"\
"skunumber_1=123&"\
"description_1=Blue+widget&"\
"amount_1=1.99&"\
"quantity_1=1&"\
"skunumber_2=456&"\
"description_2=Brown+widget&"\
"amount_2=2.99&"\
"quantity_2=2&"\
"orderdesc=Order+Description&"\
"orderid=11111&"\
"cardipaddress=8.8.8.8&"\
"tax=0.25&"\
"shipamount=1.25&"\
"ponumber=22222&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Chargeback Entry
################################################################################
if [ "$1" == "all" ] || [ "$1" == "chargeback_entry" ] ; then
  echo Chargeback Entry
  response=`curl -s -d \
"transtype=sale&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv"\
    $url`

trans_id=$(grep -oP '(?<=transid=)\d+?(?=&)' <<< $response)

  response=`curl -s -d \
"transtype=chargeback&"\
"mkey=$M_KEY&"\
"transid=$trans_id&"\
"reason=Reason+for+chargeback"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Retrieve Card Balance
################################################################################
if [ "$1" == "all" ] || [ "$1" == "retrieve_card_balance" ] ; then
  echo Retrieve Card Balance
  response=`curl -s -d \
"transtype=balanceincuire&"\
"mkey=$M_KEY&"\
"cardnum=$card_num"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Decrypting Custom Fields
################################################################################
if [ "$1" == "all" ] || [ "$1" == "decrypting_custom_fields" ] ; then
  echo Decrypting Custom Fields
  response=`curl -s -d \
"transtype=decrypt&"\
"mkey=$M_KEY&"\
"fieldname=customField1&"\
"customertoken=CustomerToken&"\
"paymenttoken=PaymentToken"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Account Verification
################################################################################
if [ "$1" == "all" ] || [ "$1" == "account_verification" ] ; then
  echo Account Verification
  response=`curl -s -d \
"transtype=auth&"\
"mkey=$M_KEY&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"amount=$amount&"\
"cvv=$cvv&"\
"zip=85254"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Adding a Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "adding_a_customer" ] ; then
  echo Adding a Customer
  response=`curl -s -d \
"transtype=addcustomer&"\
"mkey=$M_KEY&"\
"firstname=John&"\
"lastname=Doe&"\
"note=Customer+Note&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com&"\
"username=JohnDoe&"\
"password=Password123&"\
"clientuseremail=john%40norepy.com&"\
"paytype_1=creditcard&"\
"firstname_1=John&"\
"lastname_1=Doe&"\
"address1_1=123+Main+Street&"\
"address2_1=Suite+1&"\
"city_1=Pheonix&"\
"state_1=AZ&"\
"zip_1=85111&"\
"country_1=US&"\
"phone_1=6025551234&"\
"email_1=john%40norepy.com&"\
"cardnum_1=4111111111111111&"\
"cardexp_1=1019&"\
"bankname_1=&"\
"routing_1=&"\
"account_1=&"\
"achaccounttype_1=&"\
"payno_1=1&"\
"ewalletaccount_1=&"\
"paytype_2=check&"\
"firstname_2=John&"\
"lastname_2=Doe&"\
"address1_2=321+1st+Street&"\
"address2_2=Suite+2&"\
"city_2=Scottsdale&"\
"state_2=AZ&"\
"zip_2=85222&"\
"country_2=US&"\
"phone_2=6025554321&"\
"email_2=jane%40noreploy.com&"\
"cardnum_2=4111111111111111&"\
"cardexp_2=1019&"\
"payno_2=2&"\
"achaccountsubtype=personal"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Add Customer Credit Card Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_credit_card_simple" ] ; then
  echo Add Customer Credit Card Simple
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=addcustomer&"\
"firstname=John&"\
"token=&"\
"lastname=Doe&"\
"cardnum_1=4111111111111111&"\
"cardexp_1=1019&"\
"cardnum_2=4111111111111111&"\
"cardexp_2=1019"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Add Customer ACH Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_ach_simple" ] ; then
  echo Add Customer ACH Simple
  response=`curl -s -d \
"VARIABLE NAME=&"\
"mkey=$M_KEY&"\
"transtype=addcustomer&"\
"token=&"\
"firstname=John&"\
"lastname=Doe&"\
"bankname_1=&"\
"routing_1=&"\
"account_1="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Add Customer Star Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_star_simple" ] ; then
  echo Add Customer Star Simple
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=addcustomer&"\
"token=&"\
"firstname=John&"\
"lastname=Doe&"\
"cardnum_1=4111111111111111&"\
"cardnum_2=4111111111111111&"\
"CID=12345678901"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Add Customer eWallet Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_ewallet_simple" ] ; then
  echo Add Customer eWallet Simple
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=addcustomer&"\
"token=&"\
"firstname=John&"\
"lastname=Doe&"\
"ewalletaccount_1="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Update Payment Type
################################################################################
if [ "$1" == "all" ] || [ "$1" == "update_payment_type" ] ; then
  echo Update Payment Type
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=updatecustomer&"\
"token=&"\
"firstname=John&"\
"lastname=Doe&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"phone=7025551234&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com&"\
"username=JohnDoe&"\
"password=Password123&"\
"clientuseremail=john%40norepy.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Delete Payment Type
################################################################################
if [ "$1" == "all" ] || [ "$1" == "delete_payment_type" ] ; then
  echo Delete Payment Type
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=updatecustomer&"\
"token_1=&"\
"operationtype_1="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Delete Data Vault Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "delete_data_vault_customer" ] ; then
  echo Delete Data Vault Customer
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=deletecustomer&"\
"token="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Creating a Payment Plan
################################################################################
if [ "$1" == "all" ] || [ "$1" == "creating_a_payment_plan" ] ; then
  echo Creating a Payment Plan
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"planname=PaymentPlan1&"\
"plandesc=1st+Payment+Plan&"\
"startdate=01%2f31%2f2017&"\
"defaultachmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultcreditcardmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultecheckmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultstartcardmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultewalletmkey=T6YQTCA3RK3IEW8R14ITSJBI"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Updating a Payment Plan
################################################################################
if [ "$1" == "all" ] || [ "$1" == "updating_a_payment_plan" ] ; then
  echo Updating a Payment Plan
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"token=&"\
"planname=PaymentPlan1&"\
"plandesc=1st+Payment+Plan&"\
"startdate=01%2f31%2f2017&"\
"defaultachmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultcreditcardmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultecheckmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultstartcardmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"defaultewalletmkey=T6YQTCA3RK3IEW8R14ITSJBI&"\
"userrecycling=true&"\
"notifyfailures=true&"\
"retrycount=2&"\
"retrytype=daily&"\
"retryperiod=2&"\
"retrydayofweek=&"\
"retryfirstdayofmonth=&"\
"retryseconddayofmonth=&"\
"autocreateclientaccounts=true"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Notification Settings
################################################################################
if [ "$1" == "all" ] || [ "$1" == "notification_settings" ] ; then
  echo Notification Settings
  response=`curl -s -d \
"reviewonassignment=&"\
"processimmediately=&"\
"overridesender=&"\
"senderemail=&"\
"notifyupcomingpayment=&"\
"notifydaysbeforeupcomingpayment=&"\
"notifyplansummary=&"\
"notifyplansummaryinterval=&"\
"notifyplansummaryemails=&"\
"notifydailystats=&"\
"notifydailystatsemails=&"\
"notifyplancomplete=&"\
"notifyplancompleteemails=&"\
"notifydecline=&"\
"notifydeclineemails=&"\
"notifyviaftp=&"\
"notifyviaftpurl=&"\
"notifyviaftpusername=&"\
"notifyviaftppassword=&"\
"notifyflagged=&"\
"notifyflaggedemails="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Deleting a Plan
################################################################################
if [ "$1" == "all" ] || [ "$1" == "deleting_a_plan" ] ; then
  echo Deleting a Plan
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"token=&"\
"cancelpayments="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Assigning a Payment Plan to a Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "assigning_a_payment_plan_to_a_customer" ] ; then
  echo Assigning a Payment Plan to a Customer
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"customertoken=CustomerToken&"\
"plantoken=&"\
"paymenttoken=PaymentToken&"\
"startdate=01%2f31%2f2017&"\
"productid=&"\
"description=&"\
"notifyfailures=true&"\
"userecycling=true&"\
"retrycount=2&"\
"retrytype=daily&"\
"retryperiod=2&"\
"retrydayofweek=&"\
"retryfirstdayofmonth=&"\
"retryseconddayofmonth=&"\
"proratedpayment=&"\
"routingkey="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Update Payment Plan Assignment
################################################################################
if [ "$1" == "all" ] || [ "$1" == "update_payment_plan_assignment" ] ; then
  echo Update Payment Plan Assignment
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"assignmenttoken=&"\
"paymenttoken=PaymentToken&"\
"startdate=01%2f31%2f2017&"\
"productid=&"\
"description=&"\
"notifyfailures=true&"\
"userecycling=true&"\
"retrycount=2&"\
"retrytype=daily&"\
"retryperiod=2&"\
"retrydayofweek=&"\
"retryfirstdayofmonth=&"\
"retryseconddayofmonth=&"\
"proratedpayment=&"\
"routingkey="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Cancel Plan Assignment
################################################################################
if [ "$1" == "all" ] || [ "$1" == "cancel_plan_assignment" ] ; then
  echo Cancel Plan Assignment
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"assignment?token="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Creating an Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "creating_an_invoice" ] ; then
  echo Creating an Invoice
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"customertoken=CustomerToken&"\
"invoicedate=&"\
"currency=USD&"\
"invoicestatus=&"\
"invoicesource=&"\
"invoiceamount=&"\
"invoiceitemsku_1=&"\
"invoiceitemdescription_1=&"\
"invoiceitemprice_1=&"\
"invoiceitemquantity_1=&"\
"sendpaymentlinkemail="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Update Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "update_invoice" ] ; then
  echo Update Invoice
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"invoicenumber=&"\
"customertoken=CustomerToken&"\
"invoicedate=&"\
"currency=USD&"\
"invoicestatus=&"\
"invoicesource=&"\
"invoiceamount=&"\
"invoiceitemsku_1=&"\
"invoiceitemdescription_1=&"\
"invoiceitemprice_1=&"\
"invoiceitemquantity_1=&"\
"sendpaymentlinkemail="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Retrieve Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "retrieve_invoice" ] ; then
  echo Retrieve Invoice
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"invoicenumber="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Cancel Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "cancel_invoice" ] ; then
  echo Cancel Invoice
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"invoicenumber=&"\
"invoicestatusreason="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Cancel Invoice by Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "cancel_invoice_by_customer" ] ; then
  echo Cancel Invoice by Customer
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"invoicenumber=&"\
"invoicestatusreason="\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Paying an Invoice with a Credit Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "paying_an_invoice_with_a_credit_card" ] ; then
  echo Paying an Invoice with a Credit Card
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"invoicenumber=&"\
"cardnum=$card_num&"\
"cardexp=$card_exp&"\
"cvv=$cvv&"\
"firstname=John&"\
"lastname=Doe&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

################################################################################
# Paying an Invoice with a Bank Account
################################################################################
if [ "$1" == "all" ] || [ "$1" == "paying_an_invoice_with_a_bank_account" ] ; then
  echo Paying an Invoice with a Bank Account
  response=`curl -s -d \
"mkey=$M_KEY&"\
"transtype=&"\
"invoicenumber=&"\
"bankname=&"\
"routing=0000000&"\
"account=1111111&"\
"achaccounttype=checking&"\
"achaccountsubtype=personal&"\
"firstname=John&"\
"lastname=Doe&"\
"company=Sparrow+One&"\
"address1=16100+N+71st+Street&"\
"address2=Suite+170&"\
"city=Scottsdale&"\
"state=AZ&"\
"zip=85254&"\
"country=US&"\
"email=john%40norepy.com&"\
"shipfirstname=Jane&"\
"shiplastname=Doe&"\
"shipcompany=Sparrow+Two&"\
"shipaddress1=16100+N+72nd+Street&"\
"shipaddress2=Suite+171&"\
"shipcity=Pheonix&"\
"shipstate=AZ&"\
"shipzip=85004&"\
"shipcountry=US&"\
"shipphone=6025551234&"\
"shipemail=jane%40noreply.com"\
    $url`
    checkResponse "textresponse=SUCCESS"
fi

