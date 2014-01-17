mongoose = require "mongoose"
async    = require "async"
_        = require "underscore"
DealCategory  = mongoose.model('DealCategory')

exports.all = (req, res) ->
  DealCategory.find().sort('-created').exec (err, categories) ->
    if err
      res.render 'error',
        status: 500
    else
      res.jsonp categories