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

# get list of polls of a Team
getPollsOfTeam = (parent, args) ->
	console.log "query Polls of Team.id=" + parent.id
	pollsData["1"]

# check if a proposal is created by the currently logged in user
isCreatedByCurrentUser = (parent, args) ->
	console.log("isCreatedByCurrentUser", parent, args)
	false

createPoll = (parent, args, ctx, info) ->
	if !ctx.user then throw "Must be logged in to create a new poll!"
	if !ctx.isAdmin then throw "Must be admin to create a new poll"
	newPoll =
		id: "DummyIdNewPoll"
		title: args.title
		proposals: []
		status: "ELABORATION"



# These exports will become GraphQL resolvers and mutations
module.exports =
	getPoll: getPoll
	isCreatedByCurrentUser: isCreatedByCurrentUser
	getPollsOfTeam: getPollsOfTeam
	createPoll: createPoll