should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

User        = mongoose.model "User"
Shop        = mongoose.model "Shop"
Deal        = mongoose.model "Deal"
Token       = mongoose.model "Token"
Reservation = mongoose.model "Reservation"

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
    shop: shop1,
    quantity: 10)

  deal2 = new Deal(
    name: 'Deal 2',
    price: 4,
    gertuprice: 1,
    discount: 0.75,
    shop: shop1,
    quantity: 0)

  before (done) ->
    User.remove().exec()
    Deal.remove().exec()
    Shop.remove().exec()
    Token.remove().exec()
    Reservation.remove().exec()

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

        userOfApplication._id = JSON.parse(res.text)._id

        done()

  it "should be a token for the logged in user", (done) ->
    Token.findOne({token: userOfApplication._id}).exec( (err, token) ->

      token.should.not.be.undefined
      token.should.have.property 'token', userOfApplication._id
      done()

      )

  it "should return the current user", (done) ->
    server.
      get(apiPreffix + '/users').
      send({token: userOfApplication._id}).
      end (err, res) ->
        res.should.have.status 200
        res.text.should.include userOfApplication.email
        done()

  it "should change info in the current user", (done) ->

    userOfApplication.name = 'new name'
    server.
      put(apiPreffix + '/users').
      send({firstName: 'new name',  email: 'newemail@mail.com', token: userOfApplication._id}).
      end (err, res) ->
        res.should.have.status 200
        res.text.should.include 'new name'
        done()

  it "should throw authorization error on logging out, as no token has been passed", (done) ->
    server.
      del(apiPreffix + '/users/session').
      send().
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should log out current user", (done) ->
    server.
      del(apiPreffix + '/users/session').
      send({token: userOfApplication._id}).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should throw authorization error on returning the current user, as no token is passed", (done) ->
    server.
      get(apiPreffix + '/users').
      send().
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should NOT return the current user, as there is no user logged in", (done) ->
    server.
      get(apiPreffix + '/users').
      send({token: userOfApplication._id}).
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

  it "should throw authorization error on commenting a deal, as no token is passed", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/comment').
      send({comment: 'new comment', rating: 5}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should throw authorization error on commenting a deal, as invalid token is passed", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/comment').
      send({token: 'wrongtoken', comment: 'new comment', rating: 5}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should NOT add a comment in a deal if comments and rating are ommitted", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/comment').
      send({token: userOfApplication._id}).
      end (err, res) ->

        res.should.have.status 400
        done()

  it "should add a comment in a deal", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/comment').
      send({token: userOfApplication._id, comment: 'new comment', rating: 5}).
      end (err, res) ->

        returnedDeal = JSON.parse(res.text)

        res.should.have.status 200
        returnedDeal.comments.should.have.length 1

        done()

  it "should make a reservation for a deal", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/reservation').
      send({token: userOfApplication._id}).
      end (err, res) ->

        returnedReservation = JSON.parse(res.text)

        res.should.have.status 200
        returnedReservation.should.have.property "_id"

        done()

  it "should mark one less item in quantity allowed for a deal", (done) ->
    Deal.findOne({_id: deal1._id}).exec( (err, deal) ->

      deal.should.not.be.undefined
      deal.should.have.property 'quantity', 9
      done()
    )

  it "should throw authorization error on reserving a deal, as invalid token is passed", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/reservation').
      send({token: 'wrongtoken'}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should not make a reservation if deal quantity is consumed", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal2._id + '/reservation').
      send({token: userOfApplication._id}).
      end (err, res) ->
        res.should.have.status 410
        done()

  it "should throw error when dreserved deal does not exist", (done) ->
    server.
      post(apiPreffix + '/deals/notexistantdeal/reservation').
      send({token: userOfApplication._id}).
      end (err, res) ->
        res.should.have.status 404
        done()

  it "should return the reservations for a user", (done) ->
    server.
      get(apiPreffix + '/users/reservations').
      send({token: userOfApplication._id}).
      end (err, res) ->

        allReservations = JSON.parse(res.text)
        allReservations.should.have.length 1
        res.should.have.status 200

        done()

  it "should throw authorization error on returning, as invalid token is passed", (done) ->
    server.
      get(apiPreffix + '/users/reservations').
      send({token: 'wrongtoken'}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should throw authorization error on returning, as no token is passed", (done) ->
    server.
      get(apiPreffix + '/users/reservations').
      send().
      end (err, res) ->
        res.should.have.status 403
        done()

  describe "Security testing", ->

    testingToken = new Token(
      token = userOfApplication._id,
      user = userOfApplication
      )

    before (done) ->
      Token.remove().exec()
      User.remove().exec()
      Deal.remove().exec()
      Shop.remove().exec()
      Reservation.remove().exec()
      done()

    it "should throw authorization error when token has expired", (done) ->

      testingToken.last_access = new Date(new Date() - (21 * 60000)) # 21 minutes

      testingToken.save ( (err) ->

        server.
          get(apiPreffix + '/users').
          send({token: userOfApplication._id}).
          end (err, res) ->
            console.log res.text
            res.should.have.status 403
            done()

        )



    after (done) ->
      Token.remove().exec()
      User.remove().exec()
      Deal.remove().exec()
      Shop.remove().exec()
      Reservation.remove().exec()
      done()

  after (done) ->
    Token.remove().exec()
    User.remove().exec()
    Deal.remove().exec()
    Shop.remove().exec()
    Reservation.remove().exec()
    done()