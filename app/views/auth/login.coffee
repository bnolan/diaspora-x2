class AuthLoginView extends Backbone.View
  initialize: ->
    @el = $("#content")

    $("#spinner").remove()

    @template = _.template('''
    
      <div class="grid_12">
        <h1>
          A social network that is friends with the other social networks
        </h1>
      </div>

      <div class="grid_6">
        <p>
          This is a branch of <a href="https://github.com/diaspora/diaspora">Diaspora</a> that supports the <a href="http://activitystrea.ms/">Activity Streams</a> standard.
          This is the primary diaspora*x server for public use, or you can <a href="http://github.com/bnolan/diaspora-x2">run your own</a>.
        </p>

        <h2>
          <span>Sign in</span>
        </h2>

        <p>
          <small>
            You can sign in using your diasapora-x.com, gmail.com, buddycloud.com or me.com login. Your password is 
            stored in your browser and never shared with the diaspora-x server.
          </small>
        </p

        <form action="#signin" class="signin">
          <div class="f">
            <label for="jid">Login</label>
            <input name="jid" size="30" style="width: 180px" type="text" />
          </div>

          <div class="f">
            <label for="password">Password</label>
            <input name="password" size="30" style="width: 120px" type="password" />
          </div>

          <!--div class="f cb">
            <input name="user[remember_me]" type="hidden" value="0" /><input checked="checked" id="user_remember_me" name="user[remember_me]" type="checkbox" value="1" /> <label for="user_remember_me">Remember me</label>
          </div-->
          
          <div class="f">
            <input class="signin-button" type="submit" value="Sign in" />
          </div>
        </form>
        
        <h2><span>Create an account</span></h2>

        <p>
          <small>Account creation is temporarily disabled. Please try again later.</small>
        </p>
        
        <!--div style="display: none">
          <p>
            <small>
              If you don't want to use an existing login, you can sign up for one
              from Diaspora*x.com.
            </small>
          </p

          <form method="get" action="#signup" class="signup">

            <div class="f">
              <label for="jid">Login</label>
              <input name="jid" size="30" style="width: 120px" type="text" /> @ diaspora-x.com
            </div>

            <div class="f">
              <label for="email">Email</label>
              <input name="email" size="30" type="text" value="" />
            </div>

            <div class="f">
              <label for="password">Password</label>
              <input name="password" size="30" style="width: 80px" type="password" />
            </div>

            <div class="f">
              <label for="password_confirmation">Confirm Password</label>
              <input name="password_confirmation" size="30" style="width: 80px" type="password" />
            </div>

            <div class="f"><input id="user_submit" name="commit" type="submit" value="Sign up" /></div>
          </form>
        </div-->
        
        
      </div>
    ''')

    @render()
    
  events: {
    'submit form.signin' : 'signin'
    'click .signin-button' : 'signin'
  }
  
  signin: (e) ->
    jid = $("input[name='jid']").val()
    password = $("input[name='password']").val()

    if jid.match(/@/) && password.length > 0
      localStorage['jid'] = jid
      localStorage['password'] = password
      app.connect()
    else
      alert "Invalid login / password..."
    
    e.preventDefault()
    
  render: =>
    $('.auth').hide()
    $('ul.tabs li').hide()
    
    @el.html(@template( { users : @collection })).hide().fadeIn()
    @delegateEvents()

@AuthLoginView = AuthLoginView