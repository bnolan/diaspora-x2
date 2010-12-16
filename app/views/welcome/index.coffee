class WelcomeIndexView extends Backbone.View
  initialize: ->
    new CommonPageView
    new UsersListView { collection : Users }

    @el = $("#main") # app.activePage()

    @collection = Posts
    
    @template = _.template('''

      <form action="#" class="new_activity status">
        <h4>What are you doing now?</h4>
        <textarea cols="40" id="activity_content" name="content" rows="20"></textarea>
        <input name="commit" type="submit" value="Share" />
      </form>
        
      <% posts.each(function(post){ %>

        <div class="activity">
          <div class="grid_1">
            <img class="thumb avatar" src="<%= post.getAuthorAvatar() %>" />
          </div>
          <div class="grid_5">
            <h4>
              <a href="#"><%= post.getAuthorName() %> </a>
            </h4>
            <p class="content">
              <%= post.get('content') %>
            </p>
            <p class="meta">
              <span class='timeago' title='<%= post.get('published') %>'><%= post.get('published') %></span> |
              <a href="http://diaspora-x.com/activities/196/like">Like</a> | <a href="#" onclick="$(this).parents('.activity').find('form').show().find('textarea').focus(); return false">Comment</a>
              <% if(post.hasGeoloc()){ %>
                | <%= post.get('geoloc_text') %>
              <% } %>
            </p>
          
            <% if(post.hasReplies()){ %>
            
              <div class="comments">
                <div class="chevron">&diams;</div>

                <% post.getReplies().each(function(reply){ %>
                  <div class="comment">
                    <img class="micro avatar" src="<%= reply.getAuthorAvatar() %>" />
                    <p class="content">
                      <a href="#"><%= reply.getAuthorName() %></a> <%= reply.get('content') %>
                    </p>
                    <span class="meta">
                      <span class='timeago' title='<%= reply.get('published') %>'><%= post.get('published') %></span>
                      <% if(reply.hasGeoloc()){ %>
                        | <%= reply.get('geoloc_text') %>
                      <% } %>
                    </span>
                  </div>
                <% }); %>
              
              </div>
            <% }; %>
            
          </div>
          
          
          <div class="clear"></div>
        </div>

      <% }); %>
    ''')

    @collection.bind 'add', @render
    @collection.bind 'change', @render
    @collection.bind 'remove', @render
    @collection.bind 'refresh', @render

    @render()
  
  events: {
    'submit form' : 'submit'
  }
  
  submit: (e) ->
    e.preventDefault()

    post = new Post {
      content : @el.find('textarea:first').val()
      in_reply_to : null
      channel : app.currentUser.channelId()
      author : app.currentUser.get('jid')
    }

    window.$p = post
    
    $c.sendPost(post) # .save()
    
  # 
  # select: (e) ->
  #   @el.find('a').removeClass 'active'
  #   $(e.currentTarget).addClass 'active'

  # Render the content
  
  getPosts: ->
    _ @collection.reject((post) ->
      post.isReply()
    ).reverse()
    
  render: =>
    @el.html(@template( { posts : @getPosts() })).find('.timeago').timeago()
    @delegateEvents()

@WelcomeIndexView = WelcomeIndexView