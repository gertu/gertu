mongoose      = require("mongoose")
# passport      = require("passport")
LocalStrategy = require("passport-local").Strategy
User          = mongoose.model("User")
config        = require("./config")

module.exports = (passport) ->
  passport.serializeUser   (user, done) ->
    done null, user.email

  passport.deserializeUser (email, done) ->
    User.findOne
      _email: email
    , (err, user) ->
      done err, user

  passport.use new LocalStrategy((email: "email", password: "password") ->
    User.findOne
      email: email
    , (err, user) ->
      return done(err)  if err
      unless user
        return done(null, false, message: "Unknown user")
      unless user.authenticate(password)
        return done(null, false, message: "Invalid password")
      done null, user
  )