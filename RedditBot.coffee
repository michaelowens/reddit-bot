log = require './log'
util = require 'util'
Reddit = require 'reddit-api'
pjson = require './package.json'

# RedditBot - A bot that doesn't know what it does
class RedditBot
  loopTime: 2500
  loop: null

  # Configuring and starting the bot
  #
  # @param [Object] config The configuration object, usually loaded from config.yaml
  constructor: (@config) ->
    log.config = @config.log if typeof @config.log is 'object' and @config.log instanceof Array
    log.info 'RedditBot', 'v' + pjson.version

    @reddit = new Reddit 'xikeon-bot/0.1 by xikeon'
    @start()

  # Log in to reddit and initialize the mainLoop
  start: ->
    @reddit.account.login @config.username, @config.password, (err) =>
      throw err if err?

      log.info 'Logged in as', @config.username
      @loop = setInterval @mainLoop, @loopTime

  # The main loop where all the magic happens
  mainLoop: =>
    self = this
    @reddit.messages.get 'unread', (err, messages) ->
      throw err if err?
      self.handlePms this, err, messages if messages

  # Handles an array of private messages
  #
  # @param [Object] res An HTTP call response
  # @param [Object] err An error object
  # @param [Array] messages An array of private messages from the Reddit API
  handlePms: (res, err, messages) ->
    for msg in messages
      log.debug 'Received message(' + msg.data.id + '):', msg.data.subject

      @reddit.messages.readMessage 't4_' + msg.data.id, res.body.data.modhash, (err) ->
        throw err if err?
        log.info 'Message handled:', msg.data.id

  # A custom exception
  #
  # @param [String} msg The error message
  @Error: (msg) ->
    Error.captureStackTrace this, arguments.callee
    @name = 'RedditBotError'
    @message = msg || ''

util.inherits RedditBot.Error, Error

module.exports = RedditBot