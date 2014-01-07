should        = require("should")
request       = require('supertest')
express       = require('express');
server        = require("../../server")
mongoose      = require("mongoose")
Administrator = mongoose.model("Administrator")

app = express()
request = request('http://localhost:3000');

describe "Management administrator model testing", ->
  before (done) ->
    Administrator.remove().exec( () ->
      done()
    )

  it "should be no adminsitrators", (done) ->
    Administrator.count({}).exec( (err, count) ->
      count.should.equal(0);
      done()
    )

  it "should add a new administrators", (done) ->
    administrator = new Administrator({name: 'administrator 1', email: 'admin@email.com', password: '123456'});
    administrator.save( ()->
      done()
    )

  it "should have 1 administrator", (done) ->
    Administrator.count({}).exec( (err, count) ->
      count.should.equal(1);
      done()
    )

  it "should find 1 administrator for existant email", (done) ->
    Administrator.count({email: 'admin@email.com'}).exec( (err, count) ->
      count.should.equal(1);
      done()
    )

  it "should find no administrator for non existant email", (done) ->
    Administrator.count({email: 'admin1@email.com'}).exec( (err, count) ->
      count.should.equal(0);
      done()
    )

  it "should not add a new administrator with an existant email", (done) ->
    administrator = new Administrator({name: 'administrator 2', email: 'admin@email.com', password: '654321'});
    administrator.save( (err)->
      should.exist(err)
      done()
    )

  it "should find just 1 administrator for existant email", (done) ->
    Administrator.count({email: 'admin@email.com'}).exec( (err, count) ->
      count.should.equal(1);
      done()
    )

  it "should not add a new administrator with an empty name", (done) ->
    administrator = new Administrator({name: '', email: 'admin_new1@email.com', password: '654321'});
    administrator.save( (err)->
      should.exist(err)
      done()
    )

  it "should not add a new administrator with an empty password", (done) ->
    administrator = new Administrator({name: 'administrator 3', email: 'admin_new1@email.com', password: ''});
    administrator.save( (err)->
      should.exist(err)
      done()
    )

  it "should be just 1 administrator", (done) ->
    Administrator.count({}).exec( (err, count) ->
      count.should.equal(1);
      done()
    )

  it "should find an administrator given the email", (done) ->
    Administrator.findOne({email: 'admin@email.com'}).exec( (err, administrator) ->

      should.not.exist(err)
      should.exist(administrator)
      administrator.name.should.equal('administrator 1')

      done()
    )

  it "should remove an administrator given the email", (done) ->
    Administrator.findOne({email: 'admin@email.com'}).exec( (err, administrator) ->

      administrator.remove( (err) ->
        should.not.exist(err)
        done()
      )
    )

  it "should not find an administrator given the email", (done) ->
    Administrator.findOne({email: 'admin@email.com'}).exec( (err, administrator) ->
      should.not.exist(administrator)
      done()
    )

  after (done) ->
    Administrator.remove().exec( () ->
      # This is used in the application
      administrator = new Administrator({name: 'administrator 1', email: 'admin@email.com', password: '123456'});
      administrator.save( ()->
        done()
      )
    )