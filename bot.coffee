log = require './log'
chalk = require 'chalk'
fs = require 'fs'
yaml = require 'yamljs'
RedditBot = require './RedditBot'
config = null
bot = null

fs.exists 'config.yaml', (exists) ->
  if not exists
    log.error 'Config not found! Please copy config.default.yaml to config.yaml.'
    process.exit 1
  
  try
    config = yaml.load 'config.yaml'
  catch e
    log.error 'Config contains errors! Please check your config file if it is valid YAML.'
    log.debug e.stack
    process.exit 1
  
  try
    if config
      bot = new RedditBot config
    else
      log.error 'Config failed to load'
  catch e
    log.error e.message
    log.debug e.stack
