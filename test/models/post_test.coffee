runTests ->
  
  module('post model');

  new PostFixtures

  test 'model exists', ->
    ok(Post)
  
  test 'getName()', ->
    ok(true)
  
  test "isReply()", ->
    ok Posts.first().isReply()
    
  test 'getAuthor()', ->
    ok Posts.first().getAuthor()
    ok(Posts.first().getAuthor() instanceof User)
    equal Posts.first().getAuthor().get('jid'), 'joe@diaspora-x.com'
