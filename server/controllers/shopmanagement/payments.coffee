mongoose  = require "mongoose"
Payment = mongoose.model "Payment"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  Payment.find({shop: shopId }).exec( (err, payments) ->

    payments = payments || []
    
    res.render 'pages/shopmanagement/payments/list', {payments: payments, currentShop: req.session.currentShop}
  )