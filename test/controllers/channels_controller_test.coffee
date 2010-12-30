
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
      ok $("#main h1").html().match(/welcome/)
      start()