console.log "Liquido GraphQL backend is starting ..."

fs = require 'fs'
path = require 'path'
jwt = require 'jsonwebtoken'
{ GraphQLServer } = require 'graphql-yoga'
{ MongoClient } = require 'mongodb'
# { mergeResolvers } = require '@graphql-tools/merge'
#TODO: Logging:    morgan = require 'morgan'


# Environment dependant configuration
env = process.env.NODE_ENV || 'dev'
if !env
	throw new Error "Error: Need NODE_ENV, eg. dev|test|int|prod"
config = require '../config/config.' + env + ".js"


# LIQUIDO GraphQL Schema - TypeDefs
liquido_schema_filename = path.join 'src', 'graphql', 'liquido_schema.graphql'
typeDefs = String fs.readFileSync liquido_schema_filename

# LIQUIDO GraphQL - resolvers
teamService = require './teams/team-service'
pollService = require './polls/poll-service'
resolvers = 
	Query:
		team: teamService.getTeam
		poll: pollService.getPoll
	Team:
		polls: pollService.getPollsOfTeam
	Law:
		isCreatedByCurrentUser: pollService.isCreatedByCurrentUser
	Mutation:
		createNewTeam: teamService.createNewTeam
		createPoll: pollService.createPoll

# GraphQL-yoga server options
graphQL_server_options =
	port: 4000
	endpoint: '/graphql'
	subscriptions: '/subscriptions'
	playground: '/playground'  
	graphiql: process.env.NODE_ENV == 'development' or process.env.NODE_ENV == 'dev'
	debug: process.env.NODE_ENV == 'development' or process.env.NODE_ENV == 'dev'

console.log graphQL_server_options

# JsonWebToken authentication as middleware for express
jwtAuthMiddleware = (req, res, next) ->
	# console.log req.url
	if req.url in ['/playground', '/graphql']
		next() 
	else
		{ authorization } = req.headers
		jwt.verify authorization, 'jwt#secret', (err, decodedToken) ->
			if err || !decodedToken
				res.status(401).send('not authorized. need JWT')
				return
			req.claims = decodedToken.claims
			#TODO: add roles to users
			next()

#
# Connect to MonogDB and THEN start the GraphQL-yoga server
#
console.log "Connecting to MongoDB at " + config.liquido.db.servers
client = new MongoClient(config.liquido.db.URI, { useNewUrlParser: true, useUnifiedTopology: true })
client.connect (err) ->
	if err
		console.log "DB connection error:", err
		throw err
	else	
		console.log "... connected to DB successfully."

	# GraphQL context, that will be passed to all resolvers
	context =
		db: client.db config.liquido.db.dbName

	# GraphQL-yoga server with JWT authentication
	server = new GraphQLServer { typeDefs, resolvers, context }
	server.express.use(jwtAuthMiddleware)

	console.log "Starting graphql-yoga server"
	server.start graphQL_server_options, ({port, endpoint}) ->
		console.log "resolvers = ", resolvers
		console.log "Listening http://localhost:#{port}#{endpoint} in #{process.env.NODE_ENV} mode."


