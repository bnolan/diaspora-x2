PUBSUB_BRIDGE = "pubsub-bridge@broadcaster.buddycloud.com"
BOSH_SERVICE = 'http://buddycloud.com/http-bind/'
BOSH_SERVICE = 'http://bosh.metajack.im:5280/xmpp-httpbind'
CHANNEL = "/user/simon@buddycloud.com/channel"

`String.prototype.capitalize = function(){
   return this.replace( /(^|\s)([a-z])/g , function(m,p1,p2){ return p1+p2.toUpperCase(); } );
};`

class Connection
  constructor: (jid, password) ->
    @c = new Strophe.Connection(BOSH_SERVICE)
    @c.connect jid, password, @onConnect

    @c.rawInput = (message) ->
      c = if message.match(/error/)
        'error'
      else
        'input'
      
      $("<div />").text(message).addClass(c).appendTo '#log'
    
    @c.rawOutput = (message) ->
      $("<div />").text(message).addClass('output').appendTo '#log'

    @maxMessageId = 1292405757510
  
  onConnect: (status) =>
    if (status == Strophe.Status.CONNECTING)
      # console.log('Strophe is connecting.')
    else if (status == Strophe.Status.AUTHFAIL)
      # console.log('Strophe failed to authenticate.')
      app.signout()
    else if (status == Strophe.Status.CONNFAIL)
      # console.log('Strophe failed to connect.')
      app.signout()
    else if (status == Strophe.Status.DISCONNECTING)
      # console.log('Strophe is disconnecting.')
    else if (status == Strophe.Status.DISCONNECTED)
      # console.log('Strophe is disconnected.')
    else if (status == Strophe.Status.CONNECTED)
      # console.log('Strophe is connected.')
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
  
  sendPost: (post) ->
    id = @c.getUniqueId("LM")

    stanza = $iq({"id" : id, "to" : PUBSUB_BRIDGE, "type" : "set"})
      .c("pubsub", { "xmlns" : "http://jabber.org/protocol/pubsub" })
      .c("publish", {"node":post.get('channel')})
      .c("item")
      .c("entry", {"xmlns":"http://www.w3.org/2005/Atom"})
      .c("content", {"type" : "text"}).t(post.get("content")).up()
      .c("author")
      .c("jid", {"xmlns":"http://buddycloud.com/atom-elements-0"}).t(post.get("author")).up().up()
      .c("in-reply-to", { "xmlns" : "http://purl.org/syndication/thread/1.0", "ref" : post.get('in_reply_to') }).up()
      # ... geoloc ..

    # console.log(stanza.tree())
    
    # Request..
    @c.send(stanza.tree());
    
    # console.log "sent!"
    
  getAllChannels: ->
    stanza = $pres( { "to" : PUBSUB_BRIDGE } )
    
    stanza
      .c("set", {"xmlns":"http://jabber.org/protocol/rsm"})
      .c("after").t(@maxMessageId + "")
      # .up()
      # .c("max").t("100")
      # .up()
      # .c("before")

    @c.send stanza.tree()
    
  subscribeToUser: (jid) ->
    @c.send($pres( { "type" : "subscribe", "to" : jid } ).tree())
    
  unsubscribeFromUser: (jid) ->
    @c.send($pres( { "type" : "unsubscribe", "to" : jid } ).tree())
    
  getChannel: (node) ->
    id = @c.getUniqueId("LM")

    stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"get"})
      .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
      .c("items", {"node":node})
      .c("set", {"xmlns":"http://jabber.org/protocol/rsm"})
      .c("after").t("100")

    # Request..
    @c.send(stanza.tree());
    
  onSubscriptionIq: (iq) =>
    # console.log iq

    true
    
    
  onMessage: (message) ->
    # console.log message

    true
    
  onPresence: (stanza) ->
    presence = $(stanza)
    
    jid = presence.attr('from').replace(/\/.+/,'')
      
    user = if Users.findByJid(jid)
      Users.findByJid(jid)
    else
      user = new User {
        jid : jid
      }
      
      if presence.find('status')
        user.set { status : presence.find('status').text() }
      
      Users.add user
      
      user

    user.grantChannelPermissions()
             
    true

  grantChannelPermissions: (jid, node) ->
    id = @c.getUniqueId("LM")

    stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"set"})
      .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
      .c("affiliations", { "node" : node })
      .c("affiliation", { "jid" : jid, affiliation : "follower+post" })

    @c.send(stanza.tree())

  onIq: (iq) ->
    # console.log iq

    for items in $(iq).find('items')
      items = $(items)
      channel = items.attr('node')

      if !channel.match(/.user/)
        Channels.findOrCreateByNode channel
        
      for item in items.find('item')
        item = $(item)
      
        id = parseInt(item.find('id').text().replace(/.+:/,''))
      
        if (!Posts.get(id)) && (item.find('content'))
          post = new Post { 
            id : id
            content : item.find('content').text() 
            author : Users.findOrCreateByJid(item.find('author jid').text())
            published : item.find('published').text()
            channel : channel
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
            # we dont display posts that have no content (looks ugly)...
            
            # console.log "invalid post..."
            # console.log item[0]
      
      # $("<div />").text(iq.find('content').text()).appendTo '#main'
      
    # function onMessage(msg) {
    #     var to = msg.getAttribute('to');
    #     var from = msg.getAttribute('from');
    #     var type = msg.getAttribute('type');
    #     var elems = msg.getElementsByTagName('body');
    
    true
    
  # createMyChannel: ->
  #   id = @c.getUniqueId("LM")
  # 
  #   stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"set"})
  #     .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
  #     .c("create", { "node" : app.currentUser.channelId() }).up()
  # 
  #   @c.send(stanza.tree())
  #   
  #   @grantChannelPermissions app.currentUser.get('jid'), app.currentUser.channelId()
    
  afterConnected: ->
    app.signedIn(@c.jid.replace(/\/.+/,''))

    # Send a presence stanza
    @c.send($pres().tree())

    # Tell the pubsub service i'm here
    @c.send($pres( { "to" : PUBSUB_BRIDGE, "from" : app.currentUser.get('jid') } ).tree())

    # Create my pubsub node
    @c.send($pres( { "type" : "subscribe", "to" : PUBSUB_BRIDGE } ).tree())

    # Create channel for currentUser
    # @createMyChannel()

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

app.showLog = ->
  $("#log").show()
  
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
  
  Posts.refresh []
  Users.refresh []
  
  localStorage.removeItem('jid')

  try
    window.$c.c.disconnect()
  catch e
    # ...
    
  window.$c = null
  

app.start = ->
  if window.location.pathname == "/test/"
    # ...
  else
    # The login / connection process isn't robust enough to jump
    # to a random page in the app yet..
    window.location.hash = ""
  
    # Start the url router
    Backbone.history.start();  


@app = app

setTimeout( ->
  app.start()
, 1000)
