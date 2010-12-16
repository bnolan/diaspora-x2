class AuthController extends Backbone.Controller
  routes :
    "login" : "login"
    "logout" : "logout"
    
  logout: ->
    app.signout()
    
  login: ->
    $("#spinner").remove()
    new AuthLoginView

new AuthController
