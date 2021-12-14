// Configuration for development

merge = require('deepmerge')
local_config = require('./config.local.js')   // include local config with credentials

const dev_config = {
	liquido: {
		db: {
			user: "liquido-dev-user",
			//"pass": <is merged from local.config.js>
    	dbName: "Liquido-dev",
			//servers: "liquido-cluster0-shard-00-00.7onri.mongodb.net:27017,liquido-cluster0-shard-00-01.7onri.mongodb.net:27017,liquido-cluster0-shard-00-02.7onri.mongodb.net:27017"
			servers: "liquido-cluster0-shard-00-02.7onri.mongodb.net:27017"
		}  
	}
}

config = merge(dev_config, local_config)   //local will overwrite dev!

config.liquido.db["URI"] = `mongodb://${config.liquido.db.user}:${config.liquido.db.pass}@${config.liquido.db.servers}/${config.liquido.db.dbName}?authSource=admin&replicaSet=atlas-d44aci-shard-0&w=majority&readPreference=primary&appname=MongoDB%20Compass&retryWrites=true&directConnection=true&ssl=true`

module.exports = config

    

		