class UsersShowView extends Backbone.View
  initialize: ->
    new CommonPageView

    @el = $("#main") # app.activePage()

    @collection = Posts
    
    @template = _.template('''

      <h1>
        <%= user.getName() %>
      </h1>
      <p class="usermeta">
        <img src="public/icons/globe_2.png" /> <%= user.get('jid') %>
        |
        <a href="#users/<%= user.get('jid') %>/subscribe">Subscribe</a>
      </p>
    
      <form action="#" class="new_activity status">
        <h4>Write on <%= user.getName() %>s wall</h4>
        <textarea cols="40" id="activity_content" name="content" rows="20"></textarea>
        <input name="commit" type="submit" value="Share" />
      </form>
        
      <div class="posts"></div>
    ''')

    Users.bind 'add', @render
    Users.bind 'change', @render
    Users.bind 'remove', @render
    Users.bind 'refresh', @render

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
      channel : @model.channelId()
      author : app.currentUser.get('jid')
    }
    
    post.send()
  
  getPosts: ->
    _ @collection.select((post) =>
      (!post.isReply()) && (post.get('channel') == @model.channelId())
    ).reverse()
    
  render: =>
    if @renderTimeout
      clearTimeout @renderTimeout
      
    @renderTimeout = setTimeout( =>
      @el.html(@template( { user : @model, posts : @getPosts() })).find('.timeago').timeago()
      @delegateEvents()

      new PostsListView { el : @el.find('.posts'), collection : @getPosts() }
      
      @renderTimeout = null
    , 50)

@UsersShowView = UsersShowView