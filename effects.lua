require "__DragonIndustries__.color"
require "__DragonIndustries__.recipe"

effects = {}

local function runCallback(entry, phero)
	local func = effects[phero].call
	if func then
		--game.print("Running callback for phero " .. phero)
		return func(entry.vent)
	else
		game.print("Could not find callback for entity " .. entry.vent.name .. ", phero = " .. phero .. "!")
		return 0
	end
end

function getEffect(id)
	return effects[id]
end

local function getEffectID(gas)
	if (string.find(gas, "biter-pheromone-", 1, true)) then
		local sub = string.sub(gas, string.len("biter-pheromone-")+1, -string.len("-gas")-1)
		--game.print("Gas " .. gas .. " mapped to " .. sub)
		return sub
	end
end

function tickEffect(entry, gas)
	local phero = getEffectID(gas)
	--game.print("Ticking " .. entry.vent.name .. " > " .. phero)
	entry.vent.surface.create_trivial_smoke{name = "pheromone-cloud-" .. phero, position = entry.vent.position}
	runCallback(entry, phero)
end

local ingredients = {}

local function addIngredient(effect, item, fallback, amt, fallbackamt)
	if amt == nil and fallbackamt == nil and type(fallback) == "number" then
		amt = fallback
		fallback = nil
	end
	local items = ingredients[effect]
	if not items then
		items = {}
		ingredients[effect] = items
	end
	local val = tryLoadItemWithFallback(item, amt, fallback, fallbackamt)
	if val then
		table.insert(items, val)
	end
end

if data and data.raw and not game then
	addIngredient("pacify", "ethanol", "sulfur", 30, 1)
	addIngredient("pacify", "resin", "wood", 6, 4)

	addIngredient("attract", "acetone", "solid-fuel", 20, 1)
	addIngredient("attract", "cooked-biter", "fish", 1)
	addIngredient("attract", "calcium-chloride", 1)

	addIngredient("scatter", "ammonia", "poison-capsule", 40, 1)
	addIngredient("scatter", "biter-flesh", "explosives", 2)

	addIngredient("frenzy", "biter-flesh", 5)
	addIngredient("frenzy", "nitric-oxide", "crude-oil", 40)
	addIngredient("frenzy", "sodium-hydroxide", "uranium-238", 2)

	addIngredient("evoreduce", "benzene", 50)
	addIngredient("evoreduce", "hydrogen-chloride", "sulfuric-acid", 20)
	addIngredient("evoreduce", "lithium-perchlorate", "rocket-fuel", 3, 2)
	addIngredient("evoreduce", "silver-nitrate", "chemical-science-pack", 2, 3)
	
	if data.raw.item["silver-nitrate"] == nil then
		addIngredient("evoreduce", "space-science-pack", 5)
	end
end

local function addEffect(variant, callFunc, tickRate, color)	
	color = convertColor(color, true)
	
	if data and data.raw and not game then
		local ico = "__Pheromones__/graphics/icons/" .. variant .. ".png"
		local name = "biter-pheromone-" .. variant
		local time = 1/tickRate
		local crafttime = math.max(1, math.ceil(math.sqrt(time/4)))
		
		local fluid = {
			type = "fluid",
			name = name,
			icons = {{icon = "__Pheromones__/graphics/icons/fluid/base.png", tint = color}},
			icon_size = 32,
			default_temperature = 40,
			max_temperature = 40,
			order = "a[fluid]-a[water]",
			pressure_to_speed_ratio = 0.3,
			flow_to_energy_ratio = 0.59,
			heat_capacity = "10J",
			base_color = color,
			flow_color = {r=math.sqrt(color.r), g = math.sqrt(color.g), b=math.sqrt(color.b)},
			localised_name = {"pheromone.base", {"pheromone." .. variant}}
		}
		
		local gas = table.deepcopy(fluid);
		gas.name = gas.name .. "-gas"
		gas.icons[1].icon = "__Pheromones__/graphics/icons/fluid/base-gas.png"
		gas.hidden = true
		
		local cloudtime = 60*math.min(15, crafttime*2.5)
		
		local cloud = {
			type = "trivial-smoke",
			name = "pheromone-cloud-" .. variant,
			icon_size = 32,
			icons = gas.icons,
			flags = {"not-on-map"},
			show_when_smoke_off = true,
			animation =
			{
			  filename = "__base__/graphics/entity/cloud/cloud-45-frames.png",
			  priority = "low",
			  width = 256,
			  height = 256,
			  frame_count = 45,
			  animation_speed = 1,
			  line_length = 7,
			  scale = 3,
			},
			slow_down_factor = 0,
			affected_by_wind = true,
			cyclic = true,
			duration = cloudtime,
			fade_away_duration = math.ceil(cloudtime/3),
			spread_duration = math.ceil(cloudtime/5),
			color = color,
			localised_name = fluid.localised_name
		}
		
		local input = {}
		local fluids = 0
		local add = ingredients[variant]
		if add then
			for _,item in pairs(add) do
				table.insert(input, item)
				if item.type == "fluid" then
					fluids = fluids+1
				end
			end
		end
		
		if fluids < 2 then
			table.insert(input, {type = "fluid", name = data.raw.fluid["pure-water"] and "pure-water" or "water", amount = 80})
		else
			table.insert(input, {type = "item", name = data.raw.fluid["pure-water"] and "pure-water-barrel" or "water-barrel", amount = 2})
		end
		
		local recipe = {
			type = "recipe",
			name = "pheromone-" .. variant,
			icons = fluid.icons,
			icon_size = 32,
			category = "chemistry",
			energy_required = crafttime,
			ingredients = input,
			results = {
				{type = "fluid", name = fluid.name, amount = 40}
			},
			crafting_machine_tint =
			{
			  primary = color,
			  secondary = color,
			  tertiary = color,
			  quaternary = color,
			},
			localised_name = fluid.localised_name
		}
		
		local dump = {
			type = "recipe",
			name = "pheromone-venting-" .. variant,
			icons = gas.icons,
			icon_size = 32,
			category = "pheromone-dump",
			energy_required = time,
			ingredients = {
				{type = "fluid", name = fluid.name, amount = 10}
			},
			results = {
				{type = "fluid", name = gas.name, amount = 10}
			},
			crafting_machine_tint =
			{
			  primary = color,
			  secondary = color,
			  tertiary = color,
			  quaternary = color,
			},
			localised_name = fluid.localised_name
		}
		
		data:extend({cloud, fluid, gas, recipe, dump})
		
		table.insert(data.raw.technology["biter-pheromones"].effects, {type = "unlock-recipe", recipe = recipe.name})
		table.insert(data.raw.technology["biter-pheromones"].effects, {type = "unlock-recipe", recipe = dump.name})

		effects[variant] = {name = variant, fluid = fluid.name, entity = cloud.name, recipe = recipe.name, color = color, call = callFunc}
		
		return cloud
	end
end

addEffect("pacify", pacifyNearBiters, 0.25, 0x72D0FF)
addEffect("attract", attractNearBiters, 1, 0x08B208)
addEffect("scatter", scatterNearBiters, 0.5, 0x6A4CFF)
addEffect("frenzy", frenzyNearBiters, 0.25, 0xd02020)
addEffect("evoreduce", reduceEvo, 1/(60*5), 0xFFBF00) --once every 5 min