class WelcomeController extends Backbone.Controller
  routes :
    "" : "index"
    
  index: ->
    new WelcomeIndexView
    new UsersListView { collection : Users }
    
new WelcomeController
