mongoose  = require "mongoose"
async     = require "async"
_         = require "underscore"
Utilities = require "../tools/utilities"

Deal     = mongoose.model "Deal"
Shop     = mongoose.model "Shop"
User     = mongoose.model "User"


exports.deal = (req, res, next, id) ->
  Deal.findOne(_id: id).populate("comments.author").populate("shop").exec (err, deal) ->
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
hasWritten = (req, user) ->
  i = 0
  while i < req.deal.comments.length
    return true  if req.deal.comments[i].author._id.equals user._id
    i++
  return false

exports.addComment = (req, res) ->
  description = req.body.description
  rating = req.body.rating
  currentUser = req.user
  if currentUser?
    if description? and rating?
      User.findOne(_id: currentUser._id).exec (err, user) ->
        if user
          if !hasWritten(req, currentUser)
            comment =
              author     : user._id
              description: description
              rating     : Number(rating)

            sumOfRatings = req.deal.average * (req.deal.comments.length)
            average      = (sumOfRatings + comment.rating) / (req.deal.comments.length + 1)

            shopAverage  = req.deal.shop.average + Utilities.shopRating(comment.rating)

            req.deal.comments.push comment

            req.deal      = _.extend(req.deal, "average": average)
            req.deal.shop = _.extend(req.deal.shop, "average": shopAverage)

            req.deal.save and req.deal.shop.save (err) ->
              if err
                res.status(500).send(err)
              else
                res.jsonp req.deal
          else
            res.status(409).send("user has already post a comment in this deal")
        else
          res.status(404).send("the user does not exist")
    else
      res.status(422).send("description and rating are required")
  else
    res.status(401).send("login is required for this action")