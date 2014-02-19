mongoose     = require 'mongoose'
Shop = mongoose.model 'Shop'
Payment = mongoose.model 'Payment'
PaypalAPI = require '../../tools/paypalapi'

exports.list = (req, res) ->
  Shop.find({}).exec( (err, shops) ->
    if err
      res.status(500).send('Database error')
    else
      res.render 'pages/management/payments/list', {shops: shops, dates: {start: '01/01/2001', end: '31/01/2001'}}
  )

exports.confirm = (req, res) ->
  id = req.params.id

  Shop.findOne({_id: id}).exec( (err, shop) ->
    if err
      res.status(404)
    else

      payment = new Payment
        shop: shop,
        amount: 5.5

      console.log shop.card

      PaypalAPI.makePayment shop.card, 8, ((success) ->
        console.log success
        payment.save()
      ), ((error) ->
        console.log error)

      Shop.find({}).exec( (err, shops) ->
        if err
          res.status(500).send('Database error')
        else
          res.render 'pages/management/payments/list', {shops: shops, dates: {start: '01/01/2001', end: '31/01/2001'}}
      )
  )

exports.history = (req, res) ->
  id = req.params.id

  Shop.findOne({_id: id}).exec( (err, shop) ->
    if err
      res.status(500).send('Database error')
    else
      Payment.find({shop: shop._id}).exec( (err, payments) ->
        res.render 'pages/management/payments/history', {payments: payments, shop: shop}
      )
  )
  