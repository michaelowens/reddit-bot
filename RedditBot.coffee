log = require './log'
util = require 'util'

class RedditBot
  @Error: (msg) ->
    Error.captureStackTrace this, arguments.callee
    @name = 'RedditBotError'
    @message = msg || ''

  constructor: (@config) ->
    log.config = config.log if typeof config.log is 'object' and config.log instanceof Array
    throw new RedditBot.Error 'The bot is a lie'

util.inherits RedditBot.Error, Error

module.exports = RedditBot