(->
  Security = { }

  Security.authenticateAdministrator = (req, res, next) ->

    isAuthenticated = req.session.currentAdministrator? && req.session.currentAdministrator.isAuthenticated

    if isAuthenticated
      next()
    else
      res.render "pages/management/access/login", {errorMsg: 'Debe estar logeado para acceder a este área'}

  Security.authenticateShop = (req, res, next) ->

    isAuthenticated = req.session.currentShop? && req.session.currentShop.isAuthenticated

    if isAuthenticated
      next()
    else
      res.render "pages/shopmanagement/access/login", {errorMsg: 'Debe estar logeado para acceder a este área'}

  module.exports = Security
)()
