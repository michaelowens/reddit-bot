log = require './log'
util = require 'util'
Reddit = require 'reddit-api'
pjson = require './package.json'

class RedditBot
  loopTime: 2500
  loop: null
  loggedIn: false
  nw = null

  constructor: (@config) ->
    log.config = @config.log if typeof @config.log is 'object' and @config.log instanceof Array
    log.info 'RedditBot', pjson.version

    @reddit = new Reddit 'xikeon-reddit-bot'
    @reddit.login @config.username, @config.password, (err) =>
      throw err if err?
      @loggedIn = true
      log.info 'Logged in with', @config.username
      @start()
    
  start: ->
    @loop = setInterval @mainLoop, @loopTime if @loggedIn
    
  mainLoop: =>
    #log.debug 'loop'
    self = this
    @reddit.messages (err, messages) ->
      throw err if err?
      if messages
        #log.debug messages
        for msg in messages
          log.debug 'Received message(' + msg.data.id + '):', msg.data.subject
          self.reddit.readMessage msg.data.id

  @Error: (msg) ->
    Error.captureStackTrace this, arguments.callee
    @name = 'RedditBotError'
    @message = msg || ''

util.inherits RedditBot.Error, Error

module.exports = RedditBot