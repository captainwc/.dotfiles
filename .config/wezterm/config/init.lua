local wezterm = require('wezterm')

---@class Config
---@field options table
local Config = {}
Config.__index = Config

---Initialize Config
---@return Config
function Config:init()
   local config = setmetatable({ options = {} }, self)
   return config
end

---Append to `Config.options`
---@param new_options table new options to append
---@return Config
function Config:append(new_options)
   for k, v in pairs(new_options) do
      if self.options[k] ~= nil then
         wezterm.log_warn(
            'Duplicate config option detected: ',
            { old = self.options[k], new = new_options[k] }
         )
         goto continue
      end
      self.options[k] = v
      ::continue::
   end
   return self
end

-- position
wezterm.on("window-config-reloaded", function(window, pane)
	local id = tostring(window:window_id())
	local seen = wezterm.GLOBAL.seen_windows or {}
	local is_new_window = not seen[id]
	seen[id] = true
	wezterm.GLOBAL.seen_windows = seen
	if is_new_window then
		window:set_position(373, 118)
	end
end)

return Config
