_           = require 'underscore'
mongoose    = require 'mongoose'

User        = mongoose.model 'User'
Deal        = mongoose.model 'Deal'
Token       = mongoose.model 'Token'
Reservation = mongoose.model 'Reservation'

exports.usersLogin = (req, res) ->

  User.findOne({email: req.body.email}).exec( (err, userData) ->

    if err? or not userData?
      res.status(403).send('Access denied. No such user.')
    else

      if userData.authenticate(req.body.password)
        token = new Token()

        token.token = userData._id
        token.user = userData
        token.last_access = new Date()

        token.save( (err) ->

          res.status(200).send(JSON.stringify(userData)) unless err?
          res.status(403).send('Unable to set up token') if err?
          )
      else
        res.status(403).send('Incorrect credentials')
  )

exports.usersLogout = (req, res) ->
  currentUser = req.currentMobileUser

  Token.remove({token: currentUser._id}).exec( (err) ->
    res.status(200).send() unless err?
    res.status(404).send('No token found') if err?
  )


exports.usersSignUp = (req, res) ->
  user = new User(req.body)
  user.password = req.body.password

  user.save( (error) ->

    if error
      if error.code is 11000 # email in use (duplicate)
        res.status(409).send(JSON.stringify(error.code))
      else
        res.status(422).send(JSON.stringify(error.code))
    else
      res.status(200).send(JSON.stringify(user))
  )

exports.usersGetCurrent = (req, res) ->
  currentUser = req.currentMobileUser

  if currentUser?
    res.
      status(200).
      send(JSON.stringify(currentUser))
  else
    res.
      status(404).
      send()

exports.usersUpdate = (req, res) ->

  user = req.currentMobileUser

  if user?
    User.findOne({_id: user.id}).exec( (err, userData) ->

      if err? or not userData?
        res.status(403).send('Access denied')
      else

        userData.firstName = req.body.firstName
        userData.lastName = req.body.lastName
        userData.email = req.body.email

        userData.save (err) ->

          if err?
            res.
            status(500).
            send(JSON.stringify(err))
          else
            req.session.user =
                id: userData._id,
                name: userData.name,
                email: userData.email,
                isAuthenticated: true

            res.
              status(200).
              send(JSON.stringify(userData))
     )
  else
    res.
      status(404).
      send()

exports.dealsGetAll = (req, res) ->
  Deal.find().sort('-created').populate("shop").exec (err, deals) ->
    if err
      res.status(500).send()
    else
      res.status(200).send(JSON.stringify(deals))

exports.dealsGetAllByPositition = (req, res) ->
  user = req.currentMobileUser

  nearbyDeals = []

  userradius = user.radius / 1000

  mongoose.connection.db.executeDbCommand
    # the mongo collection
    geoNear: "shops"

    # the geo point
    near: [parseFloat(req.body.longitude), parseFloat(req.body.latitude)]

    # tell mongo the earth is round, so it calculates based on a spherical location system
    spherical: true

    # tell mongo how many radians go into one kilometer.
    distanceMultiplier: 6371

    # tell mongo the max distance in radians to filter out
    maxDistance: userradius / 6371
  , (err, result) ->

    nearshops = result.documents[0].results
    nearshopids = []

    if nearshops?

      for shop in nearshops
        nearshopids.push(shop.obj._id)

      Deal.find({shop: { $in:nearshopids}}).exec (err,deals) ->

        for deal in deals
          for shop in nearshops
            if deal.shop.equals(shop.obj._id)
              nearbyDeals.push(
                dist: shop.dis
                deal: deal
              )

        nearbyDeals.sort (a, b) ->
          a.dist - b.dist

        res.status(200).send(JSON.stringify(nearbyDeals))

exports.dealsGetById = (req, res) ->

  id = req.params.id

  Deal.findOne({_id: id}).exec (err, deal) ->

    if err? or not deal?
      res.status(404).send()
    else
      res.status(200).send(JSON.stringify(deal))

exports.dealsMakeReservationById = (req, res) ->

  user = req.currentMobileUser

  dealId = req.params.id

  Deal.findOne({_id: dealId}).exec( (err, deal) ->

    if not error? and deal?

      if deal.quantity <= 0
        res.status(410).send('No more items allowed for this deal')
      else
        reservation = new Reservation()
        reservation.deal = deal._id
        reservation.user = user._id

        reservation.save (err) ->

          deal.quantity--

          deal.save ((err) ->

            res.status(200).send(JSON.stringify(reservation)) unless error?
            res.status(500).send('Error updateing deal') if error?
            )
    else
      res.status(404).send('Deal not found')
    )



exports.dealsAddComment = (req, res) ->

  user = req.currentMobileUser

  dealId = req.params.id

  if req.body.comment? and req.body.rating?
    Deal.findOne({_id: dealId}).exec( (err, deal) ->

      if deal?

        if not deal.comments?
          deal.comments = []

        deal.comments.push({
          author : user,
          description : req.body.comment,
          writedAt : new Date(),
          rating : req.body.rating
          })

        deal.save()

        res.status(200).send(deal)

      else
        res.status(404).send('Deal not found')
      )
  else
    res.status(400).send('Comments and rating are compulsory')


exports.reservationsGetAll = (req, res) ->

  user = req.currentMobileUser

  Reservation.find({user: user}).populate('user').exec( (err, reservations) ->

    res.status(200).send(JSON.stringify(reservations)) unless err?
    res.status(404).send('Deal not found') if err?
  )
