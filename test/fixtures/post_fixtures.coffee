class PostFixtures
  constructor: ->
    Posts.refresh [
      { id : '1', channel : "/channel/welcome", content : "Hi I'm new", author : 'ben@diaspora-x.com' }
      { id : '2', channel : "/channel/welcome", content : "Welcome dude", author : 'joe@diaspora-x.com', in_reply_to : '1' }
      
    ]

this.PostFixtures = PostFixtures