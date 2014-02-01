(->
  Security = { }

  Security.authenticateAdministrator = (req, res, next) ->

    isAuthenticated = req.session.currentAdministrator? && req.session.currentAdministrator.isAuthenticated

    if isAuthenticated
      next()
    else
      res.render "pages/management/access/login", {errorMsg: 'Debe estar logeado para acceder a este área'}

  module.exports = Security
)()
