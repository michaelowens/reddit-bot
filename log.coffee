chalk = require 'chalk'
figures = require 'figures'
space = if /^darwin/.test process.platform then ' ' else ''

module.exports =
  config: ['info', 'warn', 'debug', 'error']
  debug: (msg...) -> console.log figures.circleCircle + space, msg... if 'debug' in @config
  info: (msg...) -> console.log chalk.blue figures.info + space, msg... if 'info' in @config
  error: (msg...) -> console.log chalk.red figures.circleCross + space, msg... if 'error' in @config
  warn: (msg...) -> console.log chalk.yellow figures.warning + space, msg... if 'warn' in @config
