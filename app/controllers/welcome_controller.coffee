class WelcomeController extends Backbone.Controller
  routes :
    "" : "index"
    "home" : "home"
    
  index: ->
    if localStorage['jid'] && localStorage['password']
      app.connect()
    else
      window.location.hash = "login"
    
  home: ->
    $("#spinner").remove()
    new WelcomeIndexView
    
new WelcomeController
