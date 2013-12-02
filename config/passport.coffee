mongoose      = require("mongoose")
LocalStrategy = require("passport-local").Strategy
User          = mongoose.model("User")
config        = require("./config")

module.exports = (passport) ->
  passport.serializeUser   (user, done) ->
    done null, user.email

  passport.deserializeUser (email, done) ->
    User.findOne
      _email: email, (error, user) ->
        done error, user

  passport.use new LocalStrategy(
    usernameField: "email"
    passwordField: "password"
  , (email, password, done) ->
    User.findOne
      email: email, (error, user) ->
        return done(error)  if error
        unless user
          return done(null, false, message: "Unknown user")
        unless user.authenticate(password)
          return done(null, false, message: "Invalid password")
        done null, user
  )