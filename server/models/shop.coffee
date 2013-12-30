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

mongoose.model "Shop", ShopSchema

