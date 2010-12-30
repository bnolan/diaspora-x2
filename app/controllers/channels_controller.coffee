class ChannelsController extends Backbone.Controller
  routes :
    "channels/:node" : "show"
    
  show: (node) ->
    channel = Channels.findOrCreateByNode("/channel/#{node}")
    channel.fetchPosts()
    new ChannelsShowView { model : channel }
        
new ChannelsController
