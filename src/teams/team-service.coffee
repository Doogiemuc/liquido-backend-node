###
  Microservice for creating and joining a team
###

# Dummy Data
teamsData = {
	"1":
		id: "1"
		teamName: "Team One"
		inviteCode: "F3G3BZ"
		admins: [
			id: "1", name: "Admin1", email: "admin@teamone.org"
		],
		members: [
			id: "101", name: "Member1", email: "member1@teamone.org"
			id: "102", name: "Member2", email: "member2@teamone.org"
			id: "103", name: "Member3", email: "member3@teamone.org"
		]
	"2":
		id: "2"
		teamName: "Team Two"
		inviteCode: "BD4F9Z"
		admins: [
			id: "2", name: "Admin1", email: "admin@teamtwo.org"
		],
		members: [
			id: "201", name: "Member1", email: "member1@teamtwo.org"
			id: "202", name: "Member2", email: "member2@teamtwo.org"
			id: "203", name: "Member3", email: "member3@teamtwo.org"
		]
}


# Get one team by its id
getTeam = (parent, args, context, info) ->
	console.log "query team", args
	teamsData[args.id]		

# Create a new team
createNewTeam = (parent, args, ctx, info) ->
	console.log "createNewTeam", parent, args
	# TODO: validate args
	now = Date.now()
	newUser = args.admin
	newTeam = {
		id: dummyId(),
		teamName: args.teamName,
		inviteCode: "F3D" + now
		admins: [ newUser ]
		members: []
	}
	#TODO store new Team in DB
	newUser.id = dummyId()
	#return newly created team with admin and JWT
	{
		jwt: "dummyJWT" + now,
		team: newTeam,
		user: newUser
	}


# Just simply create any random dummy ID. (Not a spec compliant UUID)
dummyId = () -> "ID_" + Math.random().toString(16).slice(2)


# Export GraphQL resolver functions
module.exports =
	Query:
		team: getTeam
	Mutation:
		createNewTeam: createNewTeam