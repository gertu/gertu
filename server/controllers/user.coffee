mongoose = require "mongoose"
User     = mongoose.model "User"
_        = require "underscore"
fs       = require("fs")
Path     = require("path")


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
    
exports.updatePicture = (req, res) ->
  file = req.files.picture
  name = file.name
  type = file.type
  path = __dirname + "/public/img/userphotos/" + name
  user = req.user

  format = type.split("/")
  if format[1] is "jpg" or format[1] is "jpeg" or format[1] is "png" or format[1] is "gif"
    fs.rename req.files.picture.path, path, (err) ->
      res.send "Ocurrio un error al intentar subir la imagen"  if err
      res.redirect "/profile"
      User.findOne(_id: user._id).exec (err, userfound) ->
        fs.unlink Path.resolve(".")+ "/public/img"  + userfound.picture
        splittednewname = (file.path).split("\\")
        userfound.picture = "/img/userphotos/" + splittednewname[splittednewname.length-1]
        userfound.save()

  else
    fs.unlink file.path
    res.send "El formato debe ser jpg, png o gif"
