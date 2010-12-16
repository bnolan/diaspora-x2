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
        
      <div class="posts"></div>
    ''')

    @collection.bind 'add', @render
    @collection.bind 'change', @render
    @collection.bind 'remove', @render
    @collection.bind 'refresh', @render

    @render()
  
  events: {
    'submit form.new_activity.status' : 'submit'
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

    post.send()
    
  # 
  # select: (e) ->
  #   @el.find('a').removeClass 'active'
  #   $(e.currentTarget).addClass 'active'

  # Render the content
  
  getPosts: ->
    _ @collection.select((post) ->
      (!post.isReply()) && (post.isUserChannel())
    ).reverse()
    
  render: =>
    @el.html(@template( { posts : @getPosts() })).find('.timeago').timeago()
    @delegateEvents()

    new PostsListView { el : @el.find('.posts'), collection : @getPosts() }

@WelcomeIndexView = WelcomeIndexView