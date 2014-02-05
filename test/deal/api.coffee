should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

Deal     = mongoose.model "Deal"
server   = request.agent(app)

apiPreffix = '/api/v1'

deal = undefined

describe "<Unit test>", ->
  before (done) ->
    Deal.remove().exec()

    deal = new Deal(
      name       : "deal"
      description: "This is a fake deal"
      price      : 20
      gertuprice : 10
      discount   : 50
      shop       : "524f36e34ca6e9c82a000011"
    )
    deal.save()
    done()

  describe "API deal", ->
    it "should create a new deal", (done) ->
      server.post(apiPreffix + "/deals").send(
        name       : "deal1"
        description: "esta es la descripcion"
        price      : 50
        gertuprice : 25
        discount   : 50
        shop       : "524f36e34ca6e9c82a000001"
      ).end (err, res) ->
        res.should.have.status 200
        done()

    it "should not be created because no data", (done) ->
      server.post(apiPreffix + "/deals").send(
        name       : ""
        description: ""
        price      : ""
        gertuprice : ""
        discount   : ""
        shop       : ""
      ).end (err, res) ->
        res.should.have.status 422
        done()

    it "should find only one deal in DB", (done) ->
      Deal.find {}, (error, deals) ->
        deals.should.have.length 2
        done()

    it "should be able to add a comment", (done) ->
      server.put(apiPreffix + "/deals/" + deal._id).send(
        comments: [
          author     : "user1"
          description: "This is a very important test"
          rating     : 7
        ]
      ).end (err, res) ->
        (res.body._id).should.eql deal._id
        done()

    after (done) ->
      Deal.remove().exec()
      done()