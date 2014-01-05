mongoose = require 'mongoose'
Currency = mongoose.model 'Currency'

exports.list = (req, res) ->
  Currency.find({}).exec( (err, currencies) ->
    if err
      res.status(500).send('Database error')
    else
      console.log currencies
      res.render 'pages/management/currencies/list', {currencies: currencies}
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