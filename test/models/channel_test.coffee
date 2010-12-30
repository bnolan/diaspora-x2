runTests ->

  module('channel model');

  new ChannelFixtures

  # If we were using jasmine or qunit-mock we could stub... :/
  window.$c = {
    getChannel : ->
      # ...
  }
  
  test 'model exists', ->
    ok(Channel)
  
  test 'getName', ->
    equal(Channels.first().getName(), "welcome")

  test "channelId", ->
    equal(Channels.first().channelId(), "/channel/welcome")
    
  test "fetchPosts", ->
    Channels.first().fetchPosts()
    ok true
    
  test "findOrCreate", ->
    c = Channels.findOrCreateByNode "/channel/blahzeblah"
    ok c
    
    equals "blahzeblah", c.getName()
    
    c = Channels.findOrCreateByNode "/channel/welcome"
    equals 3, Channels.length
    