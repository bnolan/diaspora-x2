class Post extends Backbone.Model
  initializer: ->
    # ...

  isReply: ->
    (typeof @get('in_reply_to') == 'string') and (@get('in_reply_to') != "")
    
  hasGeoloc: ->
    (typeof @get('geoloc_text') == 'string') and (@get('geoloc_text') != "")
    
  getReplies: ->
    _ Posts.filter( (post) =>
      post.get('in_reply_to') == @id
    )
    
  getAuthorName: ->
    @get('author').replace /@.+/, ''

  getAuthorAvatar: ->
    if @get('author').match /@buddycloud/
      "http://media.buddycloud.com/channel/54x54/buddycloud.com/#{@getAuthorName()}.png"
    else
      'http://www.gravatar.com/avatar/' + hex_md5(@get('author'))
    
this.Post = Post

class PostCollection extends Backbone.Collection
  model: Post
  
  comparator: (post) ->
    post.get('published')
  
this.Posts = new PostCollection