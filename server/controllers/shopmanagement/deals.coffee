mongoose  = require "mongoose"
Shop      = mongoose.model "Shop"
Deal      = mongoose.model "Deal"
DealCategory = mongoose.model "DealCategory"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  Deal.find({shop: shopId}).populate('shop').exec (err, deals) ->
    res.render 'pages/shopmanagement/deals/list', {deals: deals, currentShop: req.session.currentShop}
 
exports.view = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
 
  Deal.find({shop: shopId, _id: dealId}).populate('shop').exec (err, deals) ->
    res.render '/pages/shopmanagement/deals/list', {deals: deals}

exports.create = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
  
  DealCategory.find().sort('name').exec( (err, categories ) ->
    res.render 'pages/shopmanagement/deals/create',
      {
        categories: categories,
        days: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
        currentShop: req.session.currentShop
      }
  )

exports.createDo = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
  
  Shop.findOne({_id: shopId}).exec( (err, shop) ->

    if shop
      deal = new Deal
        name : req.body.name
        description: req.body.description
        categoryname: req.body.categoryname
        price: req.body.price
        gertuprice: req.body.gertuprice
        discount: req.body.discount
        datainit: req.body.datainit
        dataend: req.body.dataend
        selecteddays: req.body.selecteddays
        quantity: req.body.quantity

      deal.save (err) ->
        if not err
          res.redirect 'shopmanagement/deals/list'
  )
 