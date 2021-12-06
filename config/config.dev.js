// Configuration for local development

const config = {
	liquido: {
		db: {
			user: "liquido-int-user",
			//You must pass the password from the environment
    	dbName: "Liquido-INT"
		}  
	}
}

config.liquido.db["URI"] = "mongodb+srv://" + config.liquido.db.user + ":" + process.env.DB_PASS +  "@liquido-int.2geyy.mongodb.net/myFirstDatabase?retryWrites=true&w=majority",

module.exports = config

    

		