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
    @get('author').getName()

  getAuthorAvatar: ->
    @get('author').getAvatar()
    
  send: ->
    if @valid()
      $c.sendPost(this)
    else
      # console.log "not sending.. seems invalid."
    
this.Post = Post

class PostCollection extends Backbone.Collection
  model: Post
  
  comparator: (post) ->
    post.get('published')
  
this.Posts = new PostCollection