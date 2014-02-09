mongoose     = require "mongoose"
config       = require "../../config/config"
Schema       = mongoose.Schema
Validations  = require "./validations"


DealSchema = new Schema
  name         : type: String, required: true, trim: true
  description  : type: String, trim: true
  price        : type: Number, required: true, trim: true
  gertuprice   : type: Number, required: true, trim: true
  discount     : type: Number, required: true, trim: true
  shop         : type: Schema.Types.ObjectId, required: true, ref: "Shop"
  categoryname : type: String
  datainit     : type: Date
  dataend      : type: Date
  image        : type: String
  created      : type: Date, default: Date.now
  quantity     : type: Number
  average      : type: Number, default: 0, min: 0, max: 10
  comments     : [
      author      : type: Schema.Types.ObjectId, required: true, ref: "User"
      description : type: String
      writedAt    : type: Date, default: Date.now
      rating      : type: Number
  ]

mongoose.model "Deal", DealSchema