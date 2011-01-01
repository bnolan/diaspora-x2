class UserFixtures
  constructor: ->
    Users.refresh [
      { jid : "ben@diaspora-x.com" },
      { jid : "joe@diaspora-x.com" }
    ]

this.UserFixtures = UserFixtures