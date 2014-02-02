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
            done()
          (error) =>
            done() unless error

      it "should send email to address " + destinationEmail + ' from a template without replacing anything', (done) ->

        Mailer.sendTemplate destinationEmail,
          'This is test#2',
          'testMail',
          null,
          () =>
            done()
          (error) =>
            done() unless error

      it "should send email to address " + destinationEmail + ' from a template replacing fields', (done) ->

        fields =
          emailTest: 'text replaced in test'
        
        result = Mailer.sendTemplate destinationEmail,
          'This is test#3',
          'testMail',
          fields,
          () =>
            done()
          (error) =>
            done() unless error
            

    after (done) ->
      
      done()


