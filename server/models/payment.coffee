mongoose    = require "mongoose"
Schema      = mongoose.Schema
_           = require("underscore")
Validations = require("./validations")

# Shop Schema

PaymentSchema = new Schema
  shop:
    type: Schema.Types.ObjectId
    ref:      "Shop"
    index:    true
    required: true
  date:
    type: Date, default: Date.now
  amount:
    type: Number, default: 0
  finished:
    type: Boolean, default: false
  successful:
    type: Boolean, default: false
  error:
    type: String, default: ''

mongoose.model "Payment", PaymentSchema