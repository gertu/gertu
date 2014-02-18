mongoose  = require('mongoose')
_         = require('underscore')
Deal      = mongoose.model('Deal')

exports.list = (req, res) ->

  shopId = req.session.currentShop.shopId

  Deal.find({shop: shopId}).populate('shop').populate('comments').exec( (err, deals) ->

    comments = []

    for deal in deals
      for comment in deal.comments
        comments.push(comment)

    sortedComments = _.sortBy(comments, (comment) ->
      return comment.writedAt
    )

    if not err
      res.render 'pages/shopmanagement/comments/list', {comments: sortedComments, currentShop: req.session.currentShop}
  )