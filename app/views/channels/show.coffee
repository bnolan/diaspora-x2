class ChannelsShowView extends Backbone.View
  initialize: ->
    new CommonPageView

    @el = $("#main")

    @collection = Posts
    
    @template = _.template('''

      <h1>
        <%= channel.getName() %>
      </h1>
      <p class="usermeta">
        <img src="public/icons/globe_2.png" /> <%= channel.get('node') %>
      </p>
    
      <form action="#" class="new_activity status">
        <h4>New post</h4>
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
      @el.html(@template( { channel : @model, posts : @getPosts() })).find('.timeago').timeago()
      @delegateEvents()

      new PostsListView { el : @el.find('.posts'), collection : @getPosts() }
      
      @renderTimeout = null
    , 50)

@ChannelsShowView = ChannelsShowView