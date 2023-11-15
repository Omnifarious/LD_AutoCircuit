local technology_to_unlock
if data.raw["technology"]["circuit-network"] then
    technology_to_unlock = "circuit-network"
end

data:extend(
{
   {
      type = "shortcut",
      name = "ld-autocircuit-shortcut",
      order = "zzz",
      action = "lua",
      technology_to_unlock = technology_to_unlock,
      toggleable = true,
      icon =
         {
            filename = "__LD_AutoCircuit__/icons/ld-autocircuit-button.png",
            priority = "extra-high-no-scale",
            size = 32,
            scale = 1,
            flags = { "icon" }
         }
   }
})
