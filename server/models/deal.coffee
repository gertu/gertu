
# Module dependencies.
mongoose = require('mongoose')
config = require('../../config/config')
Schema = mongoose.Schema


# Article Schema
DealSchema = new Schema(


  created:
    type: Date
    default: Date.now

  price:
    type: Number
    default: ''

  name:
    type: String
    default: ''
    trim: true

  shop:
    type: String
    default: ''
    trim: true

  image:
    type: String
    default: 'http://media.tumblr.com/tumblr_m9e0vfpA7K1qkbsaa.jpg'

  content:
    type: String
    default: ''
    trim: true
)


# Validations
DealSchema.path('name').validate ((name) ->
  name.length
), 'Title cannot be blank'

DealSchema.path('price').validate ((price) ->
  price.length
), 'Price cannot be blank'


mongoose.model 'Deal', DealSchema