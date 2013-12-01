mongoose = require("mongoose")
async    = require("async")
_        = require("underscore")
Shop     = mongoose.model "Shop"

exports.signup = (req, res) ->
  shop = new Shop({ name: req.body.name, email: req.body.email, password: req.body.password })
  shop.save()
  res.send(shop._id)

exports.login = (req, res) ->
  email = req.body.email
  password = req.body.password

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

exports.logoff = (req, res) ->
  token = req.cookies.token

  res.send('OK: ' + token)
