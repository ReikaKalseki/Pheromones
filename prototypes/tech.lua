data:extend(
{
   {
    type = "technology",
    name = "biter-pheromones",
    prerequisites =
    {
		"advanced-oil-processing",
    },
    icon = "__Pheromones__/graphics/technology/pheromones.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "pheromone-emitter"
      }
    },
    unit =
    {
      count = 400,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"military-science-pack", 1},
      },
      time = 40
    },
    order = "[steam]-2",
	icon_size = 128,
  },
}
)