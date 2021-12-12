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

#
# Create a new team
#
# mutation {
# 	createNewTeam(teamName:"MyNewTeam", admin: {
# 		name: "NewTeam Admin1",
# 		email: "admin@mynewteam.org",
# 		mobilephone: "+49 555 1234565"
# 	})
# 	{ jwt team { id } user { id }}
# }
#
# @param parent the parent object, in this case the GraphQL root
# @param args { teamName admin { name email mobilephone } }
# @param ctx GraphQL context with authenticated user
# @param info (optional) global info
# @return jwt for client authentication, 
#         the team as stored in the DB (with ID)
#         and the team's admin as stored in the DB
createNewTeam = (parent, args, ctx, info) ->
	console.log "createNewTeam", args
	
	# Create new team with one first admin
	now = Date.now()
	newUser =
		id: dummyId()						# MongoDb will create internal DB "_id" but only for the team, not the embedded admins and members!
		name: args.admin.name		# args are already validated by GraphQL, nice
		email: args.admin.email
		mobilephone: args.admin.mobilephone

	newTeam =
		id: dummyId()						# This is our "liquido id" that we expose to the client. We will never expose the DB internal mongoDB "_id" field.
		teamName: args.teamName,
		inviteCode: "F3D" + now
		admins: [ newUser ]
		members: []
	
	# store new Team in DB	
	teams = ctx.db.collection('teams')
	result = await teams.insertOne(newTeam)
	console.log "createNewTeam", newTeam.teamName, "[OK]", result.insertedId

	#return newly created team with admin user and JWT to authenticate future requests
	{
		jwt: "dummyJWT" + now,
		team: newTeam,
		user: newUser
	}

# Just simply create any random dummy ID. (Not a spec compliant UUID)
dummyId = () -> "ID_" + Math.random().toString(16).slice(2).toUpperCase()


# Export GraphQL resolver functions
module.exports =
	getTeam: getTeam
	createNewTeam: createNewTeam