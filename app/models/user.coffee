class User extends Backbone.Model
  initializer: ->
    # ...

  getName: ->
    @get('jid').replace /@.+/, ''

  getStatus: ->
    (@get('status') + "").replace(/<.+?>/g,'')
    
  getAvatar: ->
    if @get('jid').match /@buddycloud/
      "http://media.buddycloud.com/channel/54x54/buddycloud.com/#{@getName()}.png"
    else
      'http://www.gravatar.com/avatar/' + hex_md5(@get('jid') + "?d=mm")
    
this.User = User

class UserCollection extends Backbone.Collection
  model: User
  
  findByJid : (jid) ->
    @find (user) ->
      user.get('jid') == jid
  # comparator: (post) ->
  #   post.get('published')
  
this.Users = new UserCollection