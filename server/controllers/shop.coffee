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
      shopname: shopName,
      confirmationId: shop._id
    }

    Mailer.sendTemplate shopEmail,
      'Wellcome to Gertu',
      'newShop',
      mailInfo
      , () ->
        @
      , (error) ->
        @

    res.status(200).send()
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
      else if not shopdata.confirmed
        res.status(401).send(shopdata)
      else
        # Access granted
        req.session.currentShop = {shopId: shopdata._id, userEmail: shopdata.email, isAuthenticated: true}

        res.send JSON.stringify(shopdata)
    )
  else
    res.status(422).send('Incorrect data')

exports.confirmAccount = (req, res) ->
 
  Shop.findOne({_id: req.params.accountid}).exec( (err, shopdata) ->
    if shopdata
      shopdata.confirmed = true
      shopdata.save()

      req.session.currentShop = {shopId: shopdata._id, userEmail: shopdata.email, isAuthenticated: true}
      res.send JSON.stringify(shopdata)

      res.redirect "/admin/profile?confirmed"
    else
      res.redirect "/"
  )
  
exports.resendConfirmationAccount = (req, res) ->

  Shop.findOne({_id: req.body.id}).exec( (err, shopdata) ->
    if shopdata
      mailInfo = {
        shopname: shopdata.name,
        confirmationId: shopdata._id
      }

      Mailer.sendTemplate shopdata.email,
        'Wellcome to Gertu',
        'newShop',
        mailInfo
        , () ->
          @
        , (error) ->
          @

      res.status(200).send('Incorrect data')
    else
      res.status(404).send('Incorrect data')
  )

exports.logout = (req, res) ->

  req.session.destroy()

  res.redirect "/"

exports.current = (req, res) ->

  currentLoggedShop = req.session.currentShop

  res.status(200).send(currentLoggedShop.userEmail) if currentLoggedShop?
  res.status(403).send('Access denied') if not currentLoggedShop?

exports.currentShopInfo = (req, res) ->

  currentLoggedShop = req.session.currentShop

  shopId = currentLoggedShop.shopId

  Shop.findOne({_id: shopId}).exec( (err, shopdata) ->
    if err
      res.status(500).send('Application error')
    else if not shopdata?
      res.status(403).send('Access denied')
    else
      res.send JSON.stringify(shopdata)
  )
 
exports.updateShopInfo = (req, res) ->

  currentLoggedShop = req.session.currentShop

  shopId = currentLoggedShop.shopId

  Shop.findOne({_id: shopId}).exec( (err, shopdata) ->
    if err
      res.status(500).send('Application error')
    else if not shopdata?
      res.status(403).send('Access denied')
    else
      
      shopdata.email = req.body.email
      shopdata.name = req.body.name
      shopdata.loc = req.body.loc
      
      if req.body.password? and req.body.password != ''
        shopdata.password = req.body.password

      shopdata.card = req.body.card

      shopdata.billing_address = req.body.billing_address
      
      shopdata.save()

      res.send JSON.stringify(shopdata)
  )

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
