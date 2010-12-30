
runTests ->
  module('channels controller');

  new ChannelFixtures
  new UserFixtures

  # If we were using jasmine or qunit-mock we could stub... :/
  window.$c = {
    getChannel : ->
      # ...
  }

  $("<div id='main'></div>").addClass('invisible').appendTo 'body'
  
  app.currentUser = Users.first()
  
  asyncTest 'show', ->
    window.location.hash = "channels/welcome"
    Backbone.history.loadUrl()

    waitForRender ->
      ok $("#main h1").html().match(/Welcome/)
      start()
      
      
  # test "post", ->
  #   ta = $("#main form:first textarea")
  #   
  #   ok ta[0]
  #   
  #   ta.val("test post").parents("form").submit()
  # 
  #   ok 