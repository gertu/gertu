mongoose = require "mongoose"

exports.validatePresenceOf = (value) ->
  value and value.length


exports.validateLengthOfPassword = (value) ->
  16 >= value.length > 5


exports.isEmail = (value) ->
  (/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/)
  .test value


exports.uniqueFieldInsensitive = (key) ->
  (value, respond) ->
    value   = ""  if "undefined" is value or null is value
    pattern = value.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
    regex   = new RegExp("^" + pattern + "$", "i")
    query   = _id:
      $ne: @_id

    query[key] = regex

    mongoose.models["User"].findOne query, (error, user) ->
      respond not user


exports.uniqueFieldInsensitiveAdministrator = (key) ->
  (value, respond) ->
    value   = ""  if "undefined" is value or null is value
    pattern = value.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
    regex   = new RegExp("^" + pattern + "$", "i")
    query   = _id:
      $ne: @_id

    query[key] = regex

    mongoose.models["Administrator"].findOne query, (error, admin) ->
      respond not admin


exports.dateToString = (date) ->
  date.getFullYear()             + "-" +
  twoDigits(date.getMonth() + 1) + "-" +
  twoDigits(date.getDate())      + "-" +
  twoDigits(date.getHours())     +
  twoDigits(date.getMinutes())   +
  twoDigits(date.getSeconds())

twoDigits = (i) ->
  (if (i < 10) then "0" + i else "" + i)


exports.slugify = (text) ->
  accents =
    a: /\u00e1/g
    e: /u00e9/g
    i: /\u00ed/g
    o: /\u00f3/g
    u: /\u00fa/g
    n: /\u00f1/g

  slug = text.toString().toLowerCase()

  for i of accents
    slug = slug.replace(accents[i], i)

  slug
    .replace(/\s+/g, "-")         # Replace spaces with -
    .replace(/[^\w\-]+/g, "")     # Remove all non-word chars
    .replace(/\-\-+/g, "-")       # Replace multiple - with single -
    .replace(/^-+/, "")           # Trim - from start of text
    .replace /-+$/, ""            # Trim - from end of text