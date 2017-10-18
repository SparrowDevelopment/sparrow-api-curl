
#!/bin/bash

#http://foresight.sparrowone.com/#!/documenter-creating-a-sale

curl_options=""
verbose=0
while getopts ":vc:" opt; do
    case $opt in
        v) verbose=$((verbose + 1));;
	    c) curl_options=$OPTARG;;
        \?) #echo "Invalid option: -$OPTARG";;
    esac
done
shift "$((OPTIND-1))"

if [ -z $M_KEY ]; then
    echo M_KEY environment variable must be set in order to test credit card transactions.
    echo export M_KEY=MyKeyValue
fi
if [ -z $ACH_M_KEY ]; then
    echo ACH_M_KEY environment variable must be set in order to test ACH transactions.
    echo export ACH_M_KEY=MyKeyValue
fi
if [ -z $E_WALLET_M_KEY ]; then
    echo E_WALLET_M_KEY environment variable must be set in order to test eWallet transactions.
    echo export E_WALLET_M_KEY=MyKeyValue
fi

if [ -z $1 ]; then
    echo "usage ./sparrow-tests-curl [options...] <test_case_name>"
    echo -v show request and response
    echo -vv show setup request and response
    echo "-c <curl options>"
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
    echo simple_ach_refund
    echo simple_ach_credit
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
    echo add_customer_e_wallet_simple
    echo update_payment_type
    echo delete_payment_type
    echo delete_data_vault_customer
    echo creating_a_payment_plan
    echo updating_a_payment_plan
    echo deleting_a_plan
    echo assigning_a_payment_plan_to_a_customer
    echo update_payment_plan_assignment
    echo cancel_plan_assignment
    echo creating_an_invoice
    echo creating_active_invoice
    echo update_invoice
    echo retrieve_invoice
    echo cancel_invoice
    echo cancel_invoice_by_customer
    echo paying_an_invoice_with_a_credit_card
    echo paying_an_invoice_with_a_bank_account    
fi

error=0
check_Response_Result=Pass
pass_Count=0
fail_Count=0
check_Response()
{
    grep -Esqi $1 <<< $2
    if [ $? -eq 0 ]; then
        check_Response_Result=Pass
        pass_Count=$((pass_Count + 1))
    else
        error=1
        check_Response_Result="Fail expected $1"
        fail_Count=$((fail_Count + 1))
    fi
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
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple Sale $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Sale Decline
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale_decline" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=0.01&\
cvv=999\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=DECLINE" "$response"
    echo Simple Sale Decline $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Sale Invalid Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale_invalid_card" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=1234567890123456&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Invalid\+Credit\+Card\+Number" "$response"
    echo Simple Sale Invalid Card $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Sale AVS mismatch
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_sale_avs_mismatch" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=0.01&\
cvv=999&\
address1=888&\
zip=77777\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=DECLINE" "$response"
    echo Simple Sale AVS mismatch $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_sale" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999&\
currency=USD&\
firstname=John&\
lastname=Doe&\
skunumber_1=123&\
skunumber_2=456&\
description_1=Blue widget&\
description_2=Brown widget&\
amount_1=1.99&\
amount_2=2.99&\
quantity_1=1&\
quantity_2=2&\
orderdesc=Order Description&\
orderid=11111&\
cardipaddress=8.8.8.8&\
tax=0.25&\
shipamount=1.25&\
ponumber=22222&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Advanced Sale $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Authorization
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_authorization" ] ; then
        command="curl $curl_options -d \"\
transtype=auth&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple Authorization $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced Auth
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_auth" ] ; then
        command="curl $curl_options -d \"\
transtype=auth&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999&\
currency=USD&\
firstname=John&\
lastname=Doe&\
skunumber_1=123&\
skunumber_2=456&\
description_1=Blue widget&\
description_2=Brown widget&\
amount_1=1.99&\
amount_2=2.99&\
quantity_1=1&\
quantity_2=2&\
orderdesc=Order Description&\
orderid=11111&\
cardipaddress=8.8.8.8&\
tax=0.25&\
shipamount=1.25&\
ponumber=22222&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Advanced Auth $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Capture
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_capture" ] ; then
    # Required Setup Transaction Simple Authorization
    command="curl $curl_options -d \"\
transtype=auth&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple Authorization
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=capture&\
mkey=$M_KEY&\
transid=$transid&\
cardexp=1019&\
amount=9.95&\
sendtransreceipttobillemail=true&\
sendtransreceipttoshipemail=true&\
sendtransreceipttoemails=email@email.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple Capture $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Offline Capture
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_offline_capture" ] ; then
        command="curl $curl_options -d \"\
transtype=offline&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
authcode=123456&\
authdate=01/31/2017&\
cvv=999\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple Offline Capture $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Refund
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_refund" ] ; then
    # Required Setup Transaction Simple Sale
    command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple Sale
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=refund&\
mkey=$M_KEY&\
transid=$transid&\
amount=9.95\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple Refund $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced Refund
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_refund" ] ; then
    # Required Setup Transaction Simple Sale
    command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple Sale
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=refund&\
mkey=$M_KEY&\
transid=$transid&\
amount=9.95&\
sendtransreceipttobillemail=true&\
sendtransreceipttoshipemail=true&\
sendtransreceipttoemails=email@email.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Advanced Refund $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Void
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_void" ] ; then
    # Required Setup Transaction Simple Sale
    command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple Sale
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=void&\
mkey=$M_KEY&\
transid=$transid&\
amount=9.95\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Transaction\+Void\+Successful" "$response"
    echo Simple Void $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced Void
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_void" ] ; then
    # Required Setup Transaction Simple Sale
    command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple Sale
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=void&\
mkey=$M_KEY&\
transid=$transid&\
sendtransreceipttobillemail=true&\
sendtransreceipttoshipemail=true&\
sendtransreceipttoemails=email@email.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Transaction\+Void\+Successful" "$response"
    echo Advanced Void $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Passenger Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "passenger_sale" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999&\
passengername=John Doe&\
stopovercode1=O&\
airportcode1=LAS&\
airportcode2=CDG&\
airportcode3=IAD&\
airportcode4=CPH&\
carriercoupon1 carriercoupon2 carriercoupon3 carriercoupon4=AA;BB&\
airlinecodenumber=AA0&\
ticketnumber=1234567890&\
classofservicecoupon1 classofservicecoupon2 classofservicecoupon3 classofservicecoupon4=00;AA&\
flightdatecoupon1=01/31/2017&\
flightdeparturetimecoupon1=23:59&\
addressverificationcode=A&\
approvalcode=123456&\
transactionid=1234567890&\
authcharindicator=A&\
referencenumber=123456789012&\
validationcode=1234&\
authresponsecode=AB\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Passenger Sale $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple Star Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_star_card" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
amount=9.95&\
cardexp=1019&\
CID=12345678901\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple Star Card $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced Star Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_star_card" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
CID=12345678901&\
currency=USD&\
firstname=John&\
lastname=Doe&\
skunumber_1=123&\
skunumber_2=456&\
description_1=Blue widget&\
description_2=Brown widget&\
amount_1=1.99&\
amount_2=2.99&\
quantity_1=1&\
quantity_2=2&\
orderdesc=Order Description&\
orderid=11111&\
cardipaddress=8.8.8.8&\
tax=0.25&\
shipamount=1.25&\
ponumber=22222&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Advanced Star Card $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple ACH
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_ach" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$ACH_M_KEY&\
bankname=First Test Bank&\
routing=110000000&\
account=1234567890123&\
achaccounttype=checking&\
achaccountsubtype=personal&\
amount=9.95&\
firstname=John&\
lastname=Doe\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple ACH $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple ACH Refund
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_ach_refund" ] ; then
    # Required Setup Transaction Simple ACH
    command="curl $curl_options -d \"\
transtype=sale&\
mkey=$ACH_M_KEY&\
bankname=First Test Bank&\
routing=110000000&\
account=1234567890123&\
achaccounttype=checking&\
achaccountsubtype=personal&\
amount=9.95&\
firstname=John&\
lastname=Doe\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple ACH
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=refund&\
mkey=$ACH_M_KEY&\
transid=$transid&\
bankname=First Test Bank&\
routing=110000000&\
account=1234567890123&\
achaccounttype=checking&\
achaccountsubtype=personal&\
amount=9.95\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=(SUCCESS|Transaction\+not\+found)" "$response"
    echo Simple ACH Refund $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Simple ACH Credit
################################################################################
if [ "$1" == "all" ] || [ "$1" == "simple_ach_credit" ] ; then
        command="curl $curl_options -d \"\
transtype=credit&\
mkey=$ACH_M_KEY&\
bankname=First Test Bank&\
routing=110000000&\
account=1234567890123&\
achaccounttype=checking&\
achaccountsubtype=personal&\
amount=9.95&\
firstname=John&\
lastname=Doe\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Simple ACH Credit $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced ACH
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_ach" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$ACH_M_KEY&\
bankname=First Test Bank&\
routing=110000000&\
account=1234567890123&\
achaccounttype=checking&\
achaccountsubtype=personal&\
amount=9.95&\
orderdesc=Order Description&\
orderid=11111&\
firstname=John&\
lastname=Doe&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
phone=7025551234&\
email=john@norepy.com&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com&\
saveclient=true&\
updateclient=true&\
opt_amount_type_1=surcharge&\
opt_amount_value_1=1.01&\
opt_amount_percentage_1=18&\
birthdate=01/31/2000&\
checknumber=123&\
driverlicensenumber=1234567890&\
driverlicensecountry=US&\
driverlicensestate=AZ&\
sendtransreceipttobillemail=true&\
sendtransreceipttoshipemail=true&\
paymentdescriptor=Custom Payment Descriptor\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Advanced ACH $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# eWallet Simple Credit
################################################################################
if [ "$1" == "all" ] || [ "$1" == "e_wallet_simple_credit" ] ; then
        command="curl $curl_options -d \"\
transtype=credit&\
mkey=$E_WALLET_M_KEY&\
ewalletaccount=user@example.com&\
ewallet type=PayPal&\
amount=9.95&\
currency=USD\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Successful" "$response"
    echo eWallet Simple Credit $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Fiserv Simple Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "fiserv_simple_sale" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Fiserv Simple Sale $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Advanced Fiserv Sale
################################################################################
if [ "$1" == "all" ] || [ "$1" == "advanced_fiserv_sale" ] ; then
        command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999&\
currency=USD&\
firstname=John&\
lastname=Doe&\
skunumber_1=123&\
skunumber_2=456&\
description_1=Blue widget&\
description_2=Brown widget&\
amount_1=1.99&\
amount_2=2.99&\
quantity_1=1&\
quantity_2=2&\
orderdesc=Order Description&\
orderid=11111&\
cardipaddress=8.8.8.8&\
tax=0.25&\
shipamount=1.25&\
ponumber=22222&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Advanced Fiserv Sale $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Chargeback Entry
################################################################################
if [ "$1" == "all" ] || [ "$1" == "chargeback_entry" ] ; then
    # Required Setup Transaction Simple Sale
    command="curl $curl_options -d \"\
transtype=sale&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999\"\
        $url"
    response=`eval $command`
    transid=$(grep -oP '(?<=transid=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Simple Sale
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
transtype=chargeback&\
mkey=$M_KEY&\
transid=$transid&\
reason=Reason for chargeback\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Reason\+for\+chargeback" "$response"
    echo Chargeback Entry $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Retrieve Card Balance
################################################################################
if [ "$1" == "all" ] || [ "$1" == "retrieve_card_balance" ] ; then
        command="curl $curl_options -d \"\
transtype=balanceinquire&\
mkey=$M_KEY&\
cardnum=4005562231212149&\
cardexp=1225\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=(SUCCESS|RE0491|Operation\+type\+is\+not\+supported\+by\+payment\+processor)" "$response"
    echo Retrieve Card Balance $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Decrypting Custom Fields
################################################################################
if [ "$1" == "all" ] || [ "$1" == "decrypting_custom_fields" ] ; then
        command="curl $curl_options -d \"\
transtype=decrypt&\
mkey=$M_KEY&\
fieldname=customField1&\
customertoken=CustomerToken&\
paymenttoken=PaymentToken\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=(SUCCESS|Internal\+processing\+error)" "$response"
    echo Decrypting Custom Fields $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Account Verification
################################################################################
if [ "$1" == "all" ] || [ "$1" == "account_verification" ] ; then
        command="curl $curl_options -d \"\
transtype=auth&\
mkey=$M_KEY&\
cardnum=4111111111111111&\
cardexp=1019&\
amount=9.95&\
cvv=999&\
zip=85254\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=(APPROVED|SUCCESS)" "$response"
    echo Account Verification $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Adding a Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "adding_a_customer" ] ; then
        now=$(date +%Y%m%d%k%M%s)
    command="curl $curl_options -d \"\
transtype=addcustomer&\
mkey=$M_KEY&\
firstname=John&\
lastname=Doe&\
note=Customer Note&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com&\
username=u$now&\
password=Password123&\
clientuseremail=john@norepy.com&\
paytype_1=creditcard&\
paytype_2=check&\
firstname_1=John&\
firstname_2=John&\
lastname_1=Doe&\
lastname_2=Doe&\
address1_1=123 Main Street&\
address1_2=321 1st Street&\
address2_1=Suite 1&\
address2_2=Suite 2&\
city_1=Pheonix&\
city_2=Scottsdale&\
state_1=AZ&\
state_2=AZ&\
zip_1=85111&\
zip_2=85222&\
country_1=US&\
country_2=US&\
phone_1=6025551234&\
phone_2=6025554321&\
email_1=john@norepy.com&\
email_2=jane@noreploy.com&\
cardnum_1=4111111111111111&\
cardnum_2=4111111111111111&\
cardexp_1=1019&\
cardexp_2=1019&\
bankname_1=&\
bankname_2=First Test Bank&\
routing_1=&\
routing_2=110000000&\
account_1=&\
account_2=1234567890123&\
achaccounttype_1=&\
achaccounttype_2=personal&\
payno_1=1&\
payno_2=2\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Customer\+with\+token.*successfully\+created" "$response"
    echo Adding a Customer $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Add Customer Credit Card Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_credit_card_simple" ] ; then
        command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Customer\+with\+token.*successfully\+created" "$response"
    echo Add Customer Credit Card Simple $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Add Customer ACH Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_ach_simple" ] ; then
        command="curl $curl_options -d \"\
mkey=$ACH_M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
bankname_1=First Test Bank&\
routing_1=110000000&\
account_1=1234567890123&\
paytype_1=ach&\
achaccounttype_1=checking&\
achaccountsubtype_1=personal\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Customer\+with\+token.*successfully\+created" "$response"
    echo Add Customer ACH Simple $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Add Customer eWallet Simple
################################################################################
if [ "$1" == "all" ] || [ "$1" == "add_customer_e_wallet_simple" ] ; then
        command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
ewalletaccount_1=user@example.com&\
paytype_1=ewallet&\
ewallettype_1=paypal\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Customer\+with\+token.*successfully\+created" "$response"
    echo Add Customer eWallet Simple $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Update Payment Type
################################################################################
if [ "$1" == "all" ] || [ "$1" == "update_payment_type" ] ; then
    # Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=updatecustomer&\
token=$customertoken&\
firstname=John&\
lastname=Doe&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
phone=7025551234&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Customer\+with\+token.*successfully\+updated" "$response"
    echo Update Payment Type $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Delete Payment Type
################################################################################
if [ "$1" == "all" ] || [ "$1" == "delete_payment_type" ] ; then
    # Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    paymenttoken_1=$(grep -oP '(?<=paymenttoken_1=).+?(?=&|\z)' <<< $response)
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=updatecustomer&\
token_1=$paymenttoken_1&\
operationtype_1=deletepaytype&\
token=$customertoken\"\
        $url"
    response=`eval $command`
    check_Response "Customer\+with\+token.+successfully\+updated" "$response"
    echo Delete Payment Type $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Delete Data Vault Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "delete_data_vault_customer" ] ; then
    # Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=deletecustomer&\
token=$customertoken\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Delete Data Vault Customer $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Creating a Payment Plan
################################################################################
if [ "$1" == "all" ] || [ "$1" == "creating_a_payment_plan" ] ; then
        command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addplan&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
sequence_1=1&\
sequence_2=2&\
amount_1=1.99&\
amount_2=2.99&\
scheduletype_1=custom&\
scheduletype_2=monthly&\
scheduleday_1=7&\
scheduleday_2=1&\
duration_1=365&\
duration_2=-1&\
productid_1=abc&\
productid_2=123&\
description_1=Weekly&\
description_2=Monthly&\
notifyfailures=false&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=1&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Creating a Payment Plan $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Updating a Payment Plan
################################################################################
if [ "$1" == "all" ] || [ "$1" == "updating_a_payment_plan" ] ; then
    # Required Setup Transaction Creating a Payment Plan
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addplan&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
sequence_1=1&\
sequence_2=2&\
amount_1=1.99&\
amount_2=2.99&\
scheduletype_1=custom&\
scheduletype_2=monthly&\
scheduleday_1=7&\
scheduleday_2=1&\
duration_1=365&\
duration_2=-1&\
productid_1=abc&\
productid_2=123&\
description_1=Weekly&\
description_2=Monthly&\
notifyfailures=false&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=1&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    plantoken=$(grep -oP '(?<=plantoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=updateplan&\
token=$plantoken&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
userrecycling=true&\
notifyfailures=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=2&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Updating a Payment Plan $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Deleting a Plan
################################################################################
if [ "$1" == "all" ] || [ "$1" == "deleting_a_plan" ] ; then
    # Required Setup Transaction Creating a Payment Plan
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addplan&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
sequence_1=1&\
sequence_2=2&\
amount_1=1.99&\
amount_2=2.99&\
scheduletype_1=custom&\
scheduletype_2=monthly&\
scheduleday_1=7&\
scheduleday_2=1&\
duration_1=365&\
duration_2=-1&\
productid_1=abc&\
productid_2=123&\
description_1=Weekly&\
description_2=Monthly&\
notifyfailures=false&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=1&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    plantoken=$(grep -oP '(?<=plantoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=deleteplan&\
token=$plantoken&\
cancelpayments=true\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Deleting a Plan $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Assigning a Payment Plan to a Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "assigning_a_payment_plan_to_a_customer" ] ; then
    # Required Setup Transaction Adding a Customer
    now=$(date +%Y%m%d%k%M%s)
    command="curl $curl_options -d \"\
transtype=addcustomer&\
mkey=$M_KEY&\
firstname=John&\
lastname=Doe&\
note=Customer Note&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com&\
username=u$now&\
password=Password123&\
clientuseremail=john@norepy.com&\
paytype_1=creditcard&\
paytype_2=check&\
firstname_1=John&\
firstname_2=John&\
lastname_1=Doe&\
lastname_2=Doe&\
address1_1=123 Main Street&\
address1_2=321 1st Street&\
address2_1=Suite 1&\
address2_2=Suite 2&\
city_1=Pheonix&\
city_2=Scottsdale&\
state_1=AZ&\
state_2=AZ&\
zip_1=85111&\
zip_2=85222&\
country_1=US&\
country_2=US&\
phone_1=6025551234&\
phone_2=6025554321&\
email_1=john@norepy.com&\
email_2=jane@noreploy.com&\
cardnum_1=4111111111111111&\
cardnum_2=4111111111111111&\
cardexp_1=1019&\
cardexp_2=1019&\
bankname_1=&\
bankname_2=First Test Bank&\
routing_1=&\
routing_2=110000000&\
account_1=&\
account_2=1234567890123&\
achaccounttype_1=&\
achaccounttype_2=personal&\
payno_1=1&\
payno_2=2\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    paymenttoken_1=$(grep -oP '(?<=paymenttoken_1=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Adding a Customer;Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
# Required Setup Transaction Creating a Payment Plan
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addplan&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
sequence_1=1&\
sequence_2=2&\
amount_1=1.99&\
amount_2=2.99&\
scheduletype_1=custom&\
scheduletype_2=monthly&\
scheduleday_1=7&\
scheduleday_2=1&\
duration_1=365&\
duration_2=-1&\
productid_1=abc&\
productid_2=123&\
description_1=Weekly&\
description_2=Monthly&\
notifyfailures=false&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=1&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    plantoken=$(grep -oP '(?<=plantoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Adding a Customer;Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=assignplan&\
customertoken=$customertoken&\
plantoken=$plantoken&\
paymenttoken=$paymenttoken_1&\
startdate=01/31/2017&\
notifyfailures=true&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=2&\
notifyfailuresemails=jdoe@example.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Success" "$response"
    echo Assigning a Payment Plan to a Customer $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Update Payment Plan Assignment
################################################################################
if [ "$1" == "all" ] || [ "$1" == "update_payment_plan_assignment" ] ; then
    # Required Setup Transaction Assigning a Payment Plan to a Customer
# Required Setup Transaction Adding a Customer
    now=$(date +%Y%m%d%k%M%s)
    command="curl $curl_options -d \"\
transtype=addcustomer&\
mkey=$M_KEY&\
firstname=John&\
lastname=Doe&\
note=Customer Note&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com&\
username=u$now&\
password=Password123&\
clientuseremail=john@norepy.com&\
paytype_1=creditcard&\
paytype_2=check&\
firstname_1=John&\
firstname_2=John&\
lastname_1=Doe&\
lastname_2=Doe&\
address1_1=123 Main Street&\
address1_2=321 1st Street&\
address2_1=Suite 1&\
address2_2=Suite 2&\
city_1=Pheonix&\
city_2=Scottsdale&\
state_1=AZ&\
state_2=AZ&\
zip_1=85111&\
zip_2=85222&\
country_1=US&\
country_2=US&\
phone_1=6025551234&\
phone_2=6025554321&\
email_1=john@norepy.com&\
email_2=jane@noreploy.com&\
cardnum_1=4111111111111111&\
cardnum_2=4111111111111111&\
cardexp_1=1019&\
cardexp_2=1019&\
bankname_1=&\
bankname_2=First Test Bank&\
routing_1=&\
routing_2=110000000&\
account_1=&\
account_2=1234567890123&\
achaccounttype_1=&\
achaccounttype_2=personal&\
payno_1=1&\
payno_2=2\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    paymenttoken_1=$(grep -oP '(?<=paymenttoken_1=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Adding a Customer;Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
# Required Setup Transaction Creating a Payment Plan
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addplan&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
sequence_1=1&\
sequence_2=2&\
amount_1=1.99&\
amount_2=2.99&\
scheduletype_1=custom&\
scheduletype_2=monthly&\
scheduleday_1=7&\
scheduleday_2=1&\
duration_1=365&\
duration_2=-1&\
productid_1=abc&\
productid_2=123&\
description_1=Weekly&\
description_2=Monthly&\
notifyfailures=false&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=1&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    plantoken=$(grep -oP '(?<=plantoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Adding a Customer;Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=assignplan&\
customertoken=$customertoken&\
plantoken=$plantoken&\
paymenttoken=$paymenttoken_1&\
startdate=01/31/2017&\
notifyfailures=true&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=2&\
notifyfailuresemails=jdoe@example.com\"\
        $url"
    response=`eval $command`
    assignmenttoken=$(grep -oP '(?<=assignmenttoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Assigning a Payment Plan to a Customer
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=updateassignment&\
assignmenttoken=$assignmenttoken&\
paymenttoken=$paymenttoken_1&\
startdate=1/1/2018&\
notifyfailures=true&\
userecycling=true&\
retrycount=3&\
retrytype=daily&\
retryperiod=2\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Update Payment Plan Assignment $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Cancel Plan Assignment
################################################################################
if [ "$1" == "all" ] || [ "$1" == "cancel_plan_assignment" ] ; then
    # Required Setup Transaction Assigning a Payment Plan to a Customer
# Required Setup Transaction Adding a Customer
    now=$(date +%Y%m%d%k%M%s)
    command="curl $curl_options -d \"\
transtype=addcustomer&\
mkey=$M_KEY&\
firstname=John&\
lastname=Doe&\
note=Customer Note&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com&\
username=u$now&\
password=Password123&\
clientuseremail=john@norepy.com&\
paytype_1=creditcard&\
paytype_2=check&\
firstname_1=John&\
firstname_2=John&\
lastname_1=Doe&\
lastname_2=Doe&\
address1_1=123 Main Street&\
address1_2=321 1st Street&\
address2_1=Suite 1&\
address2_2=Suite 2&\
city_1=Pheonix&\
city_2=Scottsdale&\
state_1=AZ&\
state_2=AZ&\
zip_1=85111&\
zip_2=85222&\
country_1=US&\
country_2=US&\
phone_1=6025551234&\
phone_2=6025554321&\
email_1=john@norepy.com&\
email_2=jane@noreploy.com&\
cardnum_1=4111111111111111&\
cardnum_2=4111111111111111&\
cardexp_1=1019&\
cardexp_2=1019&\
bankname_1=&\
bankname_2=First Test Bank&\
routing_1=&\
routing_2=110000000&\
account_1=&\
account_2=1234567890123&\
achaccounttype_1=&\
achaccounttype_2=personal&\
payno_1=1&\
payno_2=2\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    paymenttoken_1=$(grep -oP '(?<=paymenttoken_1=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Adding a Customer;Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
# Required Setup Transaction Creating a Payment Plan
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addplan&\
planname=PaymentPlan1&\
plandesc=1st Payment Plan&\
startdate=01/31/2017&\
defaultachmkey=$ACH_M_KEY&\
defaultcreditcardmkey=$M_KEY&\
defaultcheckmkey=$M_KEY&\
defaultstarcardmkey=$M_KEY&\
defaulte_walletmkey=$M_KEY&\
sequence_1=1&\
sequence_2=2&\
amount_1=1.99&\
amount_2=2.99&\
scheduletype_1=custom&\
scheduletype_2=monthly&\
scheduleday_1=7&\
scheduleday_2=1&\
duration_1=365&\
duration_2=-1&\
productid_1=abc&\
productid_2=123&\
description_1=Weekly&\
description_2=Monthly&\
notifyfailures=false&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=1&\
autocreateclientaccounts=true\"\
        $url"
    response=`eval $command`
    plantoken=$(grep -oP '(?<=plantoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Adding a Customer;Creating a Payment Plan
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=assignplan&\
customertoken=$customertoken&\
plantoken=$plantoken&\
paymenttoken=$paymenttoken_1&\
startdate=01/31/2017&\
notifyfailures=true&\
userecycling=true&\
retrycount=2&\
retrytype=daily&\
retryperiod=2&\
notifyfailuresemails=jdoe@example.com\"\
        $url"
    response=`eval $command`
    assignmenttoken=$(grep -oP '(?<=assignmenttoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Assigning a Payment Plan to a Customer
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=cancelassignment&\
assignmenttoken=$assignmenttoken\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=SUCCESS" "$response"
    echo Cancel Plan Assignment $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Creating an Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "creating_an_invoice" ] ; then
    # Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=draft&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=invoice\+has\+been\+successfully\+created" "$response"
    echo Creating an Invoice $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Creating active Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "creating_active_invoice" ] ; then
    # Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=active&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=invoice\+has\+been\+successfully\+created" "$response"
    echo Creating active Invoice $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Update Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "update_invoice" ] ; then
    # Required Setup Transaction Creating an Invoice
# Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=draft&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    invoicenumber=$(grep -oP '(?<=invoicenumber=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating an Invoice
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=updateinvoice&\
invoicenumber=$invoicenumber&\
invoicedate=12/15/2017&\
currency=USD&\
invoicestatus=active&\
invoicesource=DataVault&\
invoiceamount=15.00\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Invoice\+has\+been\+successfully\+updated" "$response"
    echo Update Invoice $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Retrieve Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "retrieve_invoice" ] ; then
    # Required Setup Transaction Creating an Invoice
# Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=draft&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    invoicenumber=$(grep -oP '(?<=invoicenumber=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating an Invoice
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=getinvoice&\
invoicenumber=$invoicenumber\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Success" "$response"
    echo Retrieve Invoice $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Cancel Invoice
################################################################################
if [ "$1" == "all" ] || [ "$1" == "cancel_invoice" ] ; then
    # Required Setup Transaction Creating an Invoice
# Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=draft&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    invoicenumber=$(grep -oP '(?<=invoicenumber=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating an Invoice
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=cancelinvoice&\
invoicenumber=$invoicenumber&\
invoicestatusreason=Testing Cancel Feature\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=invoice\+has\+been\+successfully\+canceled" "$response"
    echo Cancel Invoice $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Cancel Invoice by Customer
################################################################################
if [ "$1" == "all" ] || [ "$1" == "cancel_invoice_by_customer" ] ; then
    # Required Setup Transaction Creating an Invoice
# Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=draft&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    invoicenumber=$(grep -oP '(?<=invoicenumber=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating an Invoice
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=cancelinvoicebycustomer&\
invoicenumber=$invoicenumber&\
invoicestatusreason=Cancel Invoice By Customer\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=invoice\+has\+been\+successfully\+canceled" "$response"
    echo Cancel Invoice by Customer $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Paying an Invoice with a Credit Card
################################################################################
if [ "$1" == "all" ] || [ "$1" == "paying_an_invoice_with_a_credit_card" ] ; then
    # Required Setup Transaction Creating active Invoice
# Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=active&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    invoicenumber=$(grep -oP '(?<=invoicenumber=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating active Invoice
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$M_KEY&\
transtype=payinvoice&\
invoicenumber=$invoicenumber&\
cardnum=4111111111111111&\
cardexp=1019&\
cvv=999&\
firstname=John&\
lastname=Doe&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Invoice\+has\+been\+successfully\+paid" "$response"
    echo Paying an Invoice with a Credit Card $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi

################################################################################
# Paying an Invoice with a Bank Account
################################################################################
if [ "$1" == "all" ] || [ "$1" == "paying_an_invoice_with_a_bank_account" ] ; then
    # Required Setup Transaction Creating active Invoice
# Required Setup Transaction Add Customer Credit Card Simple
    command="curl $curl_options -d \"\
mkey=$ACH_M_KEY&\
transtype=addcustomer&\
firstname=John&\
lastname=Doe&\
paytype_1=creditcard&\
cardnum_1=4111111111111111&\
cardexp_1=1019\"\
        $url"
    response=`eval $command`
    customertoken=$(grep -oP '(?<=customertoken=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Add Customer Credit Card Simple
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$ACH_M_KEY&\
transtype=createmerchantinvoice&\
customertoken=$customertoken&\
invoicedate=12/01/2017&\
currency=USD&\
invoicestatus=active&\
invoicesource=DataVault&\
invoiceamount=10.00&\
invoiceitemsku_1=123&\
invoiceitemsku_2=456&\
invoiceitemdescription_1=Widget 1&\
invoiceitemdescription_2=Widget 2&\
invoiceitemprice_1=2.00&\
invoiceitemprice_2=4.00&\
invoiceitemquantity_1=1&\
invoiceitemquantity_2=2\"\
        $url"
    response=`eval $command`
    invoicenumber=$(grep -oP '(?<=invoicenumber=).+?(?=&|\z)' <<< $response)
    if [ $verbose -gt 1 ] ; then
            echo Creating active Invoice
            echo $command
            echo $response
            echo
        fi
    command="curl $curl_options -d \"\
mkey=$ACH_M_KEY&\
transtype=payinvoice&\
invoicenumber=$invoicenumber&\
bankname=First Test Bank&\
routing=110000000&\
account=1234567890123&\
achaccounttype=checking&\
achaccountsubtype=personal&\
firstname=John&\
lastname=Doe&\
company=Sparrow One&\
address1=16100 N 71st Street&\
address2=Suite 170&\
city=Scottsdale&\
state=AZ&\
zip=85254&\
country=US&\
email=john@norepy.com&\
shipfirstname=Jane&\
shiplastname=Doe&\
shipcompany=Sparrow Two&\
shipaddress1=16100 N 72nd Street&\
shipaddress2=Suite 171&\
shipcity=Pheonix&\
shipstate=AZ&\
shipzip=85004&\
shipcountry=US&\
shipphone=6025551234&\
shipemail=jane@noreply.com\"\
        $url"
    response=`eval $command`
    check_Response "textresponse=Invoice\+has\+been\+successfully\+paid" "$response"
    echo Paying an Invoice with a Bank Account $check_Response_Result
    if [ $verbose -gt 0 ] || [[ $check_Response_Result == Fail* ]] ; then
        echo $command
        echo $response
        echo
    fi
fi


echo $((pass_Count + fail_Count)) tests.
echo $pass_Count passing.
echo $fail_Count failing.