class UsersController extends Backbone.Controller
  routes :
    "users/:jid" : "show"
    
  show: (jid) ->
    user = Users.findByJid(jid)
    user.fetchPosts()
    new UsersShowView { model : user }
    
new UsersController
