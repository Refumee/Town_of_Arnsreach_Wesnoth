local _ = wesnoth.textdomain "wesnoth-Town_of_Arnsreach"

local oldf_game_display_gold = wesnoth.interface.game_display.gold
function wesnoth.interface.game_display.gold()
	local g = oldf_game_display_gold()
	if wesnoth.current.side == 1 then
		g[1][2].tooltip=_"Valuables".."\n \n".._"Wealth allocated to your soldiers, to spend how you see fit."
		g[1][2].text=wml.variables["ToA_valuables"] or 0
	end
	return g
end

local oldf_game_display_villages = wesnoth.interface.game_display.villages
function wesnoth.interface.game_display.villages()
	local g = oldf_game_display_villages()
	if wesnoth.current.side == 1 then
		g[1][2].text=wml.variables["ToA_prosperity"] or 0
		g[1][2].tooltip=_"Prosperity".."\n \n".._"An indicator of how well your townspeople are doing. The more the better."
	end
	return g
end

local oldf_game_display_num_units = wesnoth.interface.game_display.num_units
function wesnoth.interface.game_display.num_units()
	local g = oldf_game_display_num_units()
	if wesnoth.current.side == 1 then
		g[1][2].text=wml.variables["ToA_population"] or 0
		g[1][2].tooltip=_"Population".."\n \n".._"The number of citizens living in your town. The more the better."
	end
	return g
end

local oldf_game_display_upkeep = wesnoth.interface.game_display.upkeep
function wesnoth.interface.game_display.upkeep()
	local g = oldf_game_display_upkeep()
	if wesnoth.current.side == 1 then
		g[1][2].text=_""
		g[1][2].tooltip=_"Not used"
	end
	return g
end

local oldf_game_display_income = wesnoth.interface.game_display.income
function wesnoth.interface.game_display.income()
	local g = oldf_game_display_income()
	if wesnoth.current.side == 1 then
		g[1][2].text=_""
		g[1][2].tooltip=_"Not used"
	end
	return g
end