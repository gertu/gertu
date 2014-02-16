should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

Deal     = mongoose.model "Deal"
Shop     = mongoose.model "Shop"
server   = request.agent(app)

apiPreffix = '/api/v1'

describe "<Unit test>", ->
  describe "API deal", ->

    shop = { }

    before (done) ->

      shop = new Shop({
        name: 'shop 1',
        email: 'shop1@gertuproject.info',
        password: '123456'
      })

      shop.save( (err) ->
          done()
        )

    it "should create a new deal", (done)->
      
      deal = {
        name:  "deal1", 
        description: "esta es la descripcion",
        price: 50, 
        gertuprice: 25, 
        discount: 50
        shop:  shop._id
      }
      server.
        post(apiPreffix + "/deals").
        send(deal).end (err, res) ->
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
      Shop.remove().exec()
      done()
      
