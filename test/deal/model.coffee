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
        name  : "Deal name"
        price : 45
        image : "/img/deals/img1.jpg"
        shop  : "524f36e34ca6e9c82a000001"
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
        Deal.find { name: 'Deal name'}, (error, deals) ->
          deals[0].should.have.property "image", deal.image
          deals[0].should.have.property "shop", deal.shop
          done()

      it "should update data correctly", (done) ->
        deal.name = 'Deal name update'
        deal.save done



    after (done) ->
      Deal.remove().exec()
      done()