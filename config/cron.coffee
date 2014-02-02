mongoose = require 'mongoose'
Currency = mongoose.model 'Currency'
http     = require('http')
async    = require('async')
cronJob  = require("cron").CronJob

job = new cronJob(
  # every 10 seconds
  # cronTime: "*/10 * * * * *" # Every day at 00:00.00
  cronTime: "0 0 0 * * *" # Every day at 00:00.00
  onTick: ->
    
    Currency.find({}).exec( (err, currencies) ->
      if err
        console.log err
      else

        count = 0
        async.whilst (->
          count < currencies.length
        ), ((callback) ->

          currency = currencies[count]

          options =
            host: "rate-exchange.appspot.com"
            path: "/currency?from=" + currency.code + "&to=EUR"
            port: 80
            method: "GET"

          request = http.request(options, (response) ->
            conversionInfo = ''
            response.on "data", (data) ->
              conversionInfo += data

            response.on "end", ->
              currency.conversionRate = parseFloat(JSON.parse(conversionInfo).rate)


              console.log currency
              console.log JSON.parse(conversionInfo).rate

              currency.save()
          )
          request.on "error", (err) ->
            console.log "Problem with request: " + err.message

          request.end()

          count++
          callback()
        ), (err) ->
          @
      )

    true
  start: false
  timeZone: "America/Los_Angeles"
)

job.start()