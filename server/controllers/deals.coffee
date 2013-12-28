###
Module dependencies.
###
mongoose = require('mongoose')
async = require("async")
_ = require("underscore")
Deal = mongoose.model('Deal')

# Find deal by id
exports.deal = (req, res, next, id) ->
  Deal.findOne(_id: id).exec (err, deal) ->
    return next(err)  if err
    return next(new Error('Failed to load deal ' + id))  unless deal
    req.deal = deal
    next()


# Create a deal
exports.create = (req, res) ->
  deal = new Deal(req.body)
  deal.save (err) ->
    if err
      res.send 500, 'Something broke!'
    else
      res.jsonp deal


# Show an deal
exports.show = (req, res) ->
  res.jsonp req.deal


###
List of deals
###
exports.all = (req, res) ->
  Deal.find().sort('-created').exec (err, deals) ->
    if err
      res.render 'error',
        status: 500

    else
      res.jsonp deals