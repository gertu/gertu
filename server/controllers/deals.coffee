mongoose        = require "mongoose"
async           = require "async"
_               = require "underscore"
Deal            = mongoose.model('Deal')
Shop            = mongoose.model('Shop')
Reservation     = mongoose.model('Reservation')


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


exports.create = (req, res) ->
  if req.body.name and req.body.price
    deal = new Deal(req.body)
    deal.save (err) ->
      if err
        res.render "error at create deal",
          status: 500
      else
        res.jsonp deal
  else
    res.status(422).send("name and price are required")


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

# reserve a deal
exports.reserve = (req, res) ->
  if req.deal.quantity > 0
    reservation = new Reservation()
    reservation.deal = req.deal._id
    reservation.user = req.user._id
    reservation.save (err) ->
      Deal.collection.update
        _id: req.deal._id
      ,
        $inc:
          quantity:
            -1
      , (err,data) ->
        res.status 200
        res.end()

exports.destroy = (req, res) ->
  deal = req.deal
  deal.remove (err) ->
    if err
      res.render "error",
        status: 500
    else
      res.send JSON.stringify(deal)