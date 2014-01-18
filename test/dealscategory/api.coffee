should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

Dealscategory  = mongoose.model "DealCategory"
server   = request.agent(app)

apiPreffix = '/api/v1'

describe "<Unit test>", ->
  describe "API DealCategory", ->
    it "should find all DealCategory", (done)->
      server.get(apiPreffix + "/dealscategory")
      .end (err, res) ->
      	res.should.have.status 200
      	done()


    after (done) ->
      Dealscategory.remove().exec()
      done()