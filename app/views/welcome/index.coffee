class WelcomeIndexView extends Backbone.View
  initialize: ->
    @el = $("#main") # app.activePage()

    @collection = Posts
    
    @template = _.template('''
      <h1>Demo...</h1>
      
      <p>
        <a href="#maps-new">Add</a>
      </p>

      <% posts.each(function(post){ %>

        <div class="activity">
          <div class="grid_1">
            <img alt="6b862df3f900637ac05f2cc77f940548?d=mm" class="thumb avatar" src="http://www.gravatar.com/avatar/6b862df3f900637ac05f2cc77f940548?d=mm">
          </div>
          <div class="grid_5">
            <h4>
              <a href="/users/184"><%= post.get('author') %> </a>
            </h4>
            <p class="content">
              <%= post.get('content') %>
            </p>
            <p class="meta">
              <%= post.id %> | 
              <span class='timeago' title='<%= post.get('published') %>'><%= post.get('published') %></span> |
              <a href="http://diaspora-x.com/activities/196/like">Like</a> | <a href="#" onclick="$(this).parents('.activity').find('form').show().find('textarea').focus(); return false">Comment</a>
            </p>
          </div>
          
          <div class="clear"></div>
        </div

      <% }); %>
    ''')

    @collection.bind 'add', @render
    @collection.bind 'change', @render
    @collection.bind 'remove', @render
    @collection.bind 'refresh', @render

    @render()
  
  # events: {
  #   'mousedown a' : 'select'
  # }
  # 
  # select: (e) ->
  #   @el.find('a').removeClass 'active'
  #   $(e.currentTarget).addClass 'active'

  # Render the content
  render: =>
    @el.html(@template( { posts : @collection })).find('.timeago').timeago()
    @delegateEvents()

@WelcomeIndexView = WelcomeIndexView