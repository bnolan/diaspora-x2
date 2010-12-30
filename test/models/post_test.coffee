runTests ->
  
  module('post model');

  new PostFixtures

  test 'model exists', ->
    ok(Post)
  
  test 'getName()', ->
    ok(true)
    
  test 'getAuthor()', ->
    ok Posts.first().getAuthor()
    ok(Posts.first().getAuthor() instanceof User)
    equal Posts.first().getAuthor().get('jid'), 'ben@diaspora-x.com'
