should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

User     = mongoose.model "User"
Shop     = mongoose.model "Shop"
Deal     = mongoose.model "Deal"

server   = request.agent(app)

apiPreffix = '/mobile/v1'

describe "Mobile API testing", ->
  
  userOfApplication = 
    name: 'Nombre usuario',
    email: 'nombreusuario@gertuproject.info',
    password: '123456'

  userWithSameEmail = 
    name: 'Nombre usuario 2',
    email: 'nombreusuario@gertuproject.info',
    password: '123456'

  userWithDifferentEmail = 
    name: 'Nombre usuario 2',
    email: 'nombreusuario2@gertuproject.info',
    password: '123456'

  shop1 = new Shop(
    name: 'Shop 1'
    email: 'emailshop1@mail.com'
    password: '123456'
  )

  deal1 = new Deal(
    name: 'Deal 1',
    price: 2,
    gertuprice: 1,
    discount: 0.5,
    shop: shop1)

  deal2 = new Deal(
    name: 'Deal 2',
    price: 4,
    gertuprice: 1,
    discount: 0.75,
    shop: shop1)

  before (done) ->
    User.remove().exec()
    Deal.remove().exec()
    Shop.remove().exec()

    shop1.save( (err) ->

      deal1.save( (err) ->

        deal2.save( (err) ->

          done()
          )
        )
    )
   
  it "should signup a new user", (done) ->
    server.
      post(apiPreffix + '/users').
      send(userOfApplication).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should not signup a user with a existant email", (done) ->
    server.
      post(apiPreffix + '/users').
      send(userWithSameEmail).
      end (err, res) ->
        res.should.have.status 409
        res.text.should.include 11000
        done()

  it "should signup a new user with different email", (done) ->
    server.
      post(apiPreffix + '/users').
      send(userWithDifferentEmail).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should NOT signin a non existant user", (done) ->
    server.
      post(apiPreffix + '/users/session').
      send({email: 'nonexistantmail@mail.com', password: 'nonexistantpassword'}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should signin the newly created user", (done) ->
    server.
      post(apiPreffix + '/users/session').
      send({email: userOfApplication.email, password: userOfApplication.password}).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should return the current user", (done) ->
    server.
      get(apiPreffix + '/users/session').
      send().
      end (err, res) ->
        res.should.have.status 200
        res.text.should.include userOfApplication.email
        done()

  it "should change info in the current user", (done) ->

    userOfApplication.name = 'new name'
    console.log(userOfApplication)
    server.
      put(apiPreffix + '/users').
      send({firstName: 'new name',  email: 'newemail@mail.com'}).
      end (err, res) ->
        res.should.have.status 200
        res.text.should.include 'new name'
        done()

  it "should log out current user", (done) ->
    server.
      del(apiPreffix + '/users/session').
      send().
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should NOT return the current user, as there is no user logged in", (done) ->
    server.
      get(apiPreffix + '/users').
      send().
      end (err, res) ->
        res.should.have.status 200
        res.text.should.not.include userOfApplication.email
        done()

  it "should return 2 deals when 2 are present", (done) ->
    server.
      get(apiPreffix + '/deals').
      send().
      end (err, res) ->
        res.should.have.status 200

        allDeals = eval(res.text)

        allDeals.should.not.have.length 3
        allDeals.should.have.length 2
        done()

  it "should return first deal when requested", (done) ->
    
    deal1.save( (err) ->
      
      server.
        get(apiPreffix + '/deals/' + deal1._id).
        send().
        end (err, res) ->
          res.should.have.status 200

          res.text.should.include deal1.name
          res.text.should.include deal1._id

          done()
    )
  
  after (done) ->
    User.remove().exec()
    Deal.remove().exec()
    Shop.remove().exec()
    done()


