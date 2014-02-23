mongoose  = require 'mongoose'
Shop      = mongoose.model 'Shop'

exports.list = (req, res) ->
  Shop.find({}).sort('name').exec( (err, shops) ->
    if err
      res.status(500).send('Database error')
    else
      res.render 'pages/management/shops/list', {shops: shops}
  )

exports.view = (req, res) ->

  shopId = req.params.id

  Shop.findOne({_id: shopId}).exec( (err, shop) ->
    if err?
      res.status(500).send('Database error')
    else if not shop?
      res.status(404).send('No shop found')
    else
      res.render 'pages/management/shops/view', {shop: shop}
  )