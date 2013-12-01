mongoose = require "mongoose"
Schema = mongoose.Schema

# Shop Schema

Shop = new Schema
  name:
    type: String,
    default: '',
    trim: true
  email:
    type: String,
    default: '',
    trim: true
  password:
    type: String,
    default: '',
    trim: true

mongoose.model "Shop", Shop

