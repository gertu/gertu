mongoose = require("mongoose")

exports.validatePresenceOf       = (value) ->
  value and value.length

exports.validateLengthOfPassword = (value) ->
  16 >= value.length > 5

exports.isEmail                  = (value) ->
  (/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)
  .test value

exports.uniqueFieldInsensitive   = (key, modelName = 'User') ->
  (value, respond) ->
    value   = ""  if "undefined" is value or null is value
    pattern = value.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
    regex   = new RegExp("^" + pattern + "$", "i")
    query   = _id:
      $ne: @_id

    query[key] = regex

    if modelName == 'User'
      mongoose.models["User"].findOne query, (error, user) ->
        respond not user
    else
      mongoose.models["Shop"].findOne query, (error, user) ->
        respond not shop

