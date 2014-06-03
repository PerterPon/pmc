
# /*
#   DB
# */
# Author: PerterPon<PerterPon@gmail.com>
# Create: Tue Jun 03 2014 23:42:31 GMT+0800 (CST)
#

"use strict"

dbClient = null

mongodb = require 'mongodb'

class Db

  constructor : ( @options ) ->
    { @log } = options
    @connectDb options

  connectDb : ( options ) ->
    { log }   = @
    { url, port, collection } = options
    mongoUrl  = "#{url}:#{port}"
    retryTime = 0
    mongodb.connect mongoUrl, ( err, db ) ->
      if err
        if retryTime++ >= 3
          log.error
            message : 'connect to db failed after 3 times, do check the db status!'
        else
          log.error
            message : 'connect to db failed\ntry to reconnect!'
          @doConnect mongoUrl, cb
      else
        dbClient = db.collection collection

exports = module.exports = -> dbClient

exports.init = ( options ) ->
  dbClient ?= new Db options
