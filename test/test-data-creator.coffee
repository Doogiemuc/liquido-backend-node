env = process.env.NODE_ENV || 'dev'
if !env
	throw new Error "Error: Need NODE_ENV, eg. dev|test|int|prod"

config = require '../config/config.' + env + ".js"
{ MongoClient } = require 'mongodb'
teamService = require '../src/teams/team-service'
pollService = require '../src/polls/poll-service'

console.log "Running Test-data-creator in " + env
console.log config


console.log "Connecting to DB ..."
client = new MongoClient(config.liquido.db.URI, { useNewUrlParser: true, useUnifiedTopology: true })
client.connect (err) ->
	if err
		console.log "DB connection error", err

database = client.db config.liquido.db.dbName

console.log "Connected to db successfully"

# Create a dummy team with an admin
now = Date.now()
dummyTeamName = "TestTeam_" + now
createNewTeamRequest =
	teamname: dummyTeamName
	admin:
		name: "TestAdmin " + now
		email: "admin_" + now + "@" + dummyTeamName + ".org"
		mobilephone: "+49 555 " + now

teamService.createNewTeam null, createNewTeamRequest


console.log "Closing connection"
client.close()