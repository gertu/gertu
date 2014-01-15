should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

Deal     = mongoose.model "Deal"
server   = request.agent(app)

apiPreffix = '/api'

describe "<Unit test>", ->
  describe "API deal", ->
    it "should create a new deal", (done)->
      server.post(apiPreffix + "/deals").send(
      	name:  "deal1"
      	price: 21
      	image: "/img/deals/img1.jpg"
      	shop:  "524f36e34ca6e9c82a000001"
      ).end (err, res) ->
      	res.should.have.status 200
      	done()

    it "should not be created because no data", (done)->
    	server.post(apiPreffix + "/deals").send(
    	  name: ""
    	  price: ""
    	  image: ""
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
      
