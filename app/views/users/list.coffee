class UsersListView extends Backbone.View
  initialize: ->
    @el = $("#friends-list")

    @template = _.template('''
      <% users.each(function(user){ %>
        <li>
          <img class="micro avatar" src="<%= user.getAvatar() %>" />
          <b><a href="#"><%= user.getName() %></a></b>
            - <span class="status"><%= user.getStatus() %></span>
        </li>
      <% }); %>
    ''')

    @collection.bind 'add', @render
    @collection.bind 'change', @render
    @collection.bind 'remove', @render
    @collection.bind 'refresh', @render

    @render()
    
  render: =>
    @el.html(@template( { users : @collection }))
    @delegateEvents()

@UsersListView = UsersListView