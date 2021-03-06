mongoose  = require "mongoose"
_         = require('underscore')
Shop      = mongoose.model "Shop"
Deal      = mongoose.model "Deal"
Mailer    = require("../../tools/mailer")

exports.login = (req, res) ->
  res.render "pages/shopmanagement/access/login", {errorMsg: ''}

exports.loginDo = (req, res) ->
  email = req.body.email
  password = req.body.password

  if not email? or not password? or email == '' or password == ''
    res.render "/pages/shopmanagement/access/login",
      {errorMsg: 'Debe indicar tanto el email como la contraseña del usuario'}
  else

    Shop.findOne({email: email}).exec( (err, shop) ->

      if err
        res.status(500).send('Application error')

      else if not shop? or not shop.authenticate(password)
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
  shopId = req.session.currentShop.shopId
  Deal.find({shop: shopId}).populate('shop').exec (err, deals) ->

    comments = []

    for deal in deals
      for comment in deal.comments
        comments.push(comment)

    sortedComments = _.sortBy(comments, (comment) ->
      return comment.writedAt
    )

    res.render "pages/shopmanagement/access/dashboard",
    {
      deals: deals,
      currentShop: currentShop,
      comments: sortedComments
    }

exports.signupDo = (req, res) ->
  shopName = req.body.name
  shopEmail = req.body.email
  shopPassword = req.body.password

  if shopName and shopEmail and shopPassword

    shop = new Shop(req.body)
    shop.confirmed = true

    if req.body.longitude? and req.body.latitude
      shop.loc.longitude = req.body.longitude
      shop.loc.latitude = req.body.latitude

    shop.save( (err) ->

      req.session.currentShop =
        shopId: shop._id,
        shopEmail: shop.email,
        isAuthenticated: true

      res.redirect "/shopmanagement/dashboard"
      )

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

exports.confirmDo = (req, res) ->
  shopId = req.params.shopId

  Shop.findOne({_id: shopId}).exec( (err, shop) ->

    if err
      res.status(500).send('Application error')
    else if not shop?

      res.render "pages/shopmanagement/access/login",
        {errorMsg: 'Los credenciales suministrados no corresponden a un usuario'}

    else if shop.confirmed

      res.redirect "/shopmanagement/dashboard"

    else

      shop.confirmed = true
      shop.save( (err) ->
        req.session.currentShop =
          shopId: shop._id,
          shopEmail: shop.email,
          isAuthenticated: true
        res.redirect "/shopmanagement/dashboard"
        )

    )


exports.resetpassword = (req, res) ->
  res.render "pages/shopmanagement/access/resetpassword"

exports.resetpasswordDo = (req, res) ->
  res.render "pages/shopmanagement/access/resetpasswordsent"

exports.termsandconditions = (req, res) ->
  res.render "pages/shopmanagement/access/termsandconditions"
