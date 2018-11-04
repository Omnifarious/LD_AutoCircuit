local conf_enable = setmetatable({}, {
	__index = function(self, id)
		local v = settings.get_player_settings(game.players[id])["ld_autocircuit-enabled"].value
		rawset(self, id, v)
		return v
	end
})

script.on_event(defines.events.on_runtime_mod_setting_changed,
                function(event)
                   if not event or not event.setting then
                      return
                   end
                   if event.setting == "ld_autocircuit-enabled" then
                      conf_enable[event.player_index] = nil
                   end
end)

local function is_long_distance_pole(entity)
   if entity.type != "electric-pole" then
      return false
   elseif entity.supply_area_distance > 2 then
      return false
   elseif entity.maximum_wire_distance < 30 then
      return false
   else
      return true
   end
end

local function has_red_wire(pole)
   local redwires = pole.neighbors["red"]
   return (redwires ~= nil) and (#redwires > 0)

local function has_green_wire(pole)
   local greenwires = pole.neighbors["green"]
   return (redwires ~= nil) and (#redwires > 0)

script.on_event(defines.events.on_built_entity, function(event)
   if not conf_enable then
      return
   end
   local entity = event.created_entity
   if (not entity) or (not is_long_distance_pole(entity)) then
      return
   end
   local copperbuddies = entity.neighbors["copper"]
   if not copperbuddies then
      return
   end
   local otherpole
   local newconnects = {}
   for _, otherpole in pairs(copperbuddies) do
      if is_long_distance_pole(otherpole) then
         if has_red_wire(otherpole) then
            newconnects[#newconnects + 1] = {wire = defines.wire_type.red,
                                             target_entity = otherpole}
         end
         if has_green_wire(otherpole) then
            newconnects[#newconnects + 1] = {wire = defines.wire_type.green,
                                             target_entity = otherpole}
         end
      end
   end
   local newconnect
   for _, newconnect in pairs(newconnects) do
      entity.connect_neighbor(newconnect)
