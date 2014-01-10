mongoose      = require "mongoose"
Administrator = mongoose.model "Administrator"

exports.login = (req, res) ->
  res.render "pages/management/access/login", {errorMsg: ''}

exports.loginDo = (req, res) ->
  email = req.body.email
  password = req.body.password

  if not email? or not password? or email == '' or password == ''
    res.render "pages/management/access/login", {errorMsg: 'Debe indicar tanto el email como la contraseña del usuario'}
  else

    Administrator.findOne({email: email, password: password}).exec( (err, administrator) ->
      if err
        res.status(500).send('Application error')
      else if not administrator?
        res.render "pages/management/access/login", {errorMsg: 'Los credenciales suministrados no corresponden a un usuario'}
      else
        # Access granted
        req.session.currentAdministrator = {adminId: administrator._id, adminEmail: administrator.email, isAuthenticated: true}
        res.redirect "/management/dashboard"
    )

exports.logout = (req, res) ->
  req.session.currentAdministrator = null
  res.render "pages/management/access/login", {endSession: true}
