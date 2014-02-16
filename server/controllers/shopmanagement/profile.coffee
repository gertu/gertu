mongoose  = require "mongoose"
Shop      = mongoose.model "Shop"
_         = require "underscore"

exports.view = (req, res) ->

  shopId = req.session.currentShop.shopId

  Shop.findOne({_id: shopId}).exec( (err, shop) ->
    if err
      res.redirect "/shopmanagement/login"
    else if not shop?
      res.redirect "/shopmanagement/login"
    else
      if not shop.loc?
        shop.loc =
          longitude: 0
          latitude: 0

      if not shop.card?
        shop.card =
          number : ''
          expire_month: ''
          expire_year: ''
          cvv2: ''
          first_name: ''
          last_name: ''

      if not shop.billing_address?
        shop.billing_address =
          line1 : ''
          city: ''
          state: ''
          postal_code: ''
          country_code: ''

      res.render "pages/shopmanagement/profile/view", {shop: shop}
  )

exports.viewDo = (req, res) ->
  shopId = req.session.currentShop.shopId

  Shop.findOne({_id: shopId}).exec( (err, shop) ->
    if err
      res.redirect "/shopmanagement/login"
    else if not shop?
      res.redirect "/shopmanagement/login"
    else
      shop.name = req.body.shop_name
      shop.name = req.body.shop_email
      shop.loc =
        longitude: req.body.shop_loc_longitude
        latitude : req.body.shop_loc_latitude
      shop.card =
        type: req.body.shop_card_type
        number: req.body.shop_card_number
        expire_month: req.body.shop_card_expire_month
        expire_year: req.body.shop_card_expire_year
        cvv2: req.body.shop_card_cvv2
        first_name: req.body.shop_card_first_name
        last_name: req.body.shop_card_last_name
      
      shop.billing_address =
        line1: req.body.shop_billing_address_line1
        city: req.body.shop_billing_address_city
        state: req.body.shop_billing_address_state
        postal_code: req.body.shop_billing_address_postal_code
        country_code: req.body.shop_billing_address_country_code
        
      shop.save( () ->
        res.render "pages/shopmanagement/profile/view", {shop: shop, saved: true}
      )
  )