mongoose  = require "mongoose"
async     = require "async"
_         = require "underscore"
Utilities = require "../tools/utilities"
Path      = require "path"
fs        = require "fs"

Deal        = mongoose.model "Deal"
Shop        = mongoose.model "Shop"
User        = mongoose.model "User"
Reservation = mongoose.model "Reservation"


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

exports.updatephoto = (req, res) ->
  file = req.files.image
  name = file.name
  type = file.type
  path = __dirname + "/public/upload/" + name
  deal = req.body.deal
  shop = req.session.currentShop.shopId

  format = type.split("/")
  if format[1] is "jpg" or format[1] is "jpeg" or format[1] is "png" or format[1] is "gif"
    fs.rename req.files.image.path, path, (err) ->
      res.send "Ocurrio un error al intentar subir la imagen"  if err
      res.redirect "/admin/deals/list/" + shop
      Deal.findOne(_id: deal).exec (err, dealfound) ->
        fs.unlink Path.resolve(".") + dealfound.image
        splittednewname = (file.path).split("/")
        dealfound.image = "/upload/" + splittednewname[splittednewname.length-1]
        dealfound.save()

  else
    fs.unlink file.path
    res.render "pages/shop/createphoto",
      {errorMsg: 'El formato debe ser jpg, png o gif'}

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

exports.getNearestDeals = (req,res) ->
  nearbyDeals = []

  userradius = (if req.user then req.user.radius else 1000)/1000

  mongoose.connection.db.executeDbCommand
    geoNear: "shops" # the mongo collection
    near: [parseFloat(req.query.userLong), parseFloat(req.query.userLat)] # the geo point
    spherical: true # tell mongo the earth is round, so it calculates based on a
    # spherical location system
    distanceMultiplier: 6371 # tell mongo how many radians go into one kilometer.
    maxDistance: userradius / 6371 # tell mongo the max distance in radians to filter out
  , (err, result) ->
    nearshops = result.documents[0].results
    nearshopids = []
    if nearshops?
      for shop in nearshops
        nearshopids.push shop.obj._id
      Deal.find({shop: { $in:nearshopids}}).populate("shop").exec (err,deals) ->
        for deal in deals
          for shop in nearshops
            if deal.shop._id.equals(shop.obj._id)
              nearbyDeals.push
                dist: shop.dis
                deal: deal
        nearbyDeals.sort (a, b) ->
          a.dist - b.dist

        res.jsonp  nearbyDeals


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
    if description? and rating > 0
      User.findOne(_id: currentUser._id).exec (err, user) ->
        if user
          if !hasWritten(req, currentUser)
            comment =
              author     : user._id
              description: description
              rating     : Number(rating)

            sumOfRatings = req.deal.average * (req.deal.comments.length)
            average      = (sumOfRatings + comment.rating) / (req.deal.comments.length + 1)

            shopAverage = req.deal.shop.average + Utilities.shopRating(comment.rating)
            shopAverage = 0  if shopAverage < 0

            req.deal.comments.push comment

            req.deal      = _.extend(req.deal, "average": average)
            req.deal.shop = _.extend(req.deal.shop, "average": shopAverage)

            req.deal.save (err) -> req.deal.shop.save (err) ->
              if err
                res.send(500, err)
              else
                res.jsonp req.deal
          else
            res.send(409, "user has already posted a comment in this deal")
        else
          res.send(404, "the user does not exist")
    else
      res.send(422, "description and rating are required")
  else
    res.send(401, "login is required for this action")

exports.myComments = (req, res) ->
  currentUser = req.user
  myComments = []

  if currentUser?
    Deal.find().exec (err, deals) ->
      if err
        res.send(500, err)
      else
        for deal in deals
          if deal? and deal.comments?
            for comment in deal.comments
              if comment?
                myComments.push comment  if comment.author.equals currentUser._id
        res.jsonp myComments