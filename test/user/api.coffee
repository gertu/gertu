should   = require("should")
app      = require("../../server")
mongoose = require("mongoose")
User     = mongoose.model("User")

request  = require("supertest")
server = request.agent("http://localhost:3000")


user  = undefined

describe "<Unit Test>", ->
  describe "API User:", ->
    before (done) ->
      user = undefined
      user = new User(
        email: "user@user.com"
        firstName: "Full Name"
        lastName: "Last Name"
        password: "pass11"
      )
      user.save done

    describe "Authentication", ->
      it "Local login", (done) ->
        server.post("/users/session").send(
          email: "user@user.com"
          password: "pass11"
        ).end (err, res) ->

          # res.should.have.status(302);
          if res.status is 302
            console.log res.req.path
            server.get("/signin").end (err, res) ->
              res.should.have.status 200
              done()

          else
            console.log "In else"
            done()



    after (done) ->
      User.remove().exec()
      done()


