should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

Deal     = mongoose.model "Deal"
server   = request.agent(app)

apiPreffix = '/api/v1'

describe "<Unit test>", ->
  describe "API deal", ->
    it "should create a new deal", (done)->
      server.post(apiPreffix + "/deals").send(
      	name:  "deal1", description: "esta es la descripcion",
      	price: 50, gertuprice: 25, discount: 50
      	shop:  "524f36e34ca6e9c82a000001"
      ).end (err, res) ->
      	res.should.have.status 200
      	done()

    it "should not be created because no data", (done)->
    	server.post(apiPreffix + "/deals").send(
    	  name: "", description: "", price: ""
    	  gertuprice: "", discount: "",
    	  shop: "").end (err, res)->
    	  res.should.have.status 422
    	  done()

    it "should find only one deal in DB", (done)->
    	Deal.find {}, (error, deals)->
          deals.should.have.length 1
          done()

    after (done) ->
      Deal.remove().exec()
      done()
      
