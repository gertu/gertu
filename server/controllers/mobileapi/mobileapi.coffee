mongoose = require "mongoose"
User     = mongoose.model "User"
_        = require "underscore"

exports.usersLogin = (req, res) ->
  
  user = new User(req.body)
  user.password = req.body.password

  User.findOne({email: user.email}).exec( (err, userData) ->
    
    if err? or not userData?
      res.status(403).send('Access denied')
    else
      req.session.user =
        id: userData._id,
        name: userData.name,
        email: userData.email,
        isAuthenticated: true

      res.
          status(200).
          send(JSON.stringify(userData))
  )

exports.usersLogout = (req, res) ->
  req.session.user = {}

  res.
    status(200).
    send()
  
exports.usersSignUp = (req, res) ->
  user = new User(req.body)
  user.password = req.body.password

  user.save( (error) ->
    res.
      status(422).
      send()
    )

  res.
    status(200).
    send(JSON.stringify(user))

exports.usersGetCurrent = (req, res) ->
  currentUser = req.session.user

  if currentUser?
    res.
      status(200).
      send(JSON.stringify(currentUser))
  else
    res.
      status(404).
      send()

exports.usersUpdate = (req, res) ->
  user = req.session.user
  user = _.extend(user, req.body)
  user.save (err) ->
    if err?
      res.
      status(500).
      send()
    else
      res.
        status(200).
        send(JSON.stringify(user))

exports.dealsGetAll = (req, res) ->
  res.jsonp user

exports.dealsGetAllByPositition = (req, res) ->
  res.jsonp user

exports.dealsGetById = (req, res) ->
  res.jsonp user

exports.dealsMakeReservationById = (req, res) ->
  res.jsonp user

exports.dealsAddComment = (req, res) ->
  res.jsonp user



