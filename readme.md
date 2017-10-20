# Sparrow API for Curl

This repository contains a complete testing script to exercise all Sparrow API commands found at http://foresight.sparrowone.com.

# Running:

First, make a copy of `config.sample` and set environment variables. You must have the machine keys set for tests to pass.

Run all tests

```bash
./api
```

Get help:

`./api help`

Run a single test:

`./api <case_name>`

# List of Test Cases

* `simple_sale`
* `simple_sale_decline`
* `simple_sale_invalid_card`
* `simple_sale_avs_mismatch`
* `advanced_sale`
* `simple_authorization`
* `advanced_auth`
* `simple_capture`
* `simple_offline_capture`
* `simple_refund`
* `advanced_refund`
* `simple_void`
* `advanced_void`
* `passenger_sale`
* `simple_star_card`
* `advanced_star_card`
* `simple_ach`
* `simple_ach_refund`
* `simple_ach_credit`
* `advanced_ach`
* `e_wallet_simple_credit`
* `fiserv_simple_sale`
* `advanced_fiserv_sale`
* `chargeback_entry`
* `retrieve_card_balance`
* `decrypting_custom_fields`
* `account_verification`
* `adding_a_customer`
* `add_customer_credit_card_simple`
* `add_customer_ach_simple`
* `add_customer_e_wallet_simple`
* `update_payment_type`
* `delete_payment_type`
* `delete_data_vault_customer`
* `creating_a_payment_plan`
* `updating_a_payment_plan`
* `deleting_a_plan`
* `assigning_a_payment_plan_to_a_customer`
* `update_payment_plan_assignment`
* `cancel_plan_assignment`
* `creating_an_invoice`
* `creating_active_invoice`
* `update_invoice`
* `retrieve_invoice`
* `cancel_invoice`
* `cancel_invoice_by_customer`
* `paying_an_invoice_with_a_credit_card`
* `paying_an_invoice_with_a_bank_account`