class Post extends Backbone.Model
  initializer: ->
    # ...

  isReply: ->
    (@get('in_reply_to') != undefined) and (!isNaN(@get('in_reply_to')))
    
  hasGeoloc: ->
    (typeof @get('geoloc_text') == 'string') and (@get('geoloc_text') != "")

  isUserChannel: ->
    @get('channel').match /^.user/
  hasReplies: ->
    @getReplies().any()
    
  getReplies: ->
    _ Posts.filter( (post) =>
      post.get('in_reply_to') == @id
    )
    
  valid: ->
    @_validate(@attributes) == true
    
  _validate: (attributes) ->
    if (typeof attributes.content != 'string') or (attributes.content == "")
      "Can't have empty content"
    else
      true
      
  getAuthorName: ->
    @get('author').replace /@.+/, ''

  getAuthorAvatar: ->
    if @get('author').match /@buddycloud/
      "http://media.buddycloud.com/channel/54x54/buddycloud.com/#{@getAuthorName()}.png"
    else
      "http://www.gravatar.com/avatar/#{hex_md5(@get('author'))}?d=http://media.buddycloud.com/channel/54x54/buddycloud.com/welcome.bot.png"
    
this.Post = Post

class PostCollection extends Backbone.Collection
  model: Post
  
  comparator: (post) ->
    post.get('published')
  
this.Posts = new PostCollection