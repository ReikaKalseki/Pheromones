require "config"
require "constants"

function isInChunk(x, y, chunk)
	local minx = math.min(chunk.left_top.x, chunk.right_bottom.x)
	local miny = math.min(chunk.left_top.y, chunk.right_bottom.y)
	local maxx = math.max(chunk.left_top.x, chunk.right_bottom.x)
	local maxy = math.max(chunk.left_top.y, chunk.right_bottom.y)
	return x >= minx and x <= maxx and y >= miny and y <= maxy
end

function cantorCombine(a, b)
	--a = (a+1024)%16384
	--b = b%16384
	local k1 = a*2
	local k2 = b*2
	if a < 0 then
		k1 = a*-2-1
	end
	if b < 0 then
		k2 = b*-2-1
	end
	return 0.5*(k1 + k2)*(k1 + k2 + 1) + k2
end

function createSeed(surface, x, y) --Used by Minecraft MapGen
	local seed = surface.map_gen_settings.seed
	if Config.seedMixin ~= 0 then
		seed = bit32.band(cantorCombine(seed, Config.seedMixin), 2147483647)
	end
	return bit32.band(cantorCombine(seed, cantorCombine(x, y)), 2147483647)
end

function frenzyNearBiters(vent)
	local biters = vent.surface.find_enemy_units(vent.position, 15, vent.force)
	if #biters <= 1 then return end
	for _,biter in pairs(biters) do
		local target = biters[math.random(#biters)]
		while target == biter do
			target = biters[math.random(#biters)]
		end
		local command = {type = defines.command.attack, target = target, distraction = defines.distraction.none}
		biter.set_command(command)
	end
end

function scatterNearBiters(vent)
	local biters = vent.surface.find_enemy_units(vent.position, 18, vent.force)
	for _,biter in pairs(biters) do
		local command = {type = defines.command.flee, from = vent, distraction = defines.distraction.by_damage}
		biter.set_command(command)
	end
end

function attractNearBiters(vent)
	local biters = vent.surface.find_enemy_units(vent.position, 60, vent.force)
	for _,biter in pairs(biters) do
		local command = {type = defines.command.go_to_location, destination_entity = vent, distraction = defines.distraction.by_damage, radius = 7}
		biter.set_command(command)
	end
end

function pacifyNearBiters(vent)
	local biters = vent.surface.find_enemy_units(vent.position, 30, vent.force)
	for _,biter in pairs(biters) do
		local command = {type = defines.command.wander, destination_entity = vent, distraction = defines.distraction.by_damage, radius = 30, ticks_to_wait = 60*90}
		biter.set_command(command)
	end
end

function reduceEvo(vent)
	local force = game.forces.enemy
	local fac = force.evolution_factor+1
	local base = (fac^2)/16
	local reduction = math.max(0.05, math.min(0.2, base))
	local round = 0.0005
	reduction = math.floor(reduction/round+0.5)*round
	force.evolution_factor = math.max(0, force.evolution_factor-reduction)
end

function getPheromoneEmitterByRadar(phero, radar)
	return phero.entries[phero.radars[radar.unit_number]]
end

function getPheromoneEmitterByVent(phero, vent)
	return phero.entries[phero.vents[vent.unit_number]]
end

local function createKey(entry)
	return entry.vent.unit_number .. "~" .. entry.radar.unit_number
end

local function addEntry(phero, entry)
	phero.vents[entry.vent.unit_number] = entry.key
	phero.radars[entry.radar.unit_number] = entry.key
	phero.entries[entry.key] = entry
end

local function createEntry(vent)
	local entry = {vent = vent}
	entry.radar = vent.surface.create_entity{name = "pheromone-emitter-trigger", position = vent.position, force = vent.force}
	entry.key = createKey(entry)
	--game.print("Key is ".. entry.key)
	return entry
end

local function removeEntry(phero, vent)
	local entry = getPheromoneEmitterByVent(phero, vent)
	if not entry then game.print("Vent " .. vent.unit_number .. " had no matching entry!?") return end
	phero.vents[vent.unit_number] = nil
	phero.radars[entry.radar.unit_number] = nil
	phero.entries[entry.key] = nil
	entry.radar.destroy()
end

function addPheromoneEmitter(phero, entity)
	if entity.name == "pheromone-emitter" then
		--game.print("handling phero")
		local entry = createEntry(entity)
		addEntry(phero, entry)
		--entity.operable = false
		--game.print(entry.key)
	end
end

function removePheromoneEmitter(phero, entity)
	if entity.name == "pheromone-emitter" then
		removeEntry(phero, entity)
	end
end