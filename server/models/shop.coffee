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
  confirmed :
    type: Boolean, default: false
  loc:
    latitude:
      type: Number, default: 0.0
    longitude:
      type: Number, default: 0.0
  card:
    type:
      type: String, default: ''
    number:
      type: Number, default: 0
    expire_month:
      type: Number, default: 0
    expire_year:
      type: Number, default: 0
    cvv2:
      type: Number, default: 0
    first_name:
      type: String, default: ''
    last_name:
      type: String, default: ''
  billing_address:
    line1:
      type: String, default: ''
    city:
      type: String, default: ''
    state:
      type: String, default: ''
    postal_code:
      type: String, default: ''
    country_code:
      type: String, default: ''


ShopSchema.index {loc: "2d"}

mongoose.model "Shop", ShopSchema

