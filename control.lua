require "config"
require "constants"
require "functions"
require "effects"

require "tracker-hooks"

local ranTick = false

function initGlobal(markDirty)
	if not global.phero then
		global.phero = {}
	end
	local phero = global.phero
	if phero.vents == nil then
		phero.vents = {}
	end
	if phero.radars == nil then
		phero.radars = {}
	end
	if phero.entries == nil then
		phero.entries = {}
	end
	phero.dirty = markDirty
end

script.on_configuration_changed(function(data)
	initGlobal(true)
end)

script.on_init(function()
	initGlobal(true)
end)

local function onEntityAdded(event)
	local phero = global.phero
	local entity = event.created_entity
	trackEntityAddition(entity, phero)
end

local function onEntityRemoved(event)
	local phero = global.phero
	trackEntityRemoval(event.entity, phero)
end

script.on_event(defines.events.on_trigger_created_entity, function(event)
	--tickEffect(event.entity)
end)

script.on_event(defines.events.on_sector_scanned, function(event)
	if event.radar.name == "pheromone-emitter-trigger" then
		local entry = getPheromoneEmitterByRadar(global.phero, event.radar)
		if entry then
			local vent = entry.vent
			--game.print(vent.fluidbox[2] and vent.fluidbox[2].valid)
			local gas = vent.fluidbox[2] --output
			if gas then
				--game.print(gas.name .. " x" .. gas.amount)
				if gas.amount >= 10 then
					tickEffect(entry, gas.name)
					gas.amount = math.max(0, gas.amount-10)
					vent.fluidbox[2] = gas.amount > 0 and gas or nil
				end
			end
		else
			game.print("Phero trigger has no entry?!")
		end
	end
end)

local function controlChunk(surface, area)
	
end

local function onEntityDied(event)
	onEntityRemoved(event)
end

script.on_event(defines.events.on_entity_died, onEntityDied)
script.on_event(defines.events.on_pre_player_mined_item, onEntityRemoved)
script.on_event(defines.events.on_robot_pre_mined, onEntityRemoved)
script.on_event(defines.events.script_raised_destroy, onEntityRemoved)

script.on_event(defines.events.on_built_entity, onEntityAdded)
script.on_event(defines.events.on_robot_built_entity, onEntityAdded)
--[[
script.on_event(defines.events.on_chunk_generated, function(event)
	controlChunk(event.surface, event.area)
end)
--]]

--[[
script.on_event(defines.events.on_tick, function(event)	
	
end)
--]]