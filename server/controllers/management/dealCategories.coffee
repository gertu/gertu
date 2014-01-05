mongoose     = require 'mongoose'
DealCategory = mongoose.model 'DealCategory'

exports.list = (req, res) ->
  DealCategory.find({}).exec( (err, categories) ->
    if err
      res.status(500).send('Database error')
    else
      res.render 'pages/management/deal-categories/list', {categories: categories}
  )

exports.add = (req, res) ->
  category = {_id: 0, name: ''}
  res.render 'pages/management/deal-categories/edit', {category: category}

exports.edit = (req, res) ->

  id = req.params.id

  DealCategory.findOne({_id: id}).exec( (err, category) ->
    if err
      res.status(404)
    else
      res.render 'pages/management/deal-categories/edit', {category: category}
  )

exports.editDo = (req, res) ->

  id = req.params.id
  name = req.body.name

  if id == '0'
    category = new DealCategory({name: name})
    category.save(() ->
      res.redirect '/management/deal-categories/list?rnd=' + Math.random()
    )
  else
    DealCategory.findOne({_id: id}).exec( (err, category) ->
      if err
        res.status(404)
      else
        category.name = name
        category.save(() ->
          res.redirect '/management/deal-categories/list?rnd=' + Math.random()
        )
    )

exports.remove = (req, res) ->

  id = req.params.id

  DealCategory.findOne({_id: id}).exec( (err, category) ->
    if err
      res.status(404)
    else
      res.render 'pages/management/deal-categories/remove', {category: category}
  )

exports.removeDo = (req, res) ->

  id = req.params.id

  DealCategory.findOne({_id: id}).exec( (err, category) ->
    if err
      res.status(404)
    else
      category.remove(()->
        res.redirect '/management/deal-categories/list?rnd=' + Math.random()
      )

  )