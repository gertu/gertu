exports.show = (req, res) ->

  mainMenu = options: [
    name: 'Deal categories'
    url: 'management/deal-categories/list'
  ,

  ]

  res.render "pages/management/dashboard", mainMenu