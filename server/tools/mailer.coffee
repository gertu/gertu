nodemailer = require "nodemailer"
config     = require("../../config/config")

(->
  Mailer = {
    host : config.mail.host,
    usesSecureConnection : config.mail.secureConnection,
    port : config.mail.mailPort,
    user : config.mail.accountUser,
    password : config.mail.accountPassword,
    from : config.mail.accountFrom
  }

  Mailer.send = (to, subject, body) ->

    mailsender = nodemailer.createTransport("SMTP",
      host: Mailer.host
      secureConnection: Mailer.usesSecureConnection
      port: Mailer.port
      auth:
        user: Mailer.user
        pass: Mailer.password
    )

    mailOptions =
      from: Mailer.from
      to: to
      subject: subject
      html: body

    mailsender.sendMail mailOptions, (error) ->
      if error
        console.log error
      else
        console.log "Mail sent to " + mailOptions.to

  module.exports = Mailer
)()