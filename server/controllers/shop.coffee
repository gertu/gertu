mongoose = require "mongoose"
async    = require "async"
_        = require "underscore"
Shop     = mongoose.model "Shop"
Mailer   = require("../tools/mailer")

exports.signup = (req, res) ->

  if req.body.name and req.body.email and req.body.password

    shop = new Shop(req.body)
    shop.save()

    Mailer.send req.body.email, "Hello", "Hello world"

    res.send JSON.stringify(shop)
  else
    res.status(422).send('Incorrect data')

exports.login = (req, res) ->
  email = req.body.email
  password = req.body.password

  if req.body.email and req.body.password

    Shop.findOne({email: email, password: password}).exec( (err, shopdata) ->
      if err
        res.status(500).send('Application error')
      else if not shopdata?
        res.status(403).send('Access denied')
      else
        # Access granted
        token = 'mitokendeprueba'
        res.cookie('token', token, {maxAge: 10 * 60, httpOnly: true})
        res.send('OK')
    )
  else
    res.status(422).send('Incorrect data')

exports.logoff = (req, res) ->
  token = req.cookies.token

  res.send('OK: ' + token)

exports.emailexists = (req, res) ->
  email = req.body.email

  if email

    Shop.findOne({email: email}).exec( (err, shopdata) ->
      if err
        res.status(500).send('Application error')
      else if not shopdata?
        res.status(404).send('Email does not exist')
      else
        res.status(200).send('Email exists')
    )
  else
    res.status(422).send('Incorrect data')
