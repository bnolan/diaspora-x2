class ChannelFixtures
  constructor: ->
    Channels.refresh [
      { node : "/channel/welcome" },
      { node : "/channel/blah" }
    ]

this.ChannelFixtures = ChannelFixtures