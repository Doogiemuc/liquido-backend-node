###
  Microservice for LIQUIDO polls
###

# Dummy Data
pollsData = {
	"1":  # Team ID
		[
			id: "1"
			title: "How shall we build our castle?"
			status: "ELABORATION"
			proposals: [
				id: "101"
				title: "As fast as possible"
				description: "But this will be a lot of stress"
			]
		]
}


# Get one poll by its id
getPoll = (parent, args) ->
	console.log "query poll(id=#{args.id})"
	pollsData["1"][0]

getPollsOfTeam = (parent, args) ->
	console.log "query polls of team", args
	pollsData["1"]


# Export GraphQL resolver functions
module.exports =
	Query:
		poll: getPoll						# get one poll by its id
	Team:
		polls: getPollsOfTeam