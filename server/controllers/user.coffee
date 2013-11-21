mongoose = require("mongoose")
User     = mongoose.model("User")

exports.authCallback = (req, res, next) ->
  res.redirect "/"

exports.signin       = (req, res) ->
  res.render "users/signin",
    title  : "Signin"
    message: req.flash("error")

exports.session      = (req, res) ->
  res.redirect "/"

exports.show         = (req, res) ->
  user = req.profile

  res.render "users/show",
    email: user.email
    user : user

exports.me           = (req, res) ->
  res.jsonp(req.user or null)