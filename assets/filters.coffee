angular.module("mean.filters", [])
.filter "euro", ->
  (text) ->
    text = text.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1 ")
    t = text + "<span class=\"desc\">,00</span><span class=\"cur\">€</span>"
    t
.filter "iif", ->
  (input, trueValue, falseValue) ->
    (if input then trueValue else falseValue)
.filter "trunc", ->
  (value, wordwise, max, tail) ->
    return ""  unless value
    max = parseInt(max, 10)
    return value  unless max
    return value  if value.length <= max
    value = value.substr(0, max)
    if wordwise
      lastspace = value.lastIndexOf(" ")
      value = value.substr(0, lastspace)  unless lastspace is -1
    value + (tail or " …")



