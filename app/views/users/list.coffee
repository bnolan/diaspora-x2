class UsersListView extends Backbone.View
  initialize: ->
    @el = $("#friends-list")

    @template = _.template('''
      <% _(users).each(function(user){ %>
        <li>
          <img class="micro avatar" src="<%= user.getAvatar() %>" />
          <b><a href="#users/<%= user.get('jid') %>"><%= user.getName() %></a></b>
            - <span class="status"><%= user.getStatus() %></span>
        </li>
      <% }); %>
    ''')

    Users.bind 'add', @render
    Users.bind 'change', @render
    Users.bind 'remove', @render
    Users.bind 'refresh', @render

    @render()
    
  render: =>
    @el.html(@template( { users : @collection }))
    @delegateEvents()

@UsersListView = UsersListView