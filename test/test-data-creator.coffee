env = process.env.NODE_ENV || 'dev'
if !env
	throw new Error "Error: Need NODE_ENV, eg. test|int|prod"

config = require '../config/config.' + env + ".js"
{ MongoClient } = require 'mongodb'

console.log "Running Test-data-creator in " + env
console.log config

client = new MongoClient(config.liquido.db.URI, { useNewUrlParser: true, useUnifiedTopology: true })
client.connect (err) ->
	if err
		console.log "DB connection error", err

database = client.db config.liquido.db.dbName




console.log "Closing connection"
# client.close()