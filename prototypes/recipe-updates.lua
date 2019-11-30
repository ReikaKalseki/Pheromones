require "effects"

if data.raw.tool["biter-flesh"] then
	table.insert(data.raw.technology["biter-pheromones"].unit.ingredients, {"biter-flesh", 1})
	--[[
	for _,k in pairs(getAllEffects()) do
		local recipe = data.raw.recipe["pheromone-" .. k]
		table.insert(recipe.ingredients, {type = "item", name = "biter-flesh", amount = 2})
	end
	--]]
end