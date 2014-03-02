mongoose = require 'mongoose'
Currency = mongoose.model 'Currency'
http     = require('http')
async    = require('async')

exports.list = (req, res) ->

  message = ''

  if req.query.message == 'ratioload'
    message = 'Se ha solicitado la obtención de ratios de monedas. Refresque en unos segundos para actualizar.'

  Currency.find({}).exec( (err, currencies) ->
    if err
      res.status(500).send('Database error')
    else
      res.render 'pages/management/currencies/list', {currencies: currencies, message: message}
  )

exports.add = (req, res) ->
  currency = {_id: 0, name: '', code: '', conversionRate: '1'}
  res.render 'pages/management/currencies/edit', {currency: currency}

exports.edit = (req, res) ->

  id = req.params.id

  Currency.findOne({_id: id}).exec( (err, currency) ->
    if err
      res.status(404)
    else
      res.render 'pages/management/currencies/edit', {currency: currency}
  )

exports.editDo = (req, res) ->

  id = req.params.id
  name = req.body.name
  code = req.body.code
  conversionRate = req.body.conversionRate

  if id == '0'
    currency = new Currency({name: name, code: code, conversionRate: conversionRate})
    currency.save(() ->
      res.redirect '/management/currencies/list?rnd=' + Math.random()
    )
  else
    Currency.findOne({_id: id}).exec( (err, currency) ->
      if err
        res.status(404)
      else
        currency.name = name
        currency.code = code
        currency.conversionRate = conversionRate

        currency.save(() ->
          res.redirect '/management/currencies/list?rnd=' + Math.random()
        )
    )

exports.remove = (req, res) ->

  id = req.params.id

  Currency.findOne({_id: id}).exec( (err, currency) ->
    if err
      res.status(404)
    else
      res.render 'pages/management/currencies/remove', {currency: currency}
  )

exports.removeDo = (req, res) ->

  id = req.params.id

  Currency.findOne({_id: id}).exec( (err, currency) ->
    if err
      res.status(404)
    else
      currency.remove(()->
        res.redirect '/management/currencies/list?rnd=' + Math.random()
      )
  )

exports.loadRates = (req, res) ->
  Currency.find({}).exec( (err, currencies) ->
    if err
      res.status(500).send('Database error')
    else

      count = 0
      async.whilst (->
        count < currencies.length
      ), ((callback) ->

        currency = currencies[count]

        options =
          host: "rate-exchange.appspot.com"
          path: "/currency?from=" + currency.code + "&to=EUR"
          port: 80
          method: "GET"

        request = http.request(options, (response) ->
          conversionInfo = ''
          response.on "data", (data) ->
            conversionInfo += data

          response.on "end", ->
            currency.conversionRate = parseFloat(JSON.parse(conversionInfo).rate)

            currency.save()
        )
        request.on "error", (err) ->
          console.log "Problem with request: " + err.message

        request.end()

        count++
        callback()
      ), (err) ->
        @

      res.redirect '/management/currencies/list?message=ratioload'
  )