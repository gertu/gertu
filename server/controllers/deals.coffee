mongoose = require "mongoose"
async    = require "async"
_        = require "underscore"
Deal     = mongoose.model "Deal"
Shop     = mongoose.model "Shop"
User     = mongoose.model "User"

exports.deal = (req, res, next, id) ->
  Deal.findOne(_id: id).exec (err, deal) ->
    return next(err)  if err
    return next(new Error('Failed to load deal ' + id))  unless deal
    req.deal = deal
    next()

exports.shop = (req, res, next, id) ->
  Shop.findOne(_id: id).exec (err, shop) ->
    return next(err)  if err
    return next(new Error('Failed to load shop ' + id))  unless shop
    req.shop = shop
    next()

exports.user = (req, res, next, id) ->
  User.findOne(_id: id).exec (err, shop) ->
    return next(err)  if err
    return next(new Error('Failed to load user ' + id))  unless user
    req.user = user
    next()

exports.create = (req, res) ->
  if req.body.name and req.body.price and req.body.gertuprice and req.body.discount and req.body.shop
    Shop.findOne(_id: req.body.shop).exec (err, shop) ->
      if shop
        deal = new Deal(req.body)
        deal.save (err) ->
          if err
            res.render "error at create deal", status: 500
          else
            res.jsonp deal
      else
        res.status(404).send("the shop does not exist")
  else
    res.status(422).send("name, price, gertuprice and discount are required")

exports.show = (req, res) ->
  res.jsonp req.deal

exports.findByShop = (req, res) ->
  Deal.find(shop: req.shop._id).populate('shop'). exec (err,deals) ->
    if err
      res.render 'error',
        status: 500
    else
      res.jsonp deals

exports.all = (req, res) ->
  Deal.find().sort('-created').populate("shop").exec (err, deals) ->
    if err
      res.render 'error',
        status: 500
    else
      res.jsonp deals

exports.update = (req, res) ->
  deal = req.deal
  deal = _.extend(deal, req.body)
  deal.save (err) ->
    if err
      res.send "/deals/"
      errors: err.errors
      deal: deal
    else
      res.jsonp deal

exports.destroy = (req, res) ->
  deal = req.deal
  deal.remove (err) ->
    if err
      res.render "error",
        status: 500
    else
      res.send JSON.stringify(deal)

# functions about Comments
exports.addComment = (req, res) ->
  if req.body.author and req.body.description and req.body.rating
    User.findOne(_id: req.body.author).exec (err, user) ->
      if user
        Deal.findOne("comments.author": req.body.author).exec (err, user) ->
          if !user
            comments = req.deal.comments

            _sumOfRatings = req.deal.average * (req.deal.comments.length)
            average       = (_sumOfRatings + req.body.rating) / (req.deal.comments.length + 1)

            req.deal.comments = _.union(comments, req.body)
            req.deal          = _.extend(req.deal, "average": average)
            req.deal.save (err) ->
              if err
                res.status(500).send("error at add a comment")
              else
                res.jsonp req.deal
          else
            res.status(500).send("this user has written a comment in this deal")
      else
        res.status(404).send("the user does not exist")
  else
    res.status(422).send("author, description and rating are required")