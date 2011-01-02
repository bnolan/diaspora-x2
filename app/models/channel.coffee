class Channel extends Backbone.Model
  initializer: ->
    # ...
    
  # The node id of this chanel
  getNode: ->
    @get('node')
    
  fetchPosts: ->
    $c.getChannel @getNode()
    $c.getMetaData this
    
  getName: ->
    @get('node').replace(/.+\//,'')
    
this.Channel = Channel

class ChannelCollection extends Backbone.Collection
  model: Channel
  
  findByNode : (node) ->
    @find (channel) ->
      channel.get('node') == node
      
  findOrCreateByNode : (node) ->
    channel = null
    
    if @findByNode(node)
      channel = @findByNode(node)
    else
      channel = new Channel {
        node : node
      }
      @add channel

    channel

  # comparator: (post) ->
  #   post.get('published')
  
this.Channels = new ChannelCollection