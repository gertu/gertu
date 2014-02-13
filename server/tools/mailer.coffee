nodemailer = require "nodemailer"
fs         = require "fs"
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

  Mailer.sendTemplate = (to, subject, templateName, variables , onSuccess, onError) ->

    templatePath = __dirname + '../../../views/mailer/' + templateName + '.html'

    fs.readFile templatePath,
      'utf8'
      (err, data) ->
        htmlContent = data + ''

        if err and onError?

          onError (err)

        else if variables

          for key of variables
            onError(key)
            htmlContent = htmlContent.replace '{{' + key + '}}', variables[key]

        Mailer.send to, subject, htmlContent, onSuccess, onError


  Mailer.send = (to, subject, body, onSuccess, onError) ->

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
      if error and onError?
        onError(error)
      else if onSuccess? and onSuccess?
        onSuccess()

  module.exports = Mailer
)()