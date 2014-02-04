mongoose     = require "mongoose"
config       = require "../../config/config"
Schema       = mongoose.Schema
Validations  = require "./validations"


DealSchema = new Schema
  _id          : type: String
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


DealSchema.pre "save", (next) ->
  @_id = Validations.slugify(@name)
  next()


DealSchema.statics.load = (id, cb) ->
  @findOne(_id: id).populate("shop", "name shop").exec cb

mongoose.model "Deal", DealSchema