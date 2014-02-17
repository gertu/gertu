mongoose  = require "mongoose"
Shop      = mongoose.model "Shop"
Mailer    = require("../../tools/mailer")

exports.login = (req, res) ->
  res.render "pages/shopmanagement/access/login", {errorMsg: ''}

exports.loginDo = (req, res) ->
  email = req.body.email
  password = req.body.password

  if not email? or not password? or email == '' or password == ''
    res.render "/shopmanagement/access/login",
      {errorMsg: 'Debe indicar tanto el email como la contraseña del usuario'}
  else

    Shop.findOne({email: email, password: password}).exec( (err, shop) ->
      if err
        res.status(500).send('Application error')
      else if not shop?
        res.render "pages/shopmanagement/access/login",
          {errorMsg: 'Los credenciales suministrados no corresponden a un usuario'}
      else if not shop.confirmed
        res.redirect "/shopmanagement/confirm/" + shop._id,
      else
        # Access granted
        req.session.currentShop =
          shopId: shop._id,
          shopEmail: shop.email,
          isAuthenticated: true
          
        res.redirect "/shopmanagement/dashboard"
    )

exports.logout = (req, res) ->
  req.session.currentShop = null
  res.redirect "/shopmanagement/login"

exports.dashboard = (req, res) ->
  currentShop = req.session.currentShop
  res.render "pages/shopmanagement/access/dashboard", {currentShop: currentShop}

exports.signupDo = (req, res) ->
  console.log req.body
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

    res.redirect "/shopmanagement/confirm/" + shop._id
  else
    res.redirect "/shopmanagement/login"
  

exports.confirm = (req, res) ->
  shopId = req.params.shopId

  Shop.findOne({_id: shopId}).exec( (err, shop) ->

    if err
      res.status(500).send('Application error')
    else if not shop?
      res.render "pages/shopmanagement/access/login",
        {errorMsg: 'Los credenciales suministrados no corresponden a un usuario'}
    else if shop.confirmed
      req.session.currentShop =
          shopId: shop._id,
          shopEmail: shop.email,
          isAuthenticated: true

      res.redirect "/shopmanagement/dashboard",
    else
      res.render "pages/shopmanagement/access/confirm", {currentShop: shop}
    )
  