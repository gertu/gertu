should   = require "should"
Mailer   = require "../../server/tools/mailer"

describe "<Unit Test>", ->
  describe "Mail sender module:", ->

    destinationEmail = 'mail@gertuproject.info'

    before (done) ->
      
      done()

    describe "The mail module", ->
    
      it "should be send it to address " + destinationEmail, (done) ->

        Mailer.send destinationEmail,
          'This is test#1',
          'Body for test#1',
          () =>
            console.log 'mail sent success'
            done()
          (error) =>
            console.log error

      it "should send email to address " + destinationEmail + ' from a template without replacing anything', (done) ->

        Mailer.sendTemplate destinationEmail,
          'This is test#2',
          'testMail',
          null,
          () =>
            console.log 'mail sent success'
            done()
          (error) =>
            console.log error

      it "should send email to address " + destinationEmail + ' from a template replacing fields', (done) ->

        fields = {
          emailTest: 'text replaced in test'
        }
        Mailer.sendTemplate destinationEmail,
          'This is test#3',
          'testMail',
          fields,
          () =>
            console.log 'mail sent success'
            done()
          (error) =>
            console.log error

    after (done) ->
      
      done()


