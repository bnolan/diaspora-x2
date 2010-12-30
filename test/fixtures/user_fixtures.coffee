class UserFixtures
  constructor: ->
    Users.refresh [
      { jid : "ben@diaspora-x.com" }
    ]

this.UserFixtures = UserFixtures