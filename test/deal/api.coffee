should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

Deal     = mongoose.model "Deal"
User     = mongoose.model "User"
Shop     = mongoose.model "Shop"

server   = request.agent(app)


apiPreffix = '/api/v1'

deal = undefined
user = undefined
shop = undefined

describe "<Unit test>", ->
  describe "API Deal:", ->
    before (done) ->
      Deal.remove().exec()
      User.remove().exec()
      Shop.remove().exec()

      user = new User(
        email    : "user@user.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user.save()

      shop = new Shop(
        email   : "shop@shop.com"
        name    : "shop name"
        password: "pass11"
      )
      shop.save()

      deal = new Deal(
        name        : "deal name"
        description : "This is a fake deal"
        price       : 20
        gertuprice  : 10
        discount    : 50
        shop        : shop._id
        categoryname: "Category Name"
        quantity    : 20
      )
      deal.save()
      done()

    describe "API deal", ->
      it "should create a new deal", (done) ->
        server.post(apiPreffix + "/deals").send(
          name        : "deal1"
          description : "This is a fake deal"
          price       : 50
          gertuprice  : 25
          discount    : 50
          shop        : shop._id
          categoryname: "Category Name"
          quantity    : 20
        ).end (err, res) ->
          res.should.have.status 200
          done()

      it "should not be create because it does not exist this shop", (done) ->
        server.post(apiPreffix + "/deals").send(
          name        : "deal2"
          description : "This is a fake deal"
          price       : 50
          gertuprice  : 25
          discount    : 50
          shop        : "***fakeObjectIdOfShop***"
          categoryname: "Category Name"
          quantity    : 20
        ).end (err, res) ->
          res.should.have.status 404
          done()

      it "should not be created because no data", (done) ->
        server.post(apiPreffix + "/deals").send().end (err, res) ->
          res.should.have.status 422
          done()

      it "should not be created because name is missing", (done) ->
        server.post(apiPreffix + "/deals").send(
          description : "This is a fake deal"
          price       : 50
          gertuprice  : 25
          discount    : 50
          shop        : shop._id
          categoryname: "Category Name"
          quantity    : 20
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not be created because price is missing", (done) ->
        server.post(apiPreffix + "/deals").send(
          name        : "deal name"
          description : "This is a fake deal"
          gertuprice  : 25
          discount    : 50
          shop        : shop._id
          categoryname: "Category Name"
          quantity    : 20
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not be created because gertuprice is missing", (done) ->
        server.post(apiPreffix + "/deals").send(
          name        : "deal name"
          description : "This is a fake deal"
          price       : 50
          discount    : 50
          shop        : shop._id
          categoryname: "Category Name"
          quantity    : 20
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not be created because discount is missing", (done) ->
        server.post(apiPreffix + "/deals").send(
          name        : "deal name"
          description : "This is a fake deal"
          price       : 50
          gertuprice  : 25
          shop        : shop._id
          categoryname: "Category Name"
          quantity    : 20
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should find only two deals in DB", (done) ->
        Deal.find {}, (error, deals) ->
          deals.should.have.length 2
          done()

# unit tests about Comments
      it "should be able to add a comment", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user._id
            description: "This is a very important test"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 200
          done()

      it "should not add a comment because it does not exist this user", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : "***fakeObjectIdOfUser****"
            description: "This is a very important test"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 404
          done()

      it "should not add a comment because author is missing", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            description: "This is a very important test"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not add a comment because description is missing", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : "***fakeObjectIdOfUser****"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not add a comment because rating is missing", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : "***fakeObjectIdOfUser****"
            description: "This is a very important test"
        ).end (err, res) ->
          res.should.have.status 422
          done()

      after (done) ->
        Deal.remove().exec()
        User.remove().exec()
        Shop.remove().exec()
        done()