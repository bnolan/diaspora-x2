runTests ->

  module('user model');

  new UserFixtures

  # If we were using jasmine or qunit-mock we could stub... :/
  window.$c = {
    getChannel : ->
      # ...
  }
  
  test 'model exists', ->
    ok(User)
  
  test 'getName', ->
    equal(Users.first().getName(), "ben")

  test "getFriends", ->
    equal(Users.first().getFriends().length, 0)
    
    u = new User
    u.set { friends : ['jim@example.com'] }
    
    equal(u.getFriends()[0].getName(), "jim")

  test "addFriend", ->
    u = new User
    equal u.getFriends().length, 0
    u.addFriend 'jim@example.com'
    equal u.getFriends().length, 1
    u.addFriend 'jim@example.com'
    equal u.getFriends().length, 1
    u.addFriend 'zigzug@example.com'
    equal u.getFriends().length, 2
  