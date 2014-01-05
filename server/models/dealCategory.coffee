mongoose    = require "mongoose"
Schema      = mongoose.Schema

# Deal category Schema

DealCategorySchema = new Schema
  name:
    type: String, default: '', trim: true

mongoose.model "DealCategory", DealCategorySchema