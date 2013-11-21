should   = require("should")
app      = require("../../server")
mongoose = require("mongoose")
User     = mongoose.model("User")

request  = require("supertest")
server = request.agent("http://localhost:3000")


user  = undefined
user2 = undefined

describe "<Unit Test>", ->
  describe "API User:", ->
    before (done) ->
      user = new User(
        email    : "user@user.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user.save done

    describe "Authentication", ->
      it "Local login", (done) ->
        server.post("/users/session").send(
          email: "user@user.com"
          password: "pass11"
        ).end (err, res) ->
          res.should.have.status(200)
          done()

    after (done) ->
      User.remove().exec()
      done()