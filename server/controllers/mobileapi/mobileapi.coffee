mongoose = require "mongoose"
User     = mongoose.model "User"
Deal     = mongoose.model "Deal"
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

    if error
      if error.code is 11000 # email in use (duplicate)
        res.status(409).send(JSON.stringify(error.code))
      else
        res.status(422).send(JSON.stringify(error.code))
    else
      res.status(200).send(JSON.stringify(user))
  )

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

  if user?
    User.findOne({_id: user.id}).exec( (err, userData) ->
      
      if err? or not userData?
        res.status(403).send('Access denied')
      else

        userData = _.extend(userData, req.body)

        user.save (err) ->

          if err?
            res.
            status(500).
            send(JSON.stringify(err))
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
  else
    res.
      status(404).
      send()

exports.dealsGetAll = (req, res) ->
  Deal.find().sort('-created').populate("shop").exec (err, deals) ->
    if err
      res.
        status(500).
        send()
    else
      res.
        status(200).
        send(JSON.stringify(deals))

exports.dealsGetAllByPositition = (req, res) ->
  res.
    status(404).
    send('Not implemented')

exports.dealsGetById = (req, res) ->

  id = req.params.id

  Deal.findOne({_id: id}).exec (err, deal) ->

    if err? or not deal?
      res.
        status(404).
        send()
    else
      res.
        status(200).
        send(JSON.stringify(deal))

exports.dealsMakeReservationById = (req, res) ->
  res.
    status(404).
    send('Not implemented')

exports.dealsAddComment = (req, res) ->
  res.
    status(404).
    send('Not implemented')



