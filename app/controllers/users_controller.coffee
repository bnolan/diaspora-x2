class UsersController extends Backbone.Controller
  routes :
    "users/:jid" : "show"
    "users/:jid/subscribe" : "subscribe"
    
  subscribe: (jid) ->
    user = Users.findOrCreateByJid(jid)
    user.subscribe()
    window.location.hash = "#users/#{user.get('jid')}"
    
  show: (jid) ->
    user = Users.findOrCreateByJid(jid)
    user.fetchPosts()
    new UsersShowView { model : user }
    
new UsersController
