require "__DragonIndustries__/entitytracker"

require "functions"
require "constants"
require "config"

function getGlobal()
	return global.phero
end

--remote.call("human interactor", "bye", "dear reader")

addTracker("pheromone-emitter",					addPheromoneEmitter,		removePheromoneEmitter,			nil,						"phero",	getGlobal())