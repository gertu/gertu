paypal_api = require('paypal-rest-sdk')

(->
  PaypalAPI = { }

  PaypalAPI.makePayment = (creditCardInfo, billing_address, amount, onSuccess, onError) ->
    config_opts =
      host: "api.sandbox.paypal.com"
      port: ""
      client_id: "EBWKjlELKMYqRNQ6sYvFo64FtaRLRR5BdHEESmha49TM"
      client_secret: "EO422dn3gQLgDbuwqTjzrFgFtaRLRR5BdHEESmha49TM"

    create_payment_json =
      intent: "sale"
      payer:
        payment_method: "credit_card"
        funding_instruments: [credit_card:
          type: creditCardInfo.type.toLowerCase()
          number: creditCardInfo.number.toString()
          expire_month: creditCardInfo.expire_month.toString()
          expire_year: creditCardInfo.expire_year.toString()
          cvv2: creditCardInfo.cvv2.toString()
          first_name: creditCardInfo.first_name.toString()
          last_name: creditCardInfo.last_name.toString()
          billing_address: billing_address
        ]

      transactions: [
        amount:
          total: amount.toString()
          currency: "EUR"
         
        description: "This is the payment transaction description."
      ]

    paypal_api.payment.create create_payment_json, config_opts, (err, res) ->
      if err and onError?
        console.log 'Payment ERROR'
        console.log create_payment_json
        onError(err)
      if res and onSuccess?
        console.log 'Payment OK'
        onSuccess(res)
      return

  module.exports = PaypalAPI
)()