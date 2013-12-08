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

  it "should nofity incorrect data when login with incomplete data", (done) ->
    request.
    post("/shop/login").
    send({email: '', password: ''}).
    end (err, res) ->
      res.should.have.status 422
      done()

  after (done) ->
    Shop.remove().exec()
    done()


