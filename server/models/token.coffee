mongoose    = require "mongoose"
Schema      = mongoose.Schema

# Application tokens for mobile API

TokenSchema = new Schema
  token:
    type: String,
    trim: true,
    required: true
  user:
    type: Schema.Types.ObjectId,
    required: true,
    ref: "User"
  last_access:
    type: Date,
    required: true


TokenSchema.methods =
  refresh: () ->
    @last_access = new Date()
    @save()

  encryptPassword: (password) ->
    return ""  unless password
    crypto.createHmac("sha1", @salt).update(password).digest "hex"

mongoose.model "Token", TokenSchema