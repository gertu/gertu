mongoose  = require('mongoose')
_         = require('underscore')
Deal      = mongoose.model('Deal')

exports.list = (req, res) ->

  shopId = req.session.currentShop.shopId
  
  Deal.find({shop: shopId}).populate('shop').exec( (err, deals) ->

    findDeals = []
    
    for deal in deals
      if (deal.comments.length > 0)
        findDeals.push(deal)
        
    sortedDeals = _.sortBy(findDeals, (deal) ->
      return deal.writedAt
    )
    

    if not err
      res.render 'pages/shopmanagement/comments/list', {deals: sortedDeals, currentShop: req.session.currentShop}
  )