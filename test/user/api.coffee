should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
request  = require "supertest"

User     = mongoose.model "User"
server   = request.agent(app)

apiPreffix = '/api/v1'

describe "<Unit Test>", ->
  describe "API User:", ->
    before (done) ->
      user = new User(
        email    : "user@user.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user.save()
      done()

    describe "Authentication", ->
      it "should be able to login locally", (done) ->
        server.post(apiPreffix + "/users/session").send(
          email   : "user@user.com"
          password: "pass11"
        ).end (err, res) ->
          res.headers.location.should.have.equal "/"
          done()

      it "should be able to sign up",       (done) ->
        server.post(apiPreffix + "/users").send(
          email   : "newuser@user.com"
          password: "pass11"
        ).end (err, res) ->
          res.headers.location.should.have.equal "/"
          done()

      it "should be able to logout",        (done) ->
        server.get(apiPreffix + "/signout").send().end (err, res) ->
          res.should.have.status 302
          server.get("/").send().end (err, res) ->
           res.should.have.status 200
          done()

    after (done) ->
      User.remove().exec()
      done()


