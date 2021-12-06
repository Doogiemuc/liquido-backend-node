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
				status: "ELABORATION"
			]
		]
}


# Get one poll by its id
getPoll = (parent, args) ->
	console.log "query Poll(id=#{args.id})"
	pollsData["1"][0]

getPollsOfTeam = (parent, args) ->
	console.log "query Polls of Team.id=" + parent.id
	pollsData["1"]


# Export GraphQL resolver functions
module.exports =
	Query:
		poll: getPoll						# get one poll by its id
	Team:
		polls: getPollsOfTeam		# get all polls of a team