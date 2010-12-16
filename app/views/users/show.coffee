class UsersShowView extends Backbone.View
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
              <a href="#users/<%= post.get('author').get('jid') %>"><%= post.getAuthorName() %> </a>
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
              | <%= post.id %>
            </p>
          
            <% if(post.hasReplies()){ %>
            
              <div class="comments">
                <div class="chevron">&diams;</div>

                <% post.getReplies().each(function(reply){ %>
                  <div class="comment">
                    <img class="micro avatar" src="<%= reply.getAuthorAvatar() %>" />
                    <p class="content">
                      <a href="#users/<%= reply.get('author').get('jid') %>"><%= reply.getAuthorName() %></a> <%= reply.get('content') %>
                    </p>
                    <span class="meta">
                      <span class='timeago' title='<%= reply.get('published') %>'><%= post.get('published') %></span>
                      <% if(reply.hasGeoloc()){ %>
                        | <%= reply.get('geoloc_text') %>
                      <% } %>
                      | <%= reply.id %>
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
    'keydown textarea' : 'keydown'
  }
  
  keydown: (e) ->
    if ((e.metaKey || e.shiftKey) && e.keyCode == 13)
      $(e.currentTarget).parents("form").submit();
      e.preventDefault();
    
  submit: (e) ->
    e.preventDefault()

    post = new Post {
      content : @el.find('textarea:first').val()
      in_reply_to : null
      channel : app.currentUser.channelId()
      author : app.currentUser.get('jid')
    }

    window.$p = post
    
    $c.sendPost(post)
  
  getPosts: ->
    _ @collection.select((post) =>
      (!post.isReply()) && (post.get('author').get('jid') == @model.get('jid'))
    ).reverse()
    
  render: =>
    @el.html(@template( { posts : @getPosts() })).find('.timeago').timeago()
    @delegateEvents()

@UsersShowView = UsersShowView