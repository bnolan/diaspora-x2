PUBSUB_BRIDGE = "pubsub-bridge@broadcaster.buddycloud.com"
BOSH_SERVICE = 'http://buddycloud.com/http-bind/'
BOSH_SERVICE = 'http://bosh.metajack.im:5280/xmpp-httpbind'
CHANNEL = "/user/simon@buddycloud.com/channel"


class Connection
  constructor: (jid, password) ->
    console.log "Connecting..."
    
    @c = new Strophe.Connection(BOSH_SERVICE)
    @c.connect jid, password, @onConnect

    @c.rawInput = (message) ->
      $("<div />").text(message).addClass('input').appendTo '#log'
    
    @c.rawOutput = (message) ->
      $("<div />").text(message).addClass('output').appendTo '#log'

    @maxMessageId = "0"
    
    console.log "... ok"
    
  onConnect: (status) =>
    if (status == Strophe.Status.CONNECTING)
      console.log('Strophe is connecting.')
    else if (status == Strophe.Status.CONNFAIL)
      console.log('Strophe failed to connect.')
    else if (status == Strophe.Status.DISCONNECTING)
      console.log('Strophe is disconnecting.')
    else if (status == Strophe.Status.DISCONNECTED)
      console.log('Strophe is disconnected.')
    else if (status == Strophe.Status.CONNECTED)
      console.log('Strophe is connected.')
      @subscribeNodes()
      # @c.disconnect()

  getChannel: (node) ->
    id = @c.getUniqueId("LM")

    stanza = $iq({"id":id, "to":PUBSUB_BRIDGE, "type":"get"})
      .c("pubsub", {"xmlns":"http://jabber.org/protocol/pubsub"})
      .c("items", {"node":node})
      .c("set", {"xmlns":"http://jabber.org/protocol/rsm"})
      .c("after").t(@maxMessageId)

    # Request..
    @c.send(stanza.tree());
    
  onSubscriptionIq: (iq) =>
    console.log("Got Subs. IQ.");
    console.log iq

    true
    
    
  onMessage: (message) ->
    console.log message

    true
    
  onPresence: (stanza) ->
    presence = $(stanza)
    
    jid = presence.attr('from').replace(/\/.+/,'')
    
    console.log stanza
    
    if Users.findByJid(jid)
      # ...
    else
      user = new User {
        jid : jid
      }
      
      Users.add user
      
    true
    
  onIq: (iq) ->
    # console.log iq

    for item in $(iq).find('item')
      item = $(item)
      
      if item.find 'content'
        post = new Post { 
          id : item.find('id').text().replace(/.+:/,'')
          content : item.find('content').text() 
          author : item.find('author jid').text()
          published : item.find('published').text()
        }
      
        if item.find('in-reply-to')
          post.set { in_reply_to : item.find('in-reply-to').attr('ref') }

        if item.find 'geoloc'
          post.set { 
            geoloc_country : item.find('geoloc country').text()
            geoloc_locality : item.find('geoloc locality').text()
            geoloc_text : item.find('geoloc text').text()
          }
        
        Posts.add(post)
      
      # $("<div />").text(iq.find('content').text()).appendTo '#main'
      
    # function onMessage(msg) {
    #     var to = msg.getAttribute('to');
    #     var from = msg.getAttribute('from');
    #     var type = msg.getAttribute('type');
    #     var elems = msg.getElementsByTagName('body');
    
    true
    
  subscribeNodes: ->
    $(".auth .name").text(@c.jid.replace(/\/.+/,''))
    $('.currentuser').text(@c.jid.replace(/\/.+/,''))
    # console.log "Connected as #{@c.jid}..."

    # Send a presence stanza
    @c.send($pres().tree());

    # Add handlers for messages and iq stanzas
    @c.addHandler(@onMessage, null, 'message', null, null,  null); 
    @c.addHandler(@onIq, null, 'iq', null, null,  null); 
    @c.addHandler(@onPresence, null, 'presence', null, null,  null); 

    @c.send $pres( { "to" : PUBSUB_BRIDGE } ).tree()
    
    @getChannel(CHANNEL)

    # connection.pubsub.setService(PUBSUB_BRIDGE);
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

app.start = ->
  # Establish xmpp connection
  window.$c = new Connection("captainamus@gmail.com", localStorage['password'])

  # Start the url router
  Backbone.history.start();

@app = app

setTimeout( ->
  app.start()
, 1000)
