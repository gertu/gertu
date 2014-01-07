mongoose      = require "mongoose"
Administrator = mongoose.model "Administrator"

exports.login = (req, res) ->
  res.render "pages/management/access/login", {errorMsg: ''}

exports.loginDo = (req, res) ->
  email = req.body.email
  password = req.body.password

  if not email? or not password?
    res.render "pages/management/access/login", {errorMsg: 'Both email and password should be provided'}
  else

    Administrator.findOne({email: email, password: password}).exec( (err, administrator) ->
      if err
        res.status(500).send('Application error')
      else if not administrator?
        res.render "pages/management/access/login", {errorMsg: 'User does not exist'}
      else
        # Access granted
        req.session.currentAdministrator = {adminId: administrator._id, adminEmail: administrator.email, isAuthenticated: true}
        res.redirect "/management/dashboard"
    )