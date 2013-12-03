should   = require("should")
app      = require("../../server")
mongoose = require("mongoose")
User     = mongoose.model("User")

request  = require("supertest")
server   = request.agent(app)


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
      it "local login", (done) ->
        server.post("/users/session").send(
          email   : "user@user.com"
          password: "pass11"
        ).end (err, res) ->
          res.headers.location.should.have.equal "/"
          done()

      it "logout", (done) ->
        server.get("/signout").send().end (err, res) ->
          res.headers.location.should.have.equal "/"
          done()

    after (done) ->
      User.remove().exec()
      done()


