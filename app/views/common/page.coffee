class CommonPageView extends Backbone.View
  initialize: ->
    @el = $("#content")

    @template = _.template('''

      <div class="grid_7">
        <div id="main">
        </div>
      </div>
      

      <div class="grid_4 sidebar">


        <div class="intro">
          <h4>
            <img alt="Net_comp" class="icon" src="public/icons/net_comp.png" /> You are using a distributed social network
          </h4>

          <p>
             This site is based on <a href="http://onesocialweb.org/spec/1.0/osw-activities.html">Activitystreams</a>
             and interoperates with other sites using the same protocol. 
              Your friend can 
             </p>

          <p>
            &nbsp; &nbsp; <b class="currentuser"><%= app.currentUser.get('jid') %></b>
          </p>

        </div>


        <h4>
          <img alt="User" class="icon" src="public/icons/user.png" /> Friends
        </h4>

        <form action="#" class="friend_new" id="friend_new">
          <input name="email" placeholder="Enter an email address here..." size="30" style="width: 220px; margin-right: 10px" type="text" value="" />
          <input name="commit" type="submit" value="Invite" />
        </form>
      
        <ul class="friends" id="friends-list">

      </ul>

      <br />
      
        <h4>
          <img alt="User" class="icon" src="public/icons/folder.png" /> Channels
        </h4>

        <!--form accept-charset="UTF-8" action="http://diaspora-x.com/relationships" class="friend_new" id="friend_new" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="qO7TB8YODF9jEuTm5KhLnERnJ2Syi9+LnkH5KkIH6N0=" /></div>
          <input id="friend_email" name="friend[email]" placeholder="Enter an email address here..." size="30" style="width: 220px; margin-right: 10px" type="text" value="" />
          <input name="commit" type="submit" value="Invite" />
        </form-->  

        <ul class="channels" id="channels-list">
        </ul>

      </div>
    </div>
    
    <div class='clear'></div> 

    ''')

    @render()
    
  events: {
    'submit .friend_new' : 'friendSearch'
  }

  friendSearch: (e) ->
    jid = @el.find('.friend_new input:first').val()
    
    window.location.hash = "users/#{jid}"
    
    e.preventDefault()
    
    
  render: =>
    $('ul.tabs li').show()
    @el.html(@template())
    @delegateEvents()

@CommonPageView = CommonPageView