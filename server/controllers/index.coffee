###
Module dependencies.
###
mongoose = require("mongoose")
async = require("async")
_ = require("underscore")

Deal = mongoose.model('Deal')
User = mongoose.model('User')

exports.render = (req, res) ->
  dealCount = 0
  Deal.count({}, (err, dealcount) ->
    User.count({}, (err, usercount) ->
      res.render "index",
        user: if req.user then JSON.stringify(req.user) else "null"
        dealcount: dealcount
        usercount: usercount
    )
  )