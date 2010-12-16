PUBSUB_BRIDGE = "pubsub-bridge@broadcaster.buddycloud.com"
BOSH_SERVICE = 'http://buddycloud.com/http-bind/'
BOSH_SERVICE = 'http://bosh.metajack.im:5280/xmpp-httpbind'
CHANNEL = "/user/simon@buddycloud.com/channel"


class Connection
  constructor: (jid, password) ->
    @c = new Strophe.Connection(BOSH_SERVICE)
    @c.connect jid, password, @onConnect

    @c.rawInput = (message) ->
      $("<div />").text(message).addClass('input').appendTo '#log'
    
    @c.rawOutput = (message) ->
      c = if message.match(/error/)
        'error'
      else
        'output'
        
      $("<div />").text(message).addClass(c).appendTo '#log'

    @maxMessageId = 1292405757510
  
  onConnect: (status) =>
    if (status == Strophe.Status.CONNECTING)
      console.log('Strophe is connecting.')
    else if (status == Strophe.Status.AUTHFAIL)
      console.log('Strophe failed to authenticate.')
      app.signout()
    else if (status == Strophe.Status.CONNFAIL)
      console.log('Strophe failed to connect.')
      app.signout()
    else if (status == Strophe.Status.DISCONNECTING)
      console.log('Strophe is disconnecting.')
    else if (status == Strophe.Status.DISCONNECTED)
      console.log('Strophe is disconnected.')
    else if (status == Strophe.Status.CONNECTED)
      console.log('Strophe is connected.')
      @afterConnected()

      # @c.disconnect()

  # getSubscriptions: (node) ->
  #   id = @c.getUniqueId("LM")
  # 
  #   stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"get"})
  #     .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
  #     .c("subscriptions")
  # 
  #   # Request..
  #   @c.send(stanza.tree());
  # 
  #   id = @c.getUniqueId("LM")
  # 
  #   stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"get"})
  #     .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
  #     .c("items")
  #     .c("set", {"xmlns":"http://jabber.org/protocol/rsm"})
  #     .c("after").t(@maxMessageId)
  # 
  #   # Request..
  #   @c.send(stanza.tree());
  #   
  
  getAllChannels: ->
    stanza = $pres( { "to" : PUBSUB_BRIDGE } )
    
    stanza
      .c("set", {"xmlns":"http://jabber.org/protocol/rsm"})
      .c("after").t(@maxMessageId + "")
      .up()
      .c("max").t("100")
      # .up()
      # .c("before")

    @c.send stanza.tree()
    
  getChannel: (node) ->
    id = @c.getUniqueId("LM")

    stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"get"})
      .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
      .c("items", {"node":node})
      .c("set", {"xmlns":"http://jabber.org/protocol/rsm"})
      .c("after").t(@maxMessageId + "")

    # Request..
    @c.send(stanza.tree());
    
  onSubscriptionIq: (iq) =>
    console.log iq

    true
    
    
  onMessage: (message) ->
    console.log message

    true
    
  onPresence: (stanza) ->
    presence = $(stanza)
    
    jid = presence.attr('from').replace(/\/.+/,'')
    
    if Users.findByJid(jid)
      # ...
    else
      user = new User {
        jid : jid
      }
      
      if presence.find('status')
        user.set { status : presence.find('status').text() }
      
      Users.add user
      
    true
    
  onIq: (iq) ->
    # console.log iq

    for item in $(iq).find('item')
      item = $(item)
      
      id = parseInt(item.find('id').text().replace(/.+:/,''))
      
      if (!Posts.get(id)) && (item.find('content'))
        post = new Post { 
          id : id
          content : item.find('content').text() 
          author : item.find('author jid').text()
          published : item.find('published').text()
        }
      
        if item.find 'in-reply-to'
          post.set { 'in_reply_to' : parseInt(item.find('in-reply-to').attr('ref')) }

        if item.find 'geoloc'
          post.set { 
            geoloc_country : item.find('geoloc country').text()
            geoloc_locality : item.find('geoloc locality').text()
            geoloc_text : item.find('geoloc text').text()
          }
        
        if post.valid()
          Posts.add(post)
        else
          console.log "invalid post..."
      
      # $("<div />").text(iq.find('content').text()).appendTo '#main'
      
    # function onMessage(msg) {
    #     var to = msg.getAttribute('to');
    #     var from = msg.getAttribute('from');
    #     var type = msg.getAttribute('type');
    #     var elems = msg.getElementsByTagName('body');
    
    true
    
  afterConnected: ->
    app.signedIn(@c.jid.replace(/\/.+/,''))

    # Send a presence stanza
    @c.send($pres().tree());

    # Add handlers for messages and iq stanzas
    @c.addHandler(@onMessage, null, 'message', null, null,  null); 
    @c.addHandler(@onIq, null, 'iq', null, null,  null); 
    @c.addHandler(@onPresence, null, 'presence', null, null,  null); 

    @getAllChannels()
    
    @c.pubsub.setService(PUBSUB_BRIDGE)

    # @getSubscriptions()
    # @getChannel(CHANNEL)

    # connection.pubsub.subscribe(CHANNEL_NODE, null, null, Rcf.onSubscriptionIq, true);
    # Rcf.requestNodeMetaData(CHANNEL_NODE);

    # @c.pubsub.subscribe(CHANNEL, null, @onSubscriptionIq, @eh);

    #@c.pubsub.subscribe(CHANNEL, null, @eh, @eh, @onSubscriptionIq, @eh);

    #         Client.connection.pubsub.subscribe(
    #           Client.connection.jid,
    # 'pubsub.' + Config.XMPP_SERVER,
    #           Config.PUBSUB_NODE,
    #           [],
    #           Client.on_event,
    #           Client.on_subscribe
    #         );


    console.log("done");
		

app = {}

app.connect = ->
  # Spinner!
  app.spinner()

  window.location.hash = "connecting"

  # Establish xmpp connection
  window.$c = new Connection(localStorage['jid'], localStorage['password'])

app.currentUser = null

app.spinner = ->
  $("#content").empty()
  $("<div id='spinner'><img src='public/spinner.gif' /> Connecting...</div>").appendTo 'body'

app.signedIn = (jid) ->
  $("#spinner").remove()

  if not Users.findByJid(jid)
    user = new User { jid : jid }
    Users.add user
    
  app.currentUser = Users.findByJid(jid)
  
  window.location.hash = "home"
  
  new CommonAuthView
  
app.signout = ->
  window.location.hash = ""
  $("#spinner").remove()
  
  localStorage.removeItem('jid')

  try
    window.$c.c.disconnect()
  catch e
    # ...
    
  window.$c = null
  

app.start = ->
  # The login / connection process isn't robust enough to jump
  # to a random page in the app yet..
  window.location.hash = ""
  
  # Start the url router
  Backbone.history.start();  


@app = app

setTimeout( ->
  app.start()
, 1000)
