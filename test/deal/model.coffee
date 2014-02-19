should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"

Deal     = mongoose.model "Deal"
User     = mongoose.model "User"
Shop     = mongoose.model "Shop"


deal = undefined
user = undefined
shop = undefined

describe "<Unit test>", ->
  describe "Model Deal:", ->
    before (done) ->
      Deal.remove().exec()
      User.remove().exec()
      Shop.remove().exec()

      user = new User(
        email    : "user@user.com"
        firstName: "Full Name"
        lastName : "Last Name"
        password : "pass11"
      )
      user.save()

      shop = new Shop(
        email   : "shop@shop.com"
        name    : "shop name"
        password: "pass11"
      )
      shop.save()

      deal = new Deal(
        name        : "deal name"
        description : "This is a fake deal"
        price       : 20
        gertuprice  : 10
        discount    : 50
        shop        : shop._id
        categoryname: "Category Name"
        quantity    : 20
      )
      done()

      describe "Method Save", ->
        it "should be able to begin with no deals", (done) ->
          Deal.find {}, (error, deals) ->
            deals.should.have.length 0
            done()

        it "should be able to add a deal", (done) ->
          deal.save done

        it "should now have a deal", (done) ->
          Deal.find {}, (error, deals) ->
            deals.should.have.length 1
            done()

        it "should now have a deal with all data correct", (done) ->
          Deal.find {}, (error, deals) ->
            deals[0].should.have.property "name", deal.name
            deals[0].should.have.property "description", deal.description
            deals[0].should.have.property "price", deal.price
            deals[0].should.have.property "gertuprice", deal.gertuprice
            deals[0].should.have.property "discount", deal.discount
            deals[0].should.have.property "shop", deal.shop
            deals[0].should.have.property "categoryname", deal.categoryname
            deals[0].should.have.property "quantity", deal.quantity
            done()

        it "should update data correctly", (done) ->
          deal.name = 'Deal name update'
          deal.save()
          done()

      after (done) ->
        Deal.remove().exec()
        User.remove().exec()
        Shop.remove().exec()
        done()