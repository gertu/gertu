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
  image        : type: String, default: "/public/upload/terraza.jpg"
  created      : type: Date, default: Date.now
  quantity     : type: Number
  days         : type: String
  average      : type: Number, default: 0, min: 0, max: 10
  comments     : [
      author      : type: Schema.Types.ObjectId, required: true, ref: "User"
      description : type: String
      writedAt    : type: Date, default: Date.now
      rating      : type: Number
  ]

DealSchema.statics.load = (id, cb) ->
  @findOne(_id: id).populate("shop", "name shop").exec cb


mongoose.model "Deal", DealSchema