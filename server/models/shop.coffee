mongoose    = require "mongoose"
Schema      = mongoose.Schema
crypto      = require("crypto")
_           = require("underscore")
Validations = require("./validations")

# Shop Schema

ShopSchema = new Schema
  name:
    type: String, default: '', trim: true
  email:
    type: String, default: '', trim: true
  password:
    type: String, default: '', trim: true

###
ShopSchema.virtual("password")
.set((password) ->
  @_password = password
  @salt = @makeSalt()
  @hashed_password = @encryptPassword(password)
).get ->
  @_password

ShopSchema.pre "save", (next) ->
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


ShopSchema.methods =
  authenticate: (plainText) ->
    @encryptPassword(plainText) is @hashed_password

  makeSalt: ->
    Math.round((new Date().valueOf() * Math.random())) + ""

  encryptPassword: (password) ->
    return ""  unless password
    crypto.createHmac("sha1", @salt).update(password).digest "hex"
###
mongoose.model "Shop", ShopSchema

