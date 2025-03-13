--Global variables
_ = wesnoth.textdomain "wesnoth-Town_of_Arnsreach"

--Local variables
local Current_Color_Strength_Red=0
local Current_Color_Strength_Green=0
local Current_Color_Strength_Blue=0


function ToA_Animate_Image(Total_Time_MS,Image_Path_String,Is_Halo,x,y,Optional_Data)
	
	--Optional_Data can contain Opacity_Data,Scale_Data,Rotate_Data, see example 2
	
	--Example call 1: ToA_Animate_Image(1000,"icons/boots_elven.png",false,13,21)
	
	--Will simply display an image of elven boots on the tile 12,21. The image is not a "halo" so it will not be shown on top of other things. The 1000ms input --does not matter since there is no movement happening.
	
	--Example call 2: --ToA_Animate_Image(5500,"icons/boots_elven.png",true,13,21,{["Opacity_Data"]={100,50},["Scale_Data"]={{90,60},{60,40}},["Rotate_Data"]={60,890}})
	
	--Will display the same boots on the same place. But the boots will: Grow transparent 100%->50%. Shrink from size 90x60pixels to 60x40pixels. Rotate from --60degrees to --890degrees, which are several rotations. -All this is dragged out over 5.5 seconds (5500ms). This animation is also a halo and will therefore --always show.
	
	--Ps. Removal of the image afterwards must be done manually
	
	--Example removal of example 1: wesnoth.interface.remove_hex_overlay(13, 21, "icons/boots_elven.png")
	
	--Example removal of example 2: wesnoth.interface.remove_hex_overlay(13, 21, "icons/boots_elven.png~O(50%)~SCALE(60,40)~ROTATE(890)")
	
	--Set local variables
	local MS_Between_Updates=math.min(40,Total_Time_MS)
	local Step_Count=math.floor(math.max(1,Total_Time_MS/MS_Between_Updates))
	
	--Opacity variables
	local Opacity_Start=0
	local Opacity_End=0
	local Opacity_String=""
	if Optional_Data and Optional_Data.Opacity_Data then
		Opacity_Start=Optional_Data.Opacity_Data[1]
		Opacity_End=Optional_Data.Opacity_Data[2]
		Opacity_String="~O(" .. tostring(Opacity_Start) .. "%)"
	end
	
	--Scale variables
	local Scale_Start={0,0}
	local Scale_End={0,0}
	local Scale_String=""
	if Optional_Data and Optional_Data.Scale_Data then
		Scale_Start=Optional_Data.Scale_Data[1]
		Scale_End=Optional_Data.Scale_Data[2]
		Scale_String="~SCALE(" .. tostring(Scale_Start[1]) .. tostring(Scale_Start[2]) .. ")"
	end
	
	--Opacity variables
	local Rotate_Start=0
	local Rotate_End=0
	local Rotate_String=""
	if Optional_Data and Optional_Data.Rotate_Data then
		Rotate_Start=Optional_Data.Rotate_Data[1]
		Rotate_End=Optional_Data.Rotate_Data[2]
		Rotate_String="~ROTATE(" .. tostring(Rotate_Start) .. ")"
	end
	
	--Update color 50 times per second until timer is reached
	for i=1,Step_Count do

		if i~=1 then
			
			--Remove last image
			wesnoth.interface.remove_hex_overlay(x, y, Image_Path_String .. Opacity_String .. Scale_String .. Rotate_String)
			
			--Update variables
			if Opacity_String~="" then
				Opacity_String="~O(" .. tostring(math.floor(Opacity_Start+(Opacity_End-Opacity_Start)/Step_Count*i)) .. "%)"
			end
			if Scale_String~="" then
				Scale_String="~SCALE(" .. tostring(Scale_Start[1]+math.floor((Scale_End[1]-Scale_Start[1])/Step_Count*i)) .. "," .. tostring(math.floor(Scale_Start[2]+(Scale_End[2]-Scale_Start[2])/Step_Count*i)) .. ")"
			end
			if Rotate_String~="" then
				Rotate_String="~ROTATE(" .. tostring(math.floor(Rotate_Start+(Rotate_End-Rotate_Start)/Step_Count*i)) .. ")"
			end
			
			--Assign final values when the end is reached (compensates for math.floor)
			if i==Step_Count then
				
				if Opacity_String~="" then
					Opacity_String="~O(" .. tostring(Opacity_End) .. "%)"
				end
				if Scale_String~="" then
					Scale_String="~SCALE(" .. tostring(Scale_End[1]) .. "," .. tostring(Scale_End[2]) .. ")"
				end
				if Rotate_String~="" then
					Rotate_String="~ROTATE(" .. tostring(Rotate_End) .. ")"
				end
			end
			
		end
		
		--Set next image
		if Is_Halo then
			wesnoth.interface.add_hex_overlay(x, y, {x = x, y = y, halo = Image_Path_String .. Opacity_String .. Scale_String .. Rotate_String})
		else
			wesnoth.interface.add_hex_overlay(x, y, {x = x, y = y, image = Image_Path_String .. Opacity_String .. Scale_String .. Rotate_String})
		end
		
		--Timer between each update (20ms -> 50 times per second)
		wesnoth.interface.delay(MS_Between_Updates)
		
	end
	
	--Debug code
	--wesnoth.interface.add_chat_message(" ImageSTR: " ..Image_Path_String .. " X: " .. x.. " Y: " ..y.. " Rotate: " .. Rotate_String ..  " Scale: " ..Scale_String --.." Opacity: "..Opacity_String)
	
	--Wait out any remaining time (compensates for math.floor)
	wesnoth.interface.delay(Total_Time_MS-Step_Count*MS_Between_Updates)
end

function ToA_Animate_Colors(Total_Time_MS, Final_Color_Strength_Red, Final_Color_Strength_Green, Final_Color_Strength_Blue)
	
	--Example call 1: ToA_Animate_Colors(37000, 100, 150, 100)

	--Will gradually shift the screen color towards a brighter green. Over the span of 37 seconds
	
	--Example call 2: ToA_Animate_Colors(1000, -255, -255, -255)
	
	--Will quickly darken the screen to pitch black, over 1 second.
	
	--Example call 3: ToA_Animate_Colors(1050, 0, 0, 0)
	
	--Will reset your screen colors to standard, over 1.05 seconds.
	
	--Set local variables
	local MS_Between_Updates=math.min(40,Total_Time_MS)
	local Initial_Color_Strength_Red=Current_Color_Strength_Red
	local Initial_Color_Strength_Green=Current_Color_Strength_Green
	local Initial_Color_Strength_Blue=Current_Color_Strength_Blue
	local Step_Count=math.floor(math.max(1,Total_Time_MS/MS_Between_Updates))
	
	--Update color 50 times per second until timer is reached
	for i=1,Step_Count do
		Current_Color_Strength_Red=Initial_Color_Strength_Red+math.floor((Final_Color_Strength_Red-Initial_Color_Strength_Red)/Step_Count*i)	
		Current_Color_Strength_Green=Initial_Color_Strength_Green+math.floor((Final_Color_Strength_Green-Initial_Color_Strength_Green)/Step_Count*i)
		Current_Color_Strength_Blue=Initial_Color_Strength_Blue+math.floor((Final_Color_Strength_Blue-Initial_Color_Strength_Blue)/Step_Count*i)
		
		--Assign final value when the end is reached (compensates for math.floor)
		if i==Step_Count then
			Current_Color_Strength_Red=Final_Color_Strength_Red
			Current_Color_Strength_Green=Final_Color_Strength_Green
			Current_Color_Strength_Blue=Final_Color_Strength_Blue
		end
		
		--Set the new color
		wesnoth.interface.color_adjust(Current_Color_Strength_Red, Current_Color_Strength_Green, Current_Color_Strength_Blue)
		
		--Timer between each update (20ms -> 50 times per second)
		wesnoth.interface.delay(MS_Between_Updates)
		
	end
	
	--Wait out any remaining time (compensates for math.floor)
	wesnoth.interface.delay(Total_Time_MS-Step_Count*MS_Between_Updates)
end

function ToA_New_Scene_Start(Table)
	if not Table.Fast then 
		wesnoth.audio.play("data/add-ons/Town_of_Arnsreach_Resources_1/sounds/time_passing.wav")
		wesnoth.interface.screen_fade({-255, -255, -255, 255}, 1000)
	else
		wesnoth.interface.screen_fade({-255, -255, -255, 255}, 500)
	end
end

function ToA_New_Scene_Finish(Table)
	if not Table.Fast then
		wesnoth.interface.scroll_to_hex(Table.Map_Location_X, Table.Map_Location_Y, false, true)
		wesnoth.interface.delay(500)
		wesnoth.interface.add_overlay_text(Table.Text, {location={0,0}, duration=2000+string.len(Table.Text)*50, valign="center", halign="center", size=Table.Text_Size, color={150,150,150}, fade_time=2000})
		wesnoth.interface.add_hex_overlay(Table.Map_Location_X, Table.Map_Location_Y, {halo="data/add-ons/Town_of_Arnsreach_Resources_1/images/misc/Time_Passing_Animation/00[01~30].png:100"})
		wesnoth.interface.screen_fade({0, 0, 0, 0}, 2900)
		wesnoth.interface.remove_hex_overlay(Table.Map_Location_X, Table.Map_Location_Y, "data/add-ons/Town_of_Arnsreach_Resources_1/images/misc/Time_Passing_Animation/00[01~30].png:100")
	else
		wesnoth.interface.scroll_to_hex(Table.Map_Location_X, Table.Map_Location_Y, false, true)
		wesnoth.interface.add_overlay_text(Table.Text, {location={0,0}, duration=1000+string.len(Table.Text)*50, valign="center", halign="center", size=Table.Text_Size, color={150,150,150}, fade_time=1000})
		wesnoth.interface.screen_fade({0, 0, 0, 0}, 500)
	end
end	

function ToA_Upgrade_Character(id)
	local unit=wesnoth.units.get(id)
	if id=="gar" then
	elseif  id=="merissa" then
	elseif  id=="mudoc" then
	elseif  id=="sodry" then
	end
end

function ToA_Update_Town_Over_Years(years)
	local remaining_time=years
	local population_growth = 0
	local prosperity_growth = 0
	local valuables_growth = 0
	local population=wml.variables["ToA.Town.Population"]
	local prosperity=wml.variables["ToA.Town.Prosperity"]
	local valuables=wml.variables["ToA.Town.Valuables"]
	
	--Full years change
	for i=1,math.floor(years) do
		remaining_time=remaining_time-1
		
		population_growth = 2+population*((prosperity/math.min(1,population)-1)/10+0.02)
		prosperity_growth = 0.02*prosperity+5
		valuables_growth = (10+prosperity/20)
	
		population=population+population_growth
		prosperity=prosperity+prosperity_growth
		valuables=valuables+valuables_growth
	end
	
	--Leftover part of year change
	if remaining_time~=0 then
		population_growth = (2+population*((prosperity/math.min(1,population)-1)/10+0.02))*remaining_time
		prosperity_growth = (0.02*prosperity+5)*remaining_time
		valuables_growth = (10+prosperity/20)*remaining_time
	
		population=population+population_growth
		prosperity=prosperity+prosperity_growth
		valuables=valuables+valuables_growth
	end
	
	wml.variables["ToA.Town.Population"]=math.floor(population)
	wml.variables["ToA.Town.Prosperity"]=math.floor(prosperity)
	wml.variables["ToA.Town.Valuables"]=math.floor(valuables)
end

function ToA_Ini_Campaign_Variables()
	if not wml.variables["ToA.Campaign_General"] then
		wml.variables["ToA.Characters.Gar.Level"]=1
		wml.variables["ToA.Characters.Gar.Sword"]=false
		
		wml.variables["ToA.Characters.Merissa.Level"]=1
		
		wml.variables["ToA.Characters.Mudoc.Level"]=1
		
		wml.variables["ToA.Characters.Sodry.Level"]=1
		
		wml.variables["ToA.Town.Population"]=0
		wml.variables["ToA.Town.Prosperity"]=0
		wml.variables["ToA.Town.Valuables"]=0
		
		wml.variables["ToA.Scenario_Specific"]={}
		
		wml.variables["ToA.Campaign_General"]={}
		wml.variables["ToA.Campaign_General.Finished_Last_Scenario"]=false
	end
end