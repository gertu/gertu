should   = require("should")
app      = require("../../server")
mongoose = require("mongoose")
Shop     = mongoose.model("Shop")


shop1  = undefined
shop2 = undefined

describe "<Unit Test>", ->
  describe "Model Shop:", ->
    before (done) ->
      shop1 = new Shop(
        email     : "shop1_email@email.com"
        name  : "My shop 1 INC"
        password  : "123456"
      )
      shop2 = new Shop(
        email     : "shop2_email@email.com"
        name  : "My shop 2 INC"
        password  : "123456"
      )
      done()

    describe "Method Save", ->
      it "begin with no shops", (done) ->
        Shop.find {}, (error, shops) ->
          shops.should.have.length 0
          done()

      it "should be able to add a shop", (done) ->
        shop1.save done

      it "should now have a shop", (done) ->
        Shop.find {}, (error, shops) ->
          shops.should.have.length 1
          done()

      it "should now have a shop with correct email", (done) ->
        Shop.find { email: 'shop1_email@email.com'}, (error, shops) ->
          shops.should.have.length 1
          done()

      it "should now have a shop with all data correct", (done) ->
        Shop.find { email: 'shop1_email@email.com'}, (error, shops) ->

          shops[0].should.have.property "name", shop1.name
          shops[0].should.have.property "password", shop1.password
          done()

      it "should update data correctly", (done) ->

        shop1.password = '654321'
        shop1.save done

      it "should change data consistently", (done) ->

        Shop.find { email: 'shop1_email@email.com'}, (error, shops) ->

          shops[0].should.have.property "name", shop1.name
          shops[0].should.have.property "password", shop1.password
          done()