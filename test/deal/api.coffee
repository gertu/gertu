should       = require "should"
app          = require "../../server"
mongoose     = require "mongoose"
request      = require "supertest"
passportStub = require "passport-stub"


Deal     = mongoose.model "Deal"
User     = mongoose.model "User"
Shop     = mongoose.model "Shop"

passportStub.install app

server   = request.agent(app)


apiPreffix = '/api/v1'

deal  = undefined
user  = undefined
user2 = undefined
user3 = undefined
shop  = undefined

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
      user2 = new User(
        email    : "user2@user2.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user2.save()
      user3 = new User(
        email    : "user3@user3.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user3.save()

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

      setTimeout(
        -> done()
        1000
      )

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
          res.body.average.should.have.eql 0
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
        passportStub.login user
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user._id
            description: "This is a very important test"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 200
          res.body.average.should.have.eql 7
          res.body.shop.average.should.have.eql 0.2
          done()

      it "should not add a comment because description is missing", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user._id
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not add a comment because rating is missing", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user._id
            description: "This is a very important test"
        ).end (err, res) ->
          res.should.have.status 422
          done()

      it "should not add a comment because this user has already written on this deal", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user._id
            description: "This is a very important test"
            rating     : 8
        ).end (err, res) ->
          res.should.have.status 409
          passportStub.logout user
          done()

      it "should update the average score of the deal", (done) ->
        passportStub.login user2
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user2._id
            description: "This is a very important test"
            rating     : 8
        ).end (err, res) ->
          res.should.have.status 200
          res.body.average.should.have.eql 7.5
          res.body.shop.average.should.have.eql 0.5
          passportStub.logout user2
          done()

      it "should update the average score of the shop", (done) ->
        passportStub.login user3
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user3._id
            description: "This is a very important test"
            rating     : 3
        ).end (err, res) ->
          res.should.have.status 200
          res.body.average.should.have.eql 6
          res.body.shop.average.should.have.eql 0.3
          passportStub.logout user3
          done()

      it "should not add a comment because it does not exist this user", (done) ->
        passportStub.login "***fakeObjectIdOfUser****"
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : "***fakeObjectIdOfUser****"
            description: "This is a very important test"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 404
          passportStub.logout "***fakeObjectIdOfUser****"
          done()

      it "should not add a comment because the user is not logged", (done) ->
        server.put(apiPreffix + "/deals/" + deal._id + "/addcomment").send(
            author     : user._id
            description: "This is a very important test"
            rating     : 7
        ).end (err, res) ->
          res.should.have.status 401
          done()

      after (done) ->
        Deal.remove().exec()
        User.remove().exec()
        Shop.remove().exec()
        done()