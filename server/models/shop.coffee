mongoose    = require "mongoose"
Schema      = mongoose.Schema
crypto      = require("crypto")
_           = require("underscore")
Validations = require("./validations")

# Shop Schema

ShopSchema = new Schema
  name    : type: String, default: '', trim: true
  email   : type: String, default: '', trim: true
  password: type: String, default: '', trim: true
  average : type: Number, default: 0, min: 0, max: 10


mongoose.model "Shop", ShopSchema

