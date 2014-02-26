mongoose  = require "mongoose"
async     = require "async"
_         = require "underscore"
Utilities = require "../tools/utilities"


Reservation = mongoose.model "Reservation"
Deal        = mongoose.model "Deal"


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
        res.jsonp reservation

exports.myReserves = (req, res) ->
  currentUser = req.user
  Reservation.find()
    .where(user: currentUser._id).where(redeemed: false)
    .populate("user").populate("deal")
    .exec (err, myReserves) ->
      if err
        res.send(500, err)
      else
        res.jsonp myReserves



exports.myBuys = (req, res) ->
  currentUser = req.user
  Reservation.find()
    .where(user: currentUser._id).where(redeemed: true)
    .populate("user").populate("deal")
    .exec (err, myBuys) ->
      if err
        res.send(500, err)
      else
        res.jsonp myBuys