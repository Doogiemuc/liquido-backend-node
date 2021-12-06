fs = require 'fs'
path = require 'path'
{ GraphQLServer } = require 'graphql-yoga'
{ mergeResolvers } = require '@graphql-tools/merge'
#TODO: Logging:    morgan = require 'morgan'

# Load LIQUIDO GraphQL Schema - TypeDefs
liquido_schema_filename = path.join 'src', 'graphql', 'liquido_schema.graphql'
typeDefs = String fs.readFileSync liquido_schema_filename

# Load LIQUIDO GraphQL - resolvers
teamService = require './teams/team-service'
pollService = require './polls/poll-service'
resolvers = mergeResolvers [teamService, pollService]

# Start graphq-yoga server
graphQL_server_options =
	port: 4000
	endpoint: '/graphql'
	subscriptions: '/subscriptions'
	playground: '/playground'  
	debug: true   # process.env.NODE_ENV == "development"

server = new GraphQLServer { typeDefs, resolvers }
console.log "Liquido GraphQL backend is starting ..."
server.start graphQL_server_options, ({port, endpoint}) ->
	console.log "resolvers = ", resolvers
	console.log "Listening http://localhost:#{port}#{endpoint} in #{process.env.NODE_ENV} mode."
	

