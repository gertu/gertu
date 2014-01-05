mongoose    = require "mongoose"
Schema      = mongoose.Schema

# Application currencies Schema

CurrencySchema = new Schema
  name:
    type: String, default: '', trim: true
  code:
    type: String, default: '', trim: true
  conversionRate:
    type: Number, default: 1

mongoose.model "Currency", CurrencySchema