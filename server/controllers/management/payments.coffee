mongoose     = require 'mongoose'
Shop = mongoose.model 'Shop'
Payment = mongoose.model 'Payment'
PaypalAPI = require '../../tools/paypalapi'

exports.list = (req, res) ->
  Shop.find({}).exec( (err, shops) ->
    if err
      res.status(500).send('Database error')
    else

      today = new Date()
      currentMonth = today.getMonth()
      currentYear = today.getFullYear()

      monthStart = new Date(currentYear, currentMonth, 1)
      monthEnd = new Date(currentYear, currentMonth + 1, 0)

      res.render 'pages/management/payments/list',
        shops: shops
        dates:
          start: monthStart.getDate() + '/' + (currentMonth + 1) + '/' + currentYear
          end: monthEnd.getDate() + '/' + (currentMonth + 1) + '/' + currentYear
  )

exports.confirm = (req, res) ->

  id = req.params.id

  Shop.findOne({_id: id}).exec( (err, shop) ->
    if err
      res.status(404)
    else

      paymentPerMonth = 6

      today = new Date()
      currentMonth = today.getMonth()
      currentYear = today.getFullYear()
      currentMonthEndDay = new Date(currentYear, currentMonth + 1, 0).getDate()

      if shop.confirmationDate > new Date(currentYear, currentMonth, 1)
        paymentPerMonth = paymentPerMonth * (shop.confirmationDate.getDate() / currentMonthEndDay)

      paymentPerMonth = (Math.round(paymentPerMonth * 100) / 100)
      
      payment = new Payment
        shop: shop,
        amount: paymentPerMonth
        date: new Date()

      PaypalAPI.makePayment shop.card, shop.billing_address, paymentPerMonth, ((success) ->

        payment.finished = true
        payment.successful = true
        payment.error = null

        payment.save()
      ), ((error) ->

        allErrors = ''

        for errorDetail in error.response.details
          allErrors += errorDetail.field + '---->'
          allErrors += errorDetail.issue + '\n'

        payment.finished = true
        payment.successful = false
        payment.error = allErrors

        payment.save()
      )

      Shop.find({}).exec( (err, shops) ->
        if err
          res.status(500).send('Database error')
        else
          res.redirect 'management/payments/list'
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
  