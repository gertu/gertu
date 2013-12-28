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
          email: "user2@user.com"
          password: "pass112"
        ).end (err, res) ->

          # res.should.have.status(302);
          if err
            throw err
          console.log "In else"
          done()



    after (done) ->
      User.remove().exec()
      done()


