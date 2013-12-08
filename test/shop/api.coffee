should   = require("should")
app      = require("../../server")
mongoose = require("mongoose")
shop     = mongoose.model "Shop"
http     = require('http')

request  = require("supertest")
server   = request.agent(app)

describe "<Unit Test>", ->
  describe "API Shop", ->


