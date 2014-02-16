should   = require "should"
PaypalAPI= require "../../server/tools/paypalapi"
PaypalSDK= require('paypal-rest-sdk')
mongoose = require "mongoose"
Payment  = mongoose.model "Payment"
Shop     = mongoose.model "Shop"

describe "Paypal API testing", ->

  shopWithPaymentInfo = {}

  before (done) ->
    

    shopWithPaymentInfo = new Shop
      name: 'my shop',
      email: 'gertufake@gertuproject.info',
      password: '123456',
      confirmed: true
      confirmationDate = new Date()
      
    shopWithPaymentInfo.card = {
      type: 'visa',
      number: '4417119669820331',
      expire_month: '11',
      expire_year: '2018',
      cvv2: '123',
      first_name: 'Joe',
      last_name: 'Shopper'
    }

    shopWithPaymentInfo.billing_address = {
      line1: '52 N Main ST'
      city: 'Johnstown'
      state: 'OH'
      postal_code: '43210'
      country_code: 'US'
    }

    Payment.remove().exec()
    Shop.remove().exec()

    shopWithPaymentInfo.save(()->
      done()
      )
  
  describe "Paymet API", ->
    

    it "SDK API testing should always work (taken from examples)", (done) ->
      @timeout(20000)
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
            type: "visa"
            number: "4417119669820331"
            expire_month: "11"
            expire_year: "2018"
            cvv2: "874"
            first_name: "Joe"
            last_name: "Shopper"
            billing_address:
              line1: "52 N Main ST"
              city: "Johnstown"
              state: "OH"
              postal_code: "43210"
              country_code: "US"
          ]

        transactions: [
          amount:
            total: "7"
            currency: "USD"
            details:
              subtotal: "5"
              tax: "1"
              shipping: "1"

          description: "This is the payment transaction description."
        ]

      PaypalSDK.payment.create create_payment_json, config_opts, (err, res) ->
        if err
          console.log err
          
        if res
          res.should.have.property 'state', 'approved'
          done()


    it "should make a payment ", (done) ->
      @timeout(20000)
      PaypalAPI.makePayment(shopWithPaymentInfo.card,
        shopWithPaymentInfo.billing_address,
        8,
        ()->
          done()
        ,
        (error)->
          console.log error
      )

  after (done) ->
    Payment.remove().exec()
    Shop.remove().exec()

    
    done()