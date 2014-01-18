mongoose = require('mongoose')
config   = require('../../config/config')
Schema   = mongoose.Schema

DealSchema = new Schema
  name:
    type:     String
    required: true
    trim:     true
  price:
    type:     Number
    required: true
    trim:     true
  image:
    type:     String
    trim:     true
  created:
    type:     Date
    default:  Date.now
  categoryname:
    type:     String
  shop:
    required: true
    type:     Schema.Types.ObjectId
    ref:      "Shop"
  

DealSchema.statics.load = (id, cb) ->
  @findOne(_id: id).populate("shop", "name shop").exec cb
    
mongoose.model "Deal", DealSchema