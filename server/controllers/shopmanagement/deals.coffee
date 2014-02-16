mongoose  = require "mongoose"
Shop      = mongoose.model "Shop"
Deal      = mongoose.model "Deal"
DealCategory = mongoose.model "DealCategory"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  Deal.find({shop: shopId}).populate('shop').exec (err, deals) ->
    res.render 'pages/shopmanagement/deals/list', {deals: deals}
 
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
        days: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
      }
  )

exports.createDo = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
 
  @