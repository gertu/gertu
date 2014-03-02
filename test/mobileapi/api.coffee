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

  token = {}

  userOfApplication =
    name: 'Nombre usuario',
    email: 'nombreusuario@gertuproject.info',
    password: '123456',
    radius: 10000

  userWithSameEmail =
    name: 'Nombre usuario 2',
    email: 'nombreusuario@gertuproject.info',
    password: '123456',
    radius: 10000

  userWithDifferentEmail =
    name: 'Nombre usuario 2',
    email: 'nombreusuario2@gertuproject.info',
    password: '123456',
    radius: 10000

  shop1 = new Shop(
    name: 'Shop 1'
    email: 'emailshop1@mail.com'
    password: '123456',
    loc:
      latitude: 0,
      longitude: 0
  )

  shop2 = new Shop(
    name: 'Shop 2'
    email: 'emailshop2@mail.com'
    password: '123456',
    loc:
      latitude: 10,
      longitude: 10
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

  deal3 = new Deal(
    name: 'Deal 3',
    price: 4,
    gertuprice: 1,
    discount: 0.75,
    shop: shop2,
    quantity: 5)

  before (done) ->
    User.remove().exec()
    Deal.remove().exec()
    Shop.remove().exec()
    Token.remove().exec()
    Reservation.remove().exec()

    shop1.save( (err) ->

      shop2.save( (err) ->

        deal1.save( (err) ->

          deal2.save( (err) ->

            deal3.save( (err) ->

              done()
            )
          )
        )
      )
    )

  it "should signup a new user", (done) ->
    server.
      post(apiPreffix + '/users').
      send(userOfApplication).
      end (err, res) ->

        res.should.have.status 200

        token = JSON.parse(res.text).token

        token.should.not.be.undefined

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

  it "should NOT signin the newly created user with a wrong password", (done) ->

    server.
      post(apiPreffix + '/users/session').
      send({email: userOfApplication.email, password: 'nonexistantpassword'}).
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
        token = JSON.parse(res.text).token

        done()

  it "should be a token for the logged in user", (done) ->
    Token.find({_id: token}).exec( (err, tokens) ->

      tokens.should.not.be.undefined
      tokens.should.have.length 1

      done()

      )

  it "should return the current user", (done) ->
    server.
      get(apiPreffix + '/users').
      send({token: token}).
      end (err, res) ->
        res.should.have.status 200
        res.text.should.include userOfApplication.email
        done()

  it "should change info in the current user", (done) ->
    userOfApplication.name = 'new name'
    server.
      put(apiPreffix + '/users').
      send({firstName: 'new name',  email: 'newemail@mail.com', token: token}).
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
      send({token: token}).
      end (err, res) ->
        res.should.have.status 200
        res.text.should.not.include userOfApplication.email
        done()

  it "should return 3 deals when 3 are present", (done) ->
    server.
      get(apiPreffix + '/deals').
      send().
      end (err, res) ->
        res.should.have.status 200

        allDeals = JSON.parse(res.text)

        allDeals.should.not.have.length 4
        allDeals.should.have.length 3
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

  it "should return 2 near deals when user is at position", (done) ->
    server.
      post(apiPreffix + '/deals').
      send({longitude: 0, latitude: 0, token: token}).
      end (err, res) ->
        res.should.have.status 200

        allDeals = JSON.parse(res.text)

        allDeals.should.not.have.length 3
        allDeals.should.have.length 2
        done()

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
      send({token: token}).
      end (err, res) ->

        res.should.have.status 400
        done()

  it "should add a comment in a deal", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/comment').
      send({token: token, comment: 'new comment', rating: 5}).
      end (err, res) ->

        returnedDeal = JSON.parse(res.text)

        res.should.have.status 200
        returnedDeal.comments.should.have.length 1

        done()

  it "should make a reservation for a deal", (done) ->
    server.
      post(apiPreffix + '/deals/' + deal1._id + '/reservation').
      send({token: token}).
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
      send({token: token}).
      end (err, res) ->
        res.should.have.status 410
        done()

  it "should throw error when dreserved deal does not exist", (done) ->
    server.
      post(apiPreffix + '/deals/notexistantdeal/reservation').
      send({token: token}).
      end (err, res) ->
        res.should.have.status 404
        done()

  it "should return the reservations for a user", (done) ->
    server.
      post(apiPreffix + '/users/reservations').
      send({token: token}).
      end (err, res) ->

        allReservations = JSON.parse(res.text)
        allReservations.should.have.length 1
        res.should.have.status 200

        done()

  it "should throw authorization error on returning, as invalid token is passed", (done) ->
    server.
      post(apiPreffix + '/users/reservations').
      send({token: 'wrongtoken'}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should throw authorization error on returning, as no token is passed", (done) ->
    server.
      post(apiPreffix + '/users/reservations').
      send().
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should still be able to retrieve the current user", (done) ->

    server.
      get(apiPreffix + '/users').
      send({token: token}).
      end (err, res) ->

        res.should.have.status 200
        done()

  it "should log out current user", (done) ->
    server.
      del(apiPreffix + '/users/session').
      send({token: token}).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should NOT be able to retrieve the current user, as user is logged out", (done) ->

    server.
      get(apiPreffix + '/users').
      send({token: token}).
      end (err, res) ->

        res.should.have.status 403
        done()

  it "should be able to give access to a new token", (done) ->

    newUser = new User(
      email: 'thisemail@mail.com',
      password: '123456',
      firstName: 'this user'
      )

    newUser.save ( (err) ->

      newToken = new Token(
        token : Math.random() * 16
        user : newUser
        last_access : new Date()
      )

      newToken.save( (err) ->

      server.
        get(apiPreffix + '/users').
        send({token: newToken._id}).
        end (err, res) ->

          res.should.have.status 200
          done()
      )
    )

  it "should be able to give access to a valid lasting token", (done) ->

    newUser = new User(
      email: 'thisemail2@mail.com',
      password: '123456',
      firstName: 'this user'
      )

    newUser.save ( (err) ->

      newToken = new Token(
        token : Math.random() * 16
        user : newUser
        last_access : new Date(new Date() - (5 * 60000))
      )

      newToken.save( (err) ->

      server.
        get(apiPreffix + '/users').
        send({token: newToken._id}).
        end (err, res) ->

          res.should.have.status 200
          done()
      )
    )

  it "should NOT be able to give access to a expired token", (done) ->

    newUser = new User(
      email: 'thisemail3@mail.com',
      password: '123456',
      firstName: 'this user'
      )

    newUser.save ( (err) ->

      newToken = new Token(
        token : Math.random() * 16
        user : newUser
        last_access : new Date(new Date() - (21 * 60000))
      )

      newToken.save( (err) ->

      server.
        get(apiPreffix + '/users').
        send({token: newToken._id}).
        end (err, res) ->

          res.should.have.status 403
          done()
      )
    )

  after (done) ->
    #Token.remove().exec()
    User.remove().exec()
    Deal.remove().exec()
    Shop.remove().exec()
    Reservation.remove().exec()
    done()