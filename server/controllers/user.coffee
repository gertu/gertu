mongoose = require "mongoose"
User     = mongoose.model "User"

exports.authCallback = (req, res, next) ->
  res.redirect "/"

exports.signin       = (req, res) ->
  res.render "/",
    title  : "Signin"
    message: req.flash "error"

exports.signup       = (req, res) ->
  res.render "/",
    title: "Signup"
    user : new User()

exports.signout      = (req, res) ->
  req.logout()
  res.redirect "/"

exports.session      = (req, res) ->
  res.redirect "/"

exports.create       = (req, res) ->
  user = new User(req.body)
  user.provider = "local"
  user.save (err) ->
    if err
      return res.render("/",
        errors: err.errors
        user: user
      )
    req.logIn user, (err) ->
      return next(err)  if err
      res.redirect "/"