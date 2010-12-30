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

    @collection.bind 'add', @render
    @collection.bind 'change', @render
    @collection.bind 'remove', @render
    @collection.bind 'refresh', @render

    @render()
    
  render: =>
    @el.html(@template( { channels : @collection }))
    @delegateEvents()

@ChannelsListView = ChannelsListView