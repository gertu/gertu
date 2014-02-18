mongoose  = require "mongoose"
Reservation = mongoose.model "Reservation"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  Reservation.find({deal : {shop: shopId } }).exec( (err, reservations) ->

    reservations = reservations || []
    
    res.render 'pages/shopmanagement/reservations/list', {reservations: reservations, currentShop: req.session.currentShop}
  )

exports.confirm = (req, res) ->
  res.render 'pages/shopmanagement/reservations/confirm', {currentShop: req.session.currentShop}

exports.confirmDo = (req, res) ->

  shopId = req.session.currentShop.shopId
  reservationId = req.body.reservationId
  isError = true

  Reservation.findOne({_id: reservationId, deal : { shop: shopId } }).exec( (err, reservation) ->

    reservation.redeemed = true
    reservation.date = new Date()
    reservation.save( (err)->
      if not err
        isError = false
        res.render 'pages/shopmanagement/reservations/confirm-success', {currentShop: req.session.currentShop}
    )

    if isError
      res.redirect '/shopmanagement/reservations?errorProc=true', {reservations: reservations, currentShop: req.session.currentShop}
  )
