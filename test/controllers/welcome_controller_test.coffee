
runTests ->
  module('welcome controller');

  $("<div id='content' />").addClass('invisible').appendTo 'body'

  new ChannelFixtures
  new UserFixtures
  new PostFixtures

  # If we were using jasmine or qunit-mock we could stub... :/
  window.$c = {
    getChannel : ->
      # ...
  }

  app.currentUser = Users.first()
  
  asyncTest 'home', 1, ->
    window.location.hash = "home"
    Backbone.history.loadUrl()

    waitForRender ->
      equal 1, $("#content h4:contains('using a distributed social network')").length
      # ok $("#main h1").html().match(/Welcome/)
      start()
      
  # test "post", ->
  #   ta = $("#main form:first textarea")
  #   
  #   ok ta[0]
  #   
  #   ta.val("test post").parents("form").submit()
  # 
  #   ok