should   = require("should")
request = require('supertest')
express = require('express');
app = express()

server   = require("../../server")
mongoose = require("mongoose")
Shop     = mongoose.model("Shop")

request = request('http://localhost:3000');

describe "General", ->
  it "should be listening on port 3000", (done) ->
    request.
    get("/").
    expect 200, done

  it "should signup a new shop", (done) ->
    request.
    post("/shop/signup").
    send({name: 'Shop name', email: 'myshop@email.com', password: '123456'}).
    end (err, res) ->
      res.should.have.status 200
      done()

  it "should find just one shop in database", (done) ->
    Shop.find {}, (error, shops) ->
      shops.should.have.length 1
      done()

  it "should mark an existant email for a shop as existant", (done) ->
    request.
    get("/shop/emailexists?email=myshop@email.com").
    end (err, res) ->
      res.should.have.status 200
      done()

  it "should mark a non existant email for a shop as non existant", (done) ->
    request.
    get("/shop/emailexists?email=mynonexistantshop@email.com").
    end (err, res) ->
      res.should.have.status 200
      res.text.should.include 'False'
      done()

  it "should return error on verifying email existance when no email is passed", (done) ->
    request.
    get("/shop/emailexists?email=").
    end (err, res) ->
      res.should.have.status 422
      done()

  it "should be able to grant access to the newly created shop", (done) ->
    request.
    post("/shop/login").
    send({email: 'myshop@email.com', password: '123456'}).
    end (err, res) ->
      res.should.have.status 200
      done()

  it "should not let a non-existant shop to login", (done) ->
    request.
    post("/shop/login").
    send({email: 'mynonexistantshop@email.com', password: '123456789'}).
    end (err, res) ->
      res.should.have.status 403
      done()

  it "should not signup a new shop if provided data is invalid", (done) ->
    request.
    post("/shop/signup").
    send({name: '', email: '', password: ''}).
    end (err, res) ->
      res.should.have.status 422
      done()

  it "should notify incorrect data when login with incomplete data", (done) ->
    request.
    post("/shop/login").
    send({email: '', password: ''}).
    end (err, res) ->
      res.should.have.status 422
      done()

  it "should send an email when signing up a new shop", (done) ->
    request.
    post("/shop/signup").
    send({name: 'Shop name', email: 'mail@gertuproject.info', password: '123456'}).
    end (err, res) ->
      res.should.have.status 200
      done()

  after (done) ->
    Shop.remove().exec()
    done()


