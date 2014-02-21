should   = require "should"
mongoose = require "mongoose"
request  = require "supertest"
Shop     = mongoose.model "Shop"

valid_shop = { }
shop2 = { }

describe "<Unit Test>", ->
  describe "Model Shop:", ->
    before (done) ->
      Shop.remove().exec()

      valid_shop = new Shop(
        email     : "shop1_email@email.com"
        name  : "My shop 1 INC"
        password  : "123456"
      )

      done()

    describe "Method Save", ->
      it "begin with no shops", (done) ->
        Shop.find {}, (error, shops) ->
          shops.should.have.length 0
          done()

      it "should be able to add a shop", (done) ->
        valid_shop.save done

      it "should now have a shop", (done) ->
        Shop.find {}, (error, shops) ->
          shops.should.have.length 1
          done()

      it "should now have a shop with correct email", (done) ->
        Shop.find { email: 'shop1_email@email.com'}, (error, shops) ->
          shops.should.have.length 1
          done()

      it "should now have a shop with all data correct", (done) ->
        Shop.findOne({ email: 'shop1_email@email.com'}).exec( (error, shop) ->

          shop.should.have.property "name", valid_shop.name
          done()
        )

      it "should update data correctly", (done) ->

        valid_shop.name = 'new name'
        valid_shop.save () ->
          done()

      it "should change data consistently", (done) ->

        Shop.findOne({ email: 'shop1_email@email.com'}).exec( (error, shop) ->

          shop.should.have.property "name", valid_shop.name
          done()
        )

    after (done) ->
      Shop.remove().exec()
      done()
