mongoose = require('mongoose')
config   = require('../../config/config')
Schema   = mongoose.Schema

DealSchema = new Schema
  name:
    type:     String
    required: true
    trim:     true
  description:
    type:     String
    trim:     true
  price:
    type:     Number
    required: true
    trim:     true
  gertuprice:
    type:     Number
    required: true
    trim:     true
  discount:
    type:     Number
    required: true
    trim:     true
  shop:
    required: true
    type:     Schema.Types.ObjectId
    ref:      "Shop"
  categoryname:
    type:     String
  datainit:
    type:     Date
  dataend:
    type:     Date
  image:
    type:     String
  created:
    type:     Date
    default:  Date.now


DealSchema.statics.load = (id, cb) ->
  @findOne(_id: id).populate("shop", "name shop").exec cb
    
mongoose.model "Deal", DealSchema