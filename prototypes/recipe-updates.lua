require "effects"

if data.raw.tool["biter-flesh"] then
	table.insert(data.raw.technology["biter-pheromones"].unit.ingredients, {"biter-flesh", 1})
	--[[
	for name,eff in pairs(effects) do
		table.insert(data.raw.recipe[eff.recipe].ingredients, {type = "item", name = "biter-flesh", amount = 2})
	end
	--]]
end

for name,eff in pairs(effects) do
	markForProductivityAllowed(eff.recipe)
end