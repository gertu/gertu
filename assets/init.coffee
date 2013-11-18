window.bootstrap = ->
  angular.bootstrap document, ["mean"]

window.init = ->
  window.bootstrap()

angular.element(document).ready ->

  #Then init the app
  window.init()
