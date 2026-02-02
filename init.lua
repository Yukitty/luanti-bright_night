--[[
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
]]

-- engine const
local SUNLIGHT = 15

-- mod config
local night_light = math.max(math.min(tonumber(core.settings:get("bright_night_light")) or 4, 15), 3)
local dawn = ({0.1979, 0.2049, 0.2118, 0.2170, 0.2216, 0.2259, 0.2299, 0.2339, 0.2374, 0.2409, 0.2443, 0.2497, 0.25})[night_light-2]
local dusk = ({0.7952, 0.7882, 0.7831, 0.7784, 0.7741, 0.7702, 0.7662, 0.7626, 0.7592, 0.7557, 0.7503, 0.7402, 0.74})[night_light-2]

-- runtime variables
local night_mode = false

-- methods
local function set_night(player)
	player:override_day_night_ratio(night_light / SUNLIGHT)
end

local function unset_night(player)
	player:override_day_night_ratio(nil)
end

-- callbacks
core.register_on_joinplayer(function(player)
	if night_mode then
		set_night(player)
	end
end)

core.register_globalstep(function()
	local time = core.get_timeofday()
	if time < dawn or time > dusk then
		if not night_mode then
			night_mode = true
			for _, player in ipairs(core.get_connected_players()) do
				set_night(player)
			end
		end
	elseif night_mode then
		night_mode = false
		for _, player in ipairs(core.get_connected_players()) do
			unset_night(player)
		end
	end
end)

