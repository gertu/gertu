mongoose = require "mongoose"
Schema   = mongoose.Schema


ReservationSchema = new Schema
  deal    :type: Schema.Types.ObjectId, ref: "Deal", index: true, required: true
  user    :type: Schema.Types.ObjectId, ref: "User", index: true, required: true
  redeemed: type: Boolean, default: false
  date    : type: Date, default: Date.now


mongoose.model "Reservation", ReservationSchema