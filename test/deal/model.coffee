should   = require "should"
app      = require "../../server"
mongoose = require "mongoose"
Deal     = mongoose.model "Deal"

deal  = undefined


describe "<Unit Test>", ->
  describe "Model Deal:", ->
    before (done) ->
      Deal.remove().exec()

      deal = new Deal(
        name: "Deal name"
        description: "This is description"
        price: 100
        gertuprice: 50
        discount:  50
        shop: "524f36e34ca6e9c82a000001"
        categoryname : "Restaurantes"
        quantity: 20
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
        Deal.find { shop: "524f36e34ca6e9c82a000001"}, (error, deals) ->
          deals[0].should.have.property "name", deal.name
          deals[0].should.have.property "description", deal.description
          deals[0].should.have.property "price", deal.price
          deals[0].should.have.property "gertuprice", deal.gertuprice
          deals[0].should.have.property "discount", deal.discount
          deals[0].should.have.property "categoryname", deal.categoryname
          deals[0].should.have.property "quantity", deal.quantity
          done()

      it "should update data correctly", (done) ->
        deal.name = 'Deal name update'
        deal.save done



    after (done) ->
      Deal.remove().exec()
      done()