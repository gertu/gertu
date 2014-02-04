mongoose    = require "mongoose"
config      = require "../../config/config"
Schema      = mongoose.Schema
Validations = require "./validations"


ShopSchema = new Schema
  _id     : type: String
  name    : type: String, required: true, trim: true
  email   : type: String, required: true, trim: true
  password: type: String, required: true, trim: true

ShopSchema.pre "save", (next) ->
  @_id = Validations.slugify(@name)
  next()

mongoose.model "Shop", ShopSchema

