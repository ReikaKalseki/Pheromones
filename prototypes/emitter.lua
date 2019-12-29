require "constants"

data:extend({
  {
    type = "assembling-machine",
    name = "pheromone-emitter",
    icon = "__Pheromones__/graphics/icons/pheromone-emitter.png",
	icon_size = 32,
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 0.5, result = "pheromone-emitter"},
    fast_replaceable_group = "pheromone-emitter",
    max_health = 500,
    corpse = "big-remnants",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 1,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }},
        secondary_draw_orders = { north = -1 }
      },
      {
        production_type = "output",
        pipe_picture = assembler3pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 0.1,
        base_level = 1,
        pipe_connections = {--[[{ type="output", position = {0, 2} }--]]},
        secondary_draw_orders = { north = -1 }
      },
      off_when_no_fluid_recipe = false
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    working_sound =
    {
      sound = { { filename = "__Pheromones__/sound/venter.ogg", volume = 0.4 } },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_categories = {"pheromone-dump"},
    source_inventory_size = 1,
    result_inventory_size = 1,
    crafting_speed = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = 2,
      smoke =
      {
        {
          name = "smoke",
          frequency = 10,
          position = {0.7, -1.2},
          starting_vertical_speed = 0.08,
          starting_frame_deviation = 60
        }
      }
    },
    energy_usage = "100kW",
    ingredient_count = 1,
    module_slots = 0,
    allowed_effects = nil, --no modules
    animation =
    {
      layers =
      {
        {
          filename = "__Pheromones__/graphics/entity/emitter/emitter-base.png",
          priority = "high",
          width = 129,
          height = 112,
          frame_count = 1,
          shift = {0.421875, -0.25},
          hr_version =
          {
            filename = "__Pheromones__/graphics/entity/emitter/hr-emitter.png",
            priority = "high",
            width = 239,
            height = 256,
            frame_count = 1,
            shift = util.by_pixel(0.75, 5.75-14),
            scale = 0.5
          }
        },
        {
          filename = "__Pheromones__/graphics/entity/emitter/emitter-shadow.png",
          priority = "high",
          width = 129,
          height = 100,
          frame_count = 1,
          shift = {0.421875, 0},
          draw_as_shadow = true,
          hr_version =
          {
            filename = "__Pheromones__/graphics/entity/emitter/hr-emitter-shadow.png",
            priority = "high",
            width = 227,
            height = 171,
            frame_count = 1,
            draw_as_shadow = true,
            shift = util.by_pixel(11.25, 7.75),
            scale = 0.5
          }
        }
      }
    },
    working_visualisations =
    {
      {
        animation =
        {
          filename = "__Pheromones__/graphics/entity/emitter/emitter-propeller-1.png",
          priority = "high",
          width = 19,
          height = 13,
          frame_count = 4,
          animation_speed = 0.5,
          shift = {-0.671875, -1.140625},
          hr_version =
          {
            filename = "__Pheromones__/graphics/entity/emitter/hr-emitter-propeller-1.png",
            priority = "high",
            width = 37,
            height = 25,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(-20.5, -23.5),
            scale = 0.5
          }
        }
      },
      {
        animation =
        {
          filename = "__Pheromones__/graphics/entity/emitter/emitter-propeller-2.png",
          priority = "high",
          width = 12,
          height = 9,
          frame_count = 4,
          animation_speed = 0.5,
          shift = {0.0625, -2.234375},
          hr_version =
          {
            filename = "__Pheromones__/graphics/entity/emitter/hr-emitter-propeller-2.png",
            priority = "high",
            width = 23,
            height = 15,
            frame_count = 4,
            animation_speed = 0.5,
            shift = util.by_pixel(3.5, -43),
            scale = 0.5
          }
        }
      },
      {
        apply_recipe_tint = "primary",
        fadeout = true,
        constant_speed = true,
        render_layer = "wires",
        animation =
        {
          filename = "__Pheromones__/graphics/entity/emitter/smoke.png",
          frame_count = 47,
          line_length = 16,
          width = 46,
          height = 94,
          animation_speed = 0.5,
          shift = util.by_pixel(15, -99),
          hr_version =
          {
            filename = "__Pheromones__/graphics/entity/emitter/smoke-hr.png",
            frame_count = 47,
            line_length = 16,
            width = 90,
            height = 188,
            animation_speed = 0.5,
            shift = util.by_pixel(15, -99),
            scale = 0.5
          }
        }
      },
    },
  },
  {
    type = "radar",
    name = "pheromone-emitter-trigger",
    icon = "__core__/graphics/empty.png",
    icon_size = 1,
    flags = {"placeable-off-grid", "not-on-map", "not-blueprintable", "not-deconstructable"},
    max_health = 100,
	destructible = false,
	selectable_in_game = false,
    corpse = "small-remnants",
	collision_mask = {},
    energy_per_sector = "100kJ", --1s
    max_distance_of_sector_revealed = 0,
    max_distance_of_nearby_sector_revealed = 0,
    energy_per_nearby_scan = "100GJ",
    energy_source =
    {
      type = "void",
      usage_priority = "secondary-input"
    },
    energy_usage = "100kW",
    pictures =
    {
      layers =
      {
        {
          filename = "__core__/graphics/empty.png",
          priority = "low",
          width = 1,
          height = 1,
          direction_count = 1,
        },
      }
    },
    --vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound = nil,
    radius_minimap_visualisation_color = { r = 0, g = 0, b = 0, a = 0 },
    rotation_speed = 0.01
  },
})

data:extend({
  {
    type = "item",
    name = "pheromone-emitter",
    icon = "__Pheromones__/graphics/icons/pheromone-emitter.png",
    flags = {  },
    subgroup = "defensive-structure",
    order = "f[pheromone-emitter]",
    place_result = "pheromone-emitter",
    stack_size = 10,
	icon_size = 32
  }
})

data:extend({
  {
    type = "recipe-category",
    name = "pheromone-dump"
  }
})

data:extend({
  {
    type = "recipe",
    name = "pheromone-emitter",
    icon = "__Pheromones__/graphics/icons/pheromone-emitter.png",
	icon_size = 32,
    energy_required = 10,
    enabled = "false",
    ingredients =
    {
      {"assembling-machine-2", 1},
      {"electronic-circuit", 8},
      {"stone-brick", 4}
    },
    result = "pheromone-emitter"
  },
})

