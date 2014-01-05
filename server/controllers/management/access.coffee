exports.login = (req, res) ->
  res.render "pages/management/access/login", {errorMsg: ''}

exports.loginDo = (req, res) ->
  email = req.body.email
  password = req.body.password

  if email == 'mail@mail.com' and password == '1234'
    res.redirect "/management/dashboard"
  else if email == '' or password == ''
    res.render "pages/management/access/login", {errorMsg: 'Both email and password should be provided'}
  else
    res.render "pages/management/access/login", {errorMsg: 'User does not exist'}