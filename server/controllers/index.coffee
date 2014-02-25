mongoose = require "mongoose"
async    = require "async"
_        = require "underscore"

User = mongoose.model "User"
Deal = mongoose.model 'Deal'
Shop = mongoose.model 'Shop'
Reservation = mongoose.model 'Reservation'

exports.render = (req, res) ->
  res.render "index",
    user: if req.user then JSON.stringify(req.user) else "null"

exports.load = (req, res) ->
  dealc = 0
  userc = 0
  shopc = 0
  reservc = 0
  nearbyDeals = []

  async.parallel
    deals: (callback) ->
      Deal.count {}
      , (err, deals) ->
        callback null, deals
    users: (callback) ->
      User.count {}
      , (err, users) ->
        callback null, users
    shops: (callback) ->
      Shop.count {}
      , (err, shops) ->
        callback null, shops
    reservations: (callback) ->
      Reservation.count {}
      , (err, reservations) ->
        callback null, reservations
  , (e, r) ->
    dealc = r.deals
    userc = r.users
    shopc = r.shops
    reservc = r.reservations

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
        Deal.find({shop: { $in:nearshopids}}).exec (err,deals) ->
          for deal in deals
            for shop in nearshops
              if deal.shop.equals(shop.obj._id)
                nearbyDeals.push
                  dist: shop.dis
                  deal: deal
          nearbyDeals.sort (a, b) ->
            a.dist - b.dist

          res.jsonp  [dealcount: dealc, reservationcount: reservc, usercount: userc, shopcount: shopc,neardeals: nearbyDeals]