mongoose    = require "mongoose"
Schema      = mongoose.Schema
crypto      = require "crypto"
_           = require "underscore"
Validations = require "./validations"


ShopSchema = new Schema
  name     : type: String, default: "", trim: true
  email    : type: String, default: "", trim: true
  average  : type: Number, default: 0, min: 0, max: 10
  confirmed: type: Boolean, default: false

  hashed_password: type: String, default: "", trim: true
  salt           : type: String

  loc:
    latitude : type: Number, default: 0.0
    longitude: type: Number, default: 0.0

  card:
    type        : type: String, default: ""
    number      : type: Number, default: 0
    expire_month: type: Number, default: 0
    expire_year : type: Number, default: 0
    cvv2        : type: Number, default: 0
    first_name  : type: String, default: ""
    last_name   : type: String, default: ""

  billing_address:
    line1       : type: String, default: ""
    city        : type: String, default: ""
    state       : type: String, default: ""
    postal_code : type: String, default: ""
    country_code: type: String, default: ""

ShopSchema.virtual("password").set((password) ->
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
    if not @salt or not @hashed_password # Old shops with no hashing
      return false
    return @encryptPassword(plainText) is @hashed_password

  makeSalt: ->
    Math.round((new Date().valueOf() * Math.random())) + ""

  encryptPassword: (password) ->
    return ""  unless password
    crypto.createHmac("sha1", @salt).update(password).digest "hex"

  hasCreditCardInfo: ->
    @card? and @card.type? and @card.number? and @card.expire_month? and @card.expire_year? and @card.cvv2? and @card.first_name? and @card.type?

ShopSchema.index {loc: "2d"}

mongoose.model "Shop", ShopSchema

