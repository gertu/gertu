mongoose  = require 'mongoose'
User      = mongoose.model 'User'

exports.list = (req, res) ->
  User.find({}).sort('name').exec( (err, users) ->
    if err
      res.status(500).send('Database error')
    else
      res.render 'pages/management/users/list', {users: users}
  )

exports.view = (req, res) ->

  userId = req.params.id

  User.findOne({_id: userId}).exec( (err, user) ->
    if err?
      res.status(500).send('Database error')
    else if not user?
      res.status(404).send('No user found')
    else
      res.render 'pages/management/users/view', {user: user}
  )