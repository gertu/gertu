mongoose    = require "mongoose"
Reservation = mongoose.model "Reservation"
Deal        = mongoose.model "Deal"
_           = require "underscore"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  Reservation.find({}).populate('deal').populate('deal.shop').exec( (err, reservations) ->

    shopReservations = []

    for reservation in reservations

      if (reservation.deal.shop + '') == (shopId + '')

        shopReservations.push reservation

    res.render 'pages/shopmanagement/reservations/list', {reservations: shopReservations, currentShop: req.session.currentShop}
  )

exports.confirm = (req, res) ->

  error = null

  if req.query.errorProc == 'true'
    error = 'error'

  res.render 'pages/shopmanagement/reservations/confirm', {currentShop: req.session.currentShop, error: error}

exports.confirmDo = (req, res) ->

  shopId = req.session.currentShop.shopId
  reservationId = req.body.reservationId

  Reservation.findOne({_id: req.body.reservationId}).populate('deal').exec( (err, reservation) ->

    if not err? and reservation? and reservation.deal? and (reservation.deal.shop + '') == (shopId + '')

      reservation.redeemed = true
      reservation.date = new Date()
      reservation.save( (err)->

        if not err?
          isError = false
          res.render 'pages/shopmanagement/reservations/confirm-success', {currentShop: req.session.currentShop}
        else
          res.redirect '/shopmanagement/reservations/confirm/?errorProc=true'
      )
    else

      res.redirect '/shopmanagement/reservations/confirm/?errorProc=true'
  )
