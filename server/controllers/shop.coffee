mongoose    = require "mongoose"
async       = require "async"
fs          = require "fs"
_           = require "underscore"
Shop        = mongoose.model "Shop"
Mailer      = require("../tools/mailer")

exports.signup = (req, res) ->

  shopName = req.body.name
  shopEmail = req.body.email
  shopPassword = req.body.password

  if shopName and shopEmail and shopPassword

    shop = new Shop(req.body)
    shop.save()

    mailInfo = {
      shopname: shopName
    }

    Mailer.sendTemplate shopEmail,
      'Wellcome to Gertu',
      'newShop',
      mailInfo,
      () ->
        @
      , () ->
        @

    req.session.currentShop =
      shopId: shop._id
      userEmail: shop.email
      isAuthenticated: true

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
        req.session.currentShop = {shopId: shopdata._id, userEmail: shopdata.email, isAuthenticated: true}

        res.send JSON.stringify(shopdata)
    )
  else
    res.status(422).send('Incorrect data')

exports.logout = (req, res) ->

  req.session.destroy()

  res.redirect "/"

exports.current = (req, res) ->

  currentLoggedShop = req.session.currentShop

  res.status(200).send(currentLoggedShop.userEmail) if currentLoggedShop?
  res.status(403).send('Access denied') if not currentLoggedShop?


exports.emailexists = (req, res) ->

  email = req.query.email

  if (email? and email != '')

    Shop.findOne({email: email}).exec( (err, shopdata) ->
      if err
        res.status(500).send('Application error')
      else if not shopdata?
        res.status(200).send('False')
      else
        res.status(200).send('True')
    )
  else
    res.status(422).send('Incorrect data')
