class PostFixtures
  constructor: ->
    Posts.refresh [
      { channel : "/channel/welcome", content : "Blah blah blah", author : 'ben@diaspora-x.com' }
    ]

this.PostFixtures = PostFixtures