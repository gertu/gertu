mongoose  = require "mongoose"
Path     = require "path"
fs       = require "fs"
Shop      = mongoose.model "Shop"
Deal      = mongoose.model "Deal"
DealCategory = mongoose.model "DealCategory"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  Deal.find({shop: shopId}).populate('shop').exec (err, deals) ->
    res.render 'pages/shopmanagement/deals/list', {deals: deals, currentShop: req.session.currentShop}

exports.create = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
  
  DealCategory.find().sort('name').exec( (err, categories ) ->
    res.render 'pages/shopmanagement/deals/create',
      {
        esNueva: true,
        actionUrl: '/shopmanagement/deals/new',
        deal: {_id: 0, name: ''},
        categories: categories,
        days: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
        currentShop: req.session.currentShop
      }
  )

exports.createDo = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
  file = req.files.image
  name = file.name
  type = file.type
  path = __dirname + "/public/upload/" + name
  format = type.split("/")
  if format[1] is "jpg" or format[1] is "jpeg" or format[1] is "png" or format[1] is "gif"
    fs.rename req.files.image.path, path, (err) ->
  
      Shop.findOne({_id: shopId}).exec (err, shop) ->

        if shop
          splittednewname = (file.path).split("/")
          image = "/upload/" + splittednewname[splittednewname.length-1]
          deal = new Deal
            shop: shop
            name : req.body.name
            description: req.body.description
            categoryname: req.body.categoryname
            price: req.body.price
            gertuprice: req.body.gertuprice
            discount: req.body.discount
            datainit: req.body.datainit
            dataend: req.body.dataend
            selecteddays: req.body.selecteddays
            quantity: req.body.quantity
            image: image

          deal.save (err) ->
            if not err
              res.redirect 'shopmanagement/deals/list'
            else
              console.log err
              res.redirect 'shopmanagement/deals/list'
      
   else
    fs.unlink file.path
    res.render "shopmanagement/deals/edit",
    {errorMsg: 'El formato debe ser jpg, png o gif', deal: dealId }

exports.edit = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
  
  Deal.findOne({_id: req.params.dealId}).exec( (err, deal) ->
   
    DealCategory.find().sort('name').exec( (err, categories ) ->
      res.render 'pages/shopmanagement/deals/create',
        {
          esNueva: false,
          actionUrl: '/shopmanagement/deals/edit',
          deal: deal,
          categories: categories,
          days: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
          currentShop: req.session.currentShop
        }
      )
  )
  
exports.editDo = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId
  file = req.files.image
  name = file.name
  type = file.type
  path = __dirname + "/public/upload/" + name
  format = type.split("/")

  if format[1] is "jpg" or format[1] is "jpeg" or format[1] is "png" or format[1] is "gif"
    fs.rename req.files.image.path, path, (err) ->
      

      Deal.findOne({_id: req.body.id}).exec (err, deal) ->

        Shop.findOne({_id: shopId}).exec (err, shop) ->

          if shop
            fs.unlink Path.resolve(".") + deal.image
            splittednewname = (file.path).split("/")
            deal.image = "/upload/" + splittednewname[splittednewname.length-1]
            deal.shop = shop
            deal.name = req.body.name
            deal.description = req.body.description
            deal.categoryname = req.body.categoryname
            deal.price = req.body.price
            deal.gertuprice = req.body.gertuprice
            deal.discount = req.body.discount
            deal.datainit = req.body.datainit
            deal.dataend = req.body.dataend
            deal.selecteddays = req.body.selecteddays
            deal.quantity = req.body.quantity

            deal.save (err) ->
              if not err
                res.redirect 'shopmanagement/deals/list'
              else
                console.log err
                res.redirect 'shopmanagement/deals/list'
            
  else
    fs.unlink file.path
    res.render "shopmanagement/deals/edit",
    {
      errorMsg: 'El formato debe ser jpg, png o gif', 
      deal: dealId, 
      currentShop: req.session.currentShop 
    }

 