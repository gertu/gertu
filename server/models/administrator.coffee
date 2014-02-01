mongoose    = require "mongoose"
Schema      = mongoose.Schema
Validations = require("./validations")

# Adminisrator Schema

AdministratorSchema = new Schema
  name:
    type: String, default: '', trim: true, required: true
  email:
    type: String, default: '', trim: true, required: true, unique: true, lowercase: true
  password:
    type: String, default: '', trim: true, required: true

mongoose.model "Administrator", AdministratorSchema