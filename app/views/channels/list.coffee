class ChannelsListView extends Backbone.View
  initialize: ->
    @el = $("#channels-list")

    @template = _.template('''
      <% channels.each(function(channel){ %>
        <li>
          <b><a href="#channels/<%= channel.getName() %>"><%= channel.getName() %></a></b>
        </li>
      <% }); %>
    ''')

    Channels.bind 'add', @render
    Channels.bind 'change', @render
    Channels.bind 'remove', @render
    Channels.bind 'refresh', @render

    @render()
    
  render: =>
    @el.html(@template( { channels : @collection }))
    @delegateEvents()

@ChannelsListView = ChannelsListView