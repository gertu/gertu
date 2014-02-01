should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

User     = mongoose.model "User"
server   = request.agent(app)

apiPreffix = '/mobile/v1'

describe "Mobile API testing", ->
  
  userOfApplication = 
    name: 'Nombre usuario',
    email: 'nombreusuario@email.com',
    password: '123456'

  before (done) ->
    User.remove().exec()
    done()

  it "should signup a new user", (done) ->
    server.
      post(apiPreffix + '/users').
      send(userOfApplication).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should NOT signin a non existant user", (done) ->
    server.
      post(apiPreffix + '/users/login').
      send({email: 'nonexistantmail@mail.com', password: 'nonexistantpassword'}).
      end (err, res) ->
        res.should.have.status 403
        done()

  it "should signin the newly created user", (done) ->
    server.
      post(apiPreffix + '/users/login').
      send({email: userOfApplication.email, password: userOfApplication.password}).
      end (err, res) ->
        res.should.have.status 200
        done()

  it "should return the current user", (done) ->
    server.
      get(apiPreffix + '/users').
      send().
      end (err, res) ->
        res.should.have.status 200
        res.text.should.include userOfApplication.email
        done()

  it "should log out current user", (done) ->
    server.
      get(apiPreffix + '/users/logout').
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

  ###
  it "should allow update current user", (done) ->

    userOfApplicationUpdated = userOfApplication;
    userOfApplicationUpdated.name = 'newname'

    server.
      put(apiPreffix + '/users').
      send(userOfApplicationUpdated).
      end (err, res) ->
        res.should.have.status 200
        done()
  ###
  
  after (done) ->
    User.remove().exec()
    done()


