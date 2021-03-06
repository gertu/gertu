should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
User     = mongoose.model "User"


user  = undefined
user2 = undefined

describe "<Unit Test>", ->
  describe "Model User:", ->
    before (done) ->
      User.remove().exec()
      
      user = new User(
        email    : "user@user.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user2 = new User(
        email    : "USER2@user.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "password"
      )
      done()

    describe "Method Save", ->
      it "should be able to begin with no users", (done) ->
        User.find {}, (error, users) ->
          users.should.have.length 0
          done()

      it "should be able to save whithout problems", (done) ->
        user.save done

      it "should be able to fail to save an email wich is already in use", (done) ->
        user.save()
        user2.save ->
          (email: user.email).should.not.eql email: user2.email
          done()


    after (done) ->
      User.remove().exec()
      done()


