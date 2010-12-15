class WelcomeIndexView extends Backbone.View
  initialize: ->
    @el = $("#main") # app.activePage()

    @collection = Posts
    
    @template = _.template('''

      <form accept-charset="UTF-8" action="/activities" class="new_activity status" id="new_activity" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="qO7TB8YODF9jEuTm5KhLnERnJ2Syi9+LnkH5KkIH6N0=" /></div>
        <h4>What are you doing now?</h4>
        <input id="activity_verb" name="activity[verb]" type="hidden" value="status" />
        <textarea cols="40" id="activity_content" name="activity[content]" rows="20"></textarea>
        <input id="activity_submit" name="commit" type="submit" value="Share" />
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
  
  # events: {
  #   'mousedown a' : 'select'
  # }
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