class CommonAuthView extends Backbone.View
  initialize: ->
    @el = $("#auth-container")

    @template = _.template('''
      <div class="auth">
        <img src="<%= user.getAvatar() %>" class="micro avatar">
        <a class="name" href="#"><%= user.get('jid') %></a>

        <a href="#logout" class="signout">Log out</a>
      </div>
    ''')

    @render()
    
  render: =>
    @el.html(@template( { user : app.currentUser } ))
    @delegateEvents()

@CommonAuthView = CommonAuthView

