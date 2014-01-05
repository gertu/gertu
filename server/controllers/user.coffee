mongoose = require "mongoose"
User     = mongoose.model "User"
_        = require "underscore"


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
      return next(err) if err
      res.redirect "/"

exports.update       = (req, res) ->
  user = req.user
  user = _.extend(user, req.body)
  user.save (err) ->
    res.jsonp user

exports.show         = (req, res) ->
  user = req.profile
  res.render "/",
    title: user.name
    user : user

exports.me           = (req, res) ->
  res.jsonp req.user or null

exports.user         = (req, res, next, id) ->
  User.findOne(_id: id).exec (err, user) ->
    return next(err) if err
    return next(new Error("Failed to load User " + id)) unless user
    req.profile = user
    next()
