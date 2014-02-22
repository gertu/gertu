mongoose = require "mongoose"
Token     = mongoose.model "Token"

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

  Security.authenticateMobile = (req, res, next) ->
    # Take the token passed in request
    tokenId = req.body.token

    if not tokenId?
      tokenId = req.query.token

    # Verify it is in the list of tokens, and it is still valid
    Token.findOne({ token: tokenId }).populate('user').exec( (err, token) ->

      referenceDate = new Date(new Date() - (20 * 60000))

      if token? and token.last_access > referenceDate

        token.refresh()
        req.currentMobileUser = token.user
        next()

      else

        Token.remove({ token: tokenId}).exec( (err) ->
          res.status(403).send('Access denied')
        )
      )

  module.exports = Security
)()
