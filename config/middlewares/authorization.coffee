exports.requiresLogin = (req, res, next) ->
  return res.send(401, "User is not authorized")  unless req.isAuthenticated()
  next()

exports.user = hasAuthorization: (req, res, next) ->
  return res.send(401, "User is not authorized")  unless req.profile.id is req.user.id
  next()