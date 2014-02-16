should   = require "should"
Mailer   = require "../../server/tools/mailer"
config   = require("./../../config/config")

describe "Mail sender module:", ->
  
  destinationEmail = 'mail@gertuproject.info'

  before (done) ->
    done()

  it "should be send it to address " + destinationEmail, (done) ->
    if config.mail.accountPassword.indexOf('*') == -1
      Mailer.send destinationEmail,
        'This is test#1',
        'Body for test#1',
        () =>
          done()
        (error) =>
          @
    else
      done()

  it "should send email to address " + destinationEmail + ' from a template without replacing anything', (done) ->
    if config.mail.accountPassword.indexOf('*') == -1
      Mailer.sendTemplate destinationEmail,
        'This is test#2',
        'testMail',
        null,
        () =>
          done()
        (error) =>
          @
    else
      done()

  it "should send email to address " + destinationEmail + ' from a template replacing fields', (done) ->
    if config.mail.accountPassword.indexOf('*') == -1
      fields =
        emailTest: 'text replaced in test'
      
      result = Mailer.sendTemplate destinationEmail,
        'This is test#3',
        'testMail',
        fields,
        () =>
          done()
        (error) =>
          @
    else
      done()

  after (done) ->
    done()