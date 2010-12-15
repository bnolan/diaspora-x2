class Post extends Backbone.Model
  initializer: ->
    # ...

this.Post = Post

class PostCollection extends Backbone.Collection
  model: Post
  
  comparator: (post) ->
    post.get('published')
  
this.Posts = new PostCollection