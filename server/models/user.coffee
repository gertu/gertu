mongoose    = require("mongoose")
Schema      = mongoose.Schema
crypto      = require("crypto")
_           = require("underscore")
Validations = require("./validations")


UserSchema = new Schema(
  email     : type: String, required: true, unique: true, lowercase: true
  firstName : String
  lastName  : String
  picture   : type: String, default: "http://static.freepik.com/free-photo/male-user-icon-clip-art_419253.jpg"
  radius    : type: Number, default: 1000
  confirmed : type: Boolean, default: false

  hashed_password : String
  salt            : String
)


UserSchema.virtual("password").set((password) ->
  @_password = password
  @salt = @makeSalt()
  @hashed_password = @encryptPassword(password)
).get ->
  @_password


UserSchema.pre "save", (next) ->
  return next() unless @isNew
  if not Validations.validatePresenceOf(@password)
    next new Error("Password cannot be blank")
  else if not Validations.validateLengthOfPassword(@password)
    next new Error("Password must be at least 6 and not longer than 16 characters")
  else if not Validations.uniqueFieldInsensitive(@email)
    next new Error("This email is already in use")
  else if not Validations.isEmail(@email)
    next new Error("This is not a valid email")
  else
    next()


UserSchema.methods =
  authenticate: (plainText) ->
    @encryptPassword(plainText) is @hashed_password

  makeSalt: ->
    Math.round((new Date().valueOf() * Math.random())) + ""

  encryptPassword: (password) ->
    return ""  unless password
    crypto.createHmac("sha1", @salt).update(password).digest "hex"

mongoose.model "User", UserSchema