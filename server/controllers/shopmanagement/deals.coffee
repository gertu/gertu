mongoose  = require "mongoose"
Path     = require "path"
fs       = require "fs"
Shop      = mongoose.model "Shop"
Deal      = mongoose.model "Deal"
DealCategory = mongoose.model "DealCategory"

exports.list = (req, res) ->
  shopId = req.session.currentShop.shopId

  error = null

  if req.query.error == '1'
    error = 'No puede añadir ofertas porque no ha rellenado todos los datos de facturación'

  pageNumber = 1
  if req.query.page?
    pageNumber = req.query.page
  pageSize = 5
  skipItems = (pageNumber - 1) * pageSize

  Deal.find({shop: shopId}).skip(skipItems).limit(pageSize).populate('shop').exec (err, deals) ->

    Deal.count({shop: shopId}).exec (err, count) ->

      numberOfPages = count / pageSize

      res.render 'pages/shopmanagement/deals/list',
        {
          error: error,
          deals: deals,
          pages: numberOfPages,
          pageCurrent: pageNumber,
          currentShop: req.session.currentShop
        }

exports.create = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId

  Shop.findOne({_id: shopId}).exec (err, shop) ->

    if shop.hasCreditCardInfo() == true

      deal = new Deal
        _id: 0
        shop: shop
        name : ''
        description: ''
        categoryname: ''
        price: 0
        gertuprice: 0
        discount: 0
        datainit: new Date()
        dataend: new Date()
        selecteddays: []
        quantity: 0
        image: null

      DealCategory.find().sort('name').exec( (err, categories ) ->
        res.render 'pages/shopmanagement/deals/create',
          {
            esNueva: true,
            actionUrl: '/shopmanagement/deals/new',
            deal: deal,
            categories: categories,
            days: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
            currentShop: req.session.currentShop
          }
      )

    else
      res.redirect 'shopmanagement/deals/list?error=1'

exports.createDo = (req, res) ->

  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId

  file = req.files.image
  name = file.name
  type = file.type
  path = __dirname + "/public/upload/" + name
  format = type.split("/")

  partsOfInitDate = req.body.datainit.split('/')
  initDate = new Date(partsOfInitDate[2], partsOfInitDate[1]-1, partsOfInitDate[0])

  partsOfEndDate = req.body.dataend.split('/')
  endDate = new Date(partsOfEndDate[2], partsOfEndDate[1]-1, partsOfEndDate[0])

  deal = new Deal
    name : req.body.name
    description: req.body.description
    categoryname: req.body.categoryname
    price: req.body.price
    gertuprice: req.body.gertuprice
    discount: req.body.discount
    datainit: initDate
    dataend: endDate
    selecteddays: req.body.selecteddays
    quantity: req.body.quantity

  if format[1] is "jpg" or format[1] is "jpeg" or format[1] is "png" or format[1] is "gif"
    fs.rename req.files.image.path, path, (err) ->

      Shop.findOne({_id: shopId}).exec (err, shop) ->

        if shop

          if file.path.indexOf('/') > -1
            splittednewname = (file.path).split('/')
          else
            splittednewname = (file.path).split('\\')

          deal.shop = shop
          deal.image = '/upload/' + splittednewname[splittednewname.length-1]

          console.log deal

          deal.save (err) ->
            console.log err
            res.redirect 'shopmanagement/deals/list'

   else
    fs.unlink file.path

    DealCategory.find().sort('name').exec( (err, categories ) ->

      res.render 'pages/shopmanagement/deals/create',
        {
          esNueva: true,
          actionUrl: '/shopmanagement/deals/new',
          errorType: 1
          deal: deal,
          categories: categories,
          days: ['Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
          currentShop: req.session.currentShop
        }
    )

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

            splittednewname = null

            if file.path.indexOf('/') > -1
              splittednewname = (file.path).split('/')
            else
              splittednewname = (file.path).split('\\')

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
    res.render "pages/shopmanagement/deals/create",
    {
      errorType: 1,
      deal: dealId,
      currentShop: req.session.currentShop
    }

exports.delete = (req, res) ->
  shopId = req.session.currentShop.shopId
  dealId = req.params.dealId

  Deal.findOne({_id: req.params.dealId}).exec (err, deal) ->

    res.render 'pages/shopmanagement/deals/delete',
      {
        deal: deal,
        currentShop: req.session.currentShop
      }

exports.deleteDo = (req, res) ->
  shopId = req.session.currentShop.shopId
  console.log(shopId)
  Deal.findOne({_id: req.body.id}).exec (err, deal) ->
    deal.remove (err) ->
      if err
        res.render "error",
          status: 500
      else
        res.redirect 'shopmanagement/deals/list'