
# /*
#   AioServer
#   all in one server
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Sun Jun 01 2014 23:41:04 GMT+0800 (CST)
#

"use strict"

express = require 'express'
jade    = require 'jade'
path    = require 'path'
justlog = require 'justlog'
Db      = require './core/db'
app     = null
log     = null

BASE_PATH = process.env.PWD

class AioServer

  constructor : ( @options ) ->
    app = express()
    @_initEnv()
    @_useMiddleware()

  _initEnv : () ->
    { database, log } = @options
    @_initLog log
    @_initDataBase database
  
  _initDataBase : ( options ) ->
    options.log = log
    Db.init options

  _initLog : ( options ) ->
    { biz_log_path } = options
    logPath = path.join BASE_PATH, biz_log_path
    log = justlog 
      file : 
        path : "[logPath/pmc]YYYY-MM-DD[.log]"

  # just run the server
  run : () ->
    { port } = @options
    app.listen port, ->
      console.log "server listening:#{port}"

  # use all kind of middware
  _useMiddleware : ->
    { static_path, log } = @options
    { access_log_path } = log
    logPath    = path.join BASE_PATH, access_log_path
    staticPath = path.join BASE_PATH, static_path
    # log
    app.use justlog.middleware {
      file : 
        path : "[#{logPath}/access-]YYYY-MM-DD[.log]"
    }

    # static file
    # this middleware should be always in the bottom
    app.use express.static staticPath

  # use engines like jade
  _useEngines : ->
    app.engine 'jade', jade.__express

module.exports = AioServer