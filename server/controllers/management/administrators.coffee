mongoose     = require 'mongoose'
Administrator = mongoose.model 'Administrator'

exports.list = (req, res) ->
  Administrator.find({}).exec( (err, administrators) ->
    if err
      res.status(500).send('Database error')
    else
      res.render 'pages/management/administrators/list', {administrators: administrators}
  )

exports.add = (req, res) ->
  administrator =
    _id: 0,
    name: '',
    email: '',
    password: '',
    passwordRpt: ''

  res.render 'pages/management/administrators/edit', {administrator: administrator}

exports.edit = (req, res) ->

  id = req.params.id

  Administrator.findOne({_id: id}).exec( (err, administrator) ->
    if err
      res.status(404)
    else
      res.render 'pages/management/administrators/edit', {administrator: administrator}
  )

exports.editDo = (req, res) ->

  id = req.params.id
  name = req.body.name
  email = req.body.email
  password = req.body.password
  passwordRpt = req.body.passwordRpt

  if id == '0'
    administrator = new Administrator({name: name, email: email, password: password})
    administrator.save((error) ->
      console.log error
      if error?
        res.render 'pages/management/administrators/edit', {administrator: administrator, errors: error.errors}
      else
        res.redirect '/management/administrators/list?rnd=' + Math.random()
    )
  else
    Administrator.findOne({_id: id}).exec( (err, administrator) ->
      if err? or not administrator?
        res.status(404)
      else
        administrator.name = name
        administrator.email = email
        administrator.password = password

        administrator.save((error) ->

          console.log error

          if error?
            res.render 'pages/management/administrators/edit/' + administrator._id ,
              {administrator: administrator, errorMsg: error.errors}
          else
            res.redirect '/management/administrators/list?rnd=' + Math.random()
        )
    )

exports.remove = (req, res) ->

  id = req.params.id

  Administrator.findOne({_id: id}).exec( (err, administrator) ->
    if err
      res.status(404)
    else
      res.render 'pages/management/administrators/remove', {administrator: administrator}
  )

exports.removeDo = (req, res) ->

  id = req.params.id

  Administrator.findOne({_id: id}).exec( (err, administrator) ->
    if err
      res.status(404)
    else
      administrator.remove(()->
        res.redirect '/management/administrators/list?rnd=' + Math.random()
      )

  )